********************************************************************************
*                  BASE ESTADO DE SP - DISSERTACAO                             *
********************************************************************************

//Isabela Innocente Gomes de Oliveira

clear all

//defining paths

global isabela 1

if $isabela	     {
	global 		user 	"C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP"
}
*
cd "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP"

gl link "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\dados link"

***************************************
*    1. cleaning the data by year     *
***************************************


forvalue i = 2010(1)2019 {

import delimited "$link\alunos_siblings_`i'.csv", encoding(UTF-8) 


//1.1 data nascimento
split dt_nascmto, p(" ")
split dt_nascmto1, p("-")

rename dt_nascmto11 ano_nasc
rename dt_nascmto12 mes_nasc
rename dt_nascmto13 dia_nasc

destring ano_nasc, replace 
destring mes_nasc, replace 
destring dia_nasc, replace 


rename dt_nascmto1 birthdate
drop dt_nascmto2
rename fl_gemeo twin

*estou assumindo que 2 é mulher!!
*tostring tp_sexo
gen fem = 1 if tp_sexo == "F" | tp_sexo == "2"
replace fem = 0 if tp_sexo == "M" | tp_sexo == "1"
drop tp_sexo

*assumindo que 1 é branco 
gen white = 1 if cd_cor_raca == 1
replace white = 0 if cd_cor_raca == 2 | cd_cor_raca == 3 | cd_cor_raca == 4 | cd_cor_raca == 5

tostring id_bolsa_familia, replace 
gen bf = 1 if id_bolsa_familia == "1"
replace bf = 0 if id_bolsa_familia == "0"

drop dt_nascmto id_bolsa_familia

gen year = `i'
//precisa 
*replace nr_serie = "." if nr_serie == "NULL" & year == 2018
*destring nr_serie, replace

*nao vou considerar EJA
gen serie = .
tostring serie, replace

//EF
replace serie = "1-EF" if  nr_serie == 1 & nm_tipo_ensino == "ENSINO FUNDAMENTAL DE 9 ANOS"
replace serie = "2-EF" if  nr_serie == 2 & nm_tipo_ensino == "ENSINO FUNDAMENTAL DE 9 ANOS"
replace serie = "3-EF" if  nr_serie == 3 & (nm_tipo_ensino == "ENSINO FUNDAMENTAL DE 9 ANOS" | nm_tipo_ensino == "ENSINO FUNDAMENTAL 9 ANOS - RC - 3º ANO" | nm_tipo_ensino == "ENSINO FUNDAMENTAL 9 ANOS - RCI - 3º ANO" )
replace serie = "4-EF" if  nr_serie == 4 & nm_tipo_ensino == "ENSINO FUNDAMENTAL DE 9 ANOS"
replace serie = "5-EF" if  nr_serie == 5 & nm_tipo_ensino == "ENSINO FUNDAMENTAL DE 9 ANOS"
replace serie = "6-EF" if  nr_serie == 6 & (nm_tipo_ensino == "ENSINO FUNDAMENTAL DE 9 ANOS" | nm_tipo_ensino == "ENSINO FUNDAMENTAL 9 ANOS - RC - 6º ANO" | nm_tipo_ensino == "ENSINO FUNDAMENTAL 9 ANOS - RCI - 6º ANO" )
replace serie = "7-EF" if  nr_serie == 7 & nm_tipo_ensino == "ENSINO FUNDAMENTAL DE 9 ANOS"
replace serie = "8-EF" if  nr_serie == 8 & nm_tipo_ensino == "ENSINO FUNDAMENTAL DE 9 ANOS"
replace serie = "9-EF" if  nr_serie == 9 & (nm_tipo_ensino == "ENSINO FUNDAMENTAL DE 9 ANOS" | nm_tipo_ensino == "ENSINO FUNDAMENTAL 9 ANOS - RC - 9º ANO" | nm_tipo_ensino == "ENSINO FUNDAMENTAL 9 ANOS - RCI - 9º ANO" )



//EM 
replace serie = "1-EM" if  nr_serie == 1 & (nm_tipo_ensino == "ENSINO MEDIO" | nm_tipo_ensino == "ENSINO MEDIO - VENCE")
replace serie = "2-EM" if  nr_serie == 2 & (nm_tipo_ensino == "ENSINO MEDIO" | nm_tipo_ensino == "ENSINO MEDIO - VENCE")
replace serie = "3-EM" if  nr_serie == 3 & (nm_tipo_ensino == "ENSINO MEDIO" | nm_tipo_ensino == "ENSINO MEDIO - VENCE")



*obs tem duplicados os irmãos! cuidado para nao excluir aquele com a info
preserve 
drop if nr_serie == 0
unique cd_aluno cd_irmao
restore


save "$link\total limpo\\`i'complete_siblings.dta", replace 

tab serie

clear 

}



*******************************************************
*    2. base focal child + irmao em todas cohorts     *
*******************************************************

//OBS já vamos cortar só para os alunos do primeiro ano 

use "$link\total limpo\2019complete_siblings.dta"

append using "$link\total limpo\2018complete_siblings.dta" "$link\total limpo\2017complete_siblings.dta" "$link\total limpo\2016complete_siblings.dta" "$link\total limpo\2015complete_siblings.dta" "$link\total limpo\2014complete_siblings.dta" "$link\total limpo\2013complete_siblings.dta" "$link\total limpo\2012complete_siblings.dta" "$link\total limpo\2011complete_siblings.dta" "$link\total limpo\2010complete_siblings.dta"


keep if serie == "1-EF"



*essa base tem que ser unique no nivel cd_aluno cd_irmao 
sort cd_aluno cd_irmao year 
bysort cd_aluno cd_irmao: gen temp=_n
order cd_aluno cd_irmao temp
//temos 1691 obs que se repetem: pode ser repetencia do primeiro ano (sim sao todos!!)

*vamos identificar a obs certa para criar variavel de repetencia 
*base auxiliar
preserve
keep if temp > 1
drop if temp>2
keep cd_aluno cd_irmao 
gen repetiu_prim_ano=1
save "$link\total limpo\duplicates.dta"
restore

drop if temp>1

merge 1:1 cd_aluno cd_irmao using "$link\total limpo\duplicates.dta"

replace repetiu_prim_ano = 0 if _merge ==1
drop _merge 

erase "$link\total limpo\duplicates.dta"

label data "Base focal child + sibling cohorts primeiro ano"
save "$link\total limpo\cohort_FC-S.dta", replace 







*******************************************************
*    3. base siblings + suas informações              *
*******************************************************
drop cd_aluno 

rename cd_irmao cd_aluno 
label var cd_aluno "CD do sibling"

keep cd_aluno 
*temos valores repetidos
duplicates drop

*Vamos criar 2 bases
// (1) versão só com os cd_aluno do sibling para ficar mais facil de juntar com o SARESP 
save "$link\baseirmaos.dta", replace 



//pegar as informações por ano => vamos montar um painel wide 

//2019

preserve
clear 
use "$link\total limpo\2019complete_siblings.dta"
duplicates drop cd_aluno, force
drop cd_irmao twin nm_bairro nr_cep nm_cidade sg_uf nm_zona cd_nacionalidade nm_cidade_nascmto nm_distrt_nasc nr_serie nm_tipo_ensino birthdate
order cd_aluno year ano_nasc mes_nasc dia_nasc fem white bf cd_cor_raca cod_esc

local va fem white ano_nasc mes_nasc dia_nasc serie bf cod_esc cd_cor_raca
foreach x of varlist `va' {

rename `x' `x'_2019

}

drop year 
tempfile CS201
save `CS2019'
restore 


merge 1:1 cd_aluno using `CS2019'
drop if _merge == 2
drop _merge 





*2018 
//vamos dropar cd_aluno duplicado pq nao tem problema (o aluno aparece mais de uma vez se tem mais de um irmão)
preserve
clear 
use "$link\total limpo\2018complete_siblings.dta"
duplicates drop cd_aluno, force
drop cd_irmao twin nm_bairro nr_cep nm_cidade sg_uf nm_zona cd_nacionalidade nm_cidade_nascmto nm_distrt_nasc nr_serie nm_tipo_ensino birthdate
order cd_aluno year ano_nasc mes_nasc dia_nasc fem white bf cd_cor_raca cod_esc

local va fem white ano_nasc mes_nasc dia_nasc serie bf cod_esc cd_cor_raca
foreach x of varlist `va' {

rename `x' `x'_2018

}

drop year 
tempfile CS2018
save `CS2018'
restore 


merge 1:1 cd_aluno using `CS2018'
drop if _merge == 2
drop _merge 


*loop 2017-2010

forvalue i = 2010(1)2017 {

preserve
clear 
use "$link\total limpo\\`i'complete_siblings.dta"
duplicates drop cd_aluno, force
drop cd_irmao twin nm_bairro nr_cep nm_cidade sg_uf nm_zona cd_nacionalidade nm_cidade_nascmto nm_distrt_nasc nr_serie nm_tipo_ensino birthdate
order cd_aluno year ano_nasc mes_nasc dia_nasc fem white bf cd_cor_raca cod_esc

local va fem white ano_nasc mes_nasc dia_nasc serie bf cod_esc cd_cor_raca
foreach x of varlist `va' {

rename `x' `x'_`i'

}

drop year 
tempfile CS`i'
save `CS`i''
restore 


merge 1:1 cd_aluno using `CS`i''
drop if _merge == 2
drop _merge 


}

*Já temos a base na versão wide!!



// (2) PAINEL LONG dos sibligs 
*ai eu preciso "estender" a informação para aqueles que nao tem 


local v ano_nasc mes_nasc dia_nasc fem white cd_cor_raca
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2019 if `x'_2019 !=. 

}

}


local v ano_nasc mes_nasc dia_nasc fem white cd_cor_raca
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2018 if `x'_2018 !=. 

}

}


local v ano_nasc mes_nasc dia_nasc fem white cd_cor_raca
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2017 if `x'_2017 !=. 

}

}


local v ano_nasc mes_nasc dia_nasc fem white cd_cor_raca
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2016 if `x'_2016 !=. 

}

}

local v ano_nasc mes_nasc dia_nasc fem white cd_cor_raca
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2015 if `x'_2015 !=. 

}

}

local v ano_nasc mes_nasc dia_nasc fem white cd_cor_raca
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2014 if `x'_2014 !=. 

}

}

local v ano_nasc mes_nasc dia_nasc fem white cd_cor_raca
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2013 if `x'_2013 !=. 

}

}

local v ano_nasc mes_nasc dia_nasc fem white cd_cor_raca
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2012 if `x'_2012 !=. 

}

}

local v ano_nasc mes_nasc dia_nasc fem white cd_cor_raca
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2011 if `x'_2011 !=. 

}

}

local v ano_nasc mes_nasc dia_nasc fem white cd_cor_raca
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2010 if `x'_2010 !=. 

}

}

save "$link\total limpo\panelsiblings1_wide.dta",replace 
label data "painel long irmaos apenas + info"




reshape long ano_nasc_ mes_nasc_ dia_nasc_ fem_ white_ bf_ cd_cor_raca_ cod_esc_ serie_, i(cd_aluno) 
rename _j year 

label data "painel long irmaos apenas + info"
save "$link\total limpo\panelsiblings2_long.dta",replace 





































































*************************
*    3. some check      *
*************************

// Ver se repete
sort CD_ALUNO


count if CD_ALUNO == CD_IRMAO 
*temos apenas 10 obs que repetem!! -> mas nao sei se ele ta olhando so para a mesma obs

gen teste = 1 if CD_ALUNO == CD_IRMAO
sort teste CD_ALUNO
order teste
*no caso sim!! temos 10 obs que o cara eh irmao dele mesmo kkkk (excluir esse povo depois)!!

*verificando pelo merge
preserve 

rename CD_ALUNO cd_aluno
rename CD_IRMAO CD_ALUNO
*m eh pq pode ter mais de um irmao 
merge m:1 CD_ALUNO using "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\baseirmaos_2020_copia.dta", force


restore 

*analisar resultado 
*se o match nao foi perfeito -> temos irmaos que nao estao mais matriculados!!
*_merge==3 os que repetem (=333,474), ou seja, ambos alunos estao matriculados em 2020
*_merge==2 not matched from using -> alunos matriculados em 2020 -> entender melhor
*_merge==1 not matched from master -> irmaos que nao estao mais em 2020



********** amostra potencial com essa base **********

//alunos entre nascidos 2004 a 2011
//meses
count if ano_nasc > 2003 & ano_nasc < 2011
count if ano_nasc > 2003 & ano_nasc < 2011 & mes_nasc > 4 & mes_nasc < 9 
//ta sunas










rename CD_ALUNO cd_aluno



merge 1:1 cd_aluno using "$user\SARESP\SARESP_2019.dta"

*SARESP 2019
*matched: 115,717 -> alunos com irmaos que estao na 3º,5º,7º ou 9º ano ou 3º EM
*not matched from master: alunos com irmaos que nao estao nessas series ou alunos que se matricularam em 2020
*from using: alunos sem irmãos ou que ja sairam 