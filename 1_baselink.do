********************************************************************************
*                  Siblings spillovers BR paper                                *
*                       DATA FROM SAO PAULO SECRETARIAT OF EDUCATION           *
********************************************************************************

//Isabela Innocente Gomes de Oliveira



clear all
//defining paths

global isabela 1

if $isabela	     {
	global 	user 	"C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\0. Replication"
	gl link "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\0. Replication\2_data\2.1_raw"
}
*
cd "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\0. Replication"


***************************************
*    1. cleaning the data by year     *
***************************************


forvalue i = 2010(1)2016 {

import delimited "$link\students_siblings_`i'.csv", encoding(UTF-8) 


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


*nao vou considerar EJA
gen serie = .
tostring serie, replace


*replace nr_serie="." if nr_serie=="NULL" & year >= 2017
*destring nr_serie, replace 

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


save "$link\\`i'complete_siblings.dta", replace 

tab serie

clear 

}


** 2017
forvalue i = 2017(1)2017 {

import delimited "$link\students_siblings_`i'.csv", encoding(UTF-8) 


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


*nao vou considerar EJA
gen serie = .
tostring serie, replace


replace nr_serie="." if nr_serie=="NULL" & year==2017
destring nr_serie, replace 

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


save "$link\\`i'complete_siblings.dta", replace 

tab serie

clear 

}

** 2018
forvalue i = 2018(1)2018 {

import delimited "$link\students_siblings_`i'.csv", encoding(UTF-8) 


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


save "$link\\`i'complete_siblings.dta", replace 

tab serie

clear 

}

** 2019
forvalue i = 2019(1)2019 {

import delimited "$link\students_siblings_`i'.csv", encoding(UTF-8) 


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
tostring tp_sexo, replace
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


save "$link\\`i'complete_siblings.dta", replace 

tab serie

clear 

}



*******************************************************
*    2. focal child data + all cohorts of siblings    *
*******************************************************

//only first year focal children

use "$link\2019complete_siblings.dta"

append using "$link\2018complete_siblings.dta" "$link\2017complete_siblings.dta" "$link\2016complete_siblings.dta" "$link\2015complete_siblings.dta" "$link\2014complete_siblings.dta" "$link\2013complete_siblings.dta" "$link\2012complete_siblings.dta" "$link\2011complete_siblings.dta" "$link\2010complete_siblings.dta"


keep if serie == "1-EF"

*this data has to be unique at cd_aluno cd_irmao level
sort cd_aluno cd_irmao year 
bysort cd_aluno cd_irmao: gen temp=_n
order cd_aluno cd_irmao temp

// we have 1691 obs that are repeated, which may indicate grade failure in first grade 

*lets identify who are these students 
*auxiliary data 
preserve
keep if temp > 1
drop if temp>2
keep cd_aluno cd_irmao 
gen repetiu_prim_ano=1
save "$link\duplicates.dta"
restore


drop if temp>1

merge 1:1 cd_aluno cd_irmao using "$link\duplicates.dta"

replace repetiu_prim_ano = 0 if _merge ==1
drop _merge 

erase "$link\duplicates.dta"

label data "Focal child + sibling cohorts"
save "$link\cohort_FC-S.dta", replace 



*******************************************************
*    3. GET SIBLINGS VARIABLES/INFORMATIONS           *
*******************************************************
drop cd_aluno 

rename cd_irmao cd_aluno 
label var cd_aluno "sibling id"

keep cd_aluno 
duplicates drop

*Lets create 2 datasets
// (1) keep just sibling id to be easier to merge with SARESP data
save "$link\baseirmaos.dta", replace 



// Now lets create a wide panel with siblings information by year 

//2019
preserve
clear 
use "$link\2019complete_siblings.dta"
duplicates drop cd_aluno, force
drop cd_irmao twin nm_bairro nr_cep nm_cidade sg_uf nm_zona cd_nacionalidade nm_cidade_nascmto nm_distrt_nasc nr_serie nm_tipo_ensino birthdate
order cd_aluno year ano_nasc mes_nasc dia_nasc fem white bf cd_cor_raca cod_esc

local va fem white ano_nasc mes_nasc dia_nasc serie bf cod_esc cd_cor_raca
foreach x of varlist `va' {

rename `x' `x'_2019

}

drop year 
tempfile CS2019
save `CS2019'
restore 


merge 1:1 cd_aluno using `CS2019'
drop if _merge == 2
drop _merge 



//2018 
preserve
clear 
use "$link\2018complete_siblings.dta"
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
use "$link\\`i'complete_siblings.dta"
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



// (2) LONG PANEL OF SIBLINGS
*we need to "extend" the information that is not time variable


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



save "$link\panelsiblings1_wide.dta",replace 
label data "wide panel of siblings with characteristics"


reshape long ano_nasc_ mes_nasc_ dia_nasc_ fem_ white_ bf_ cd_cor_raca_ cod_esc_ serie_, i(cd_aluno) 
rename _j year 

label data "long panel of siblings with characteristics"
save "$link\panelsiblings2_long.dta",replace 


forvalue i = 2010(1)2019 {
	
erase "$link\\`i'complete_siblings.dta"
	
}






