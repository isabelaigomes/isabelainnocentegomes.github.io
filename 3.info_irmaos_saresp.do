********************************************************************************

*             Juntando informações SARESP na base irmãos                       *

********************************************************************************

// aqui vamos obter as informações vindas do SARESP para os irmãos dos alunos matriculados em 2020, por enquanto

clear all

//defining paths

global isabela 1

if $isabela	     {
	gl  user 	"C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\saresp+irmaos"
	gl saresp "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\SARESP"
    gl geral "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP"
	gl link "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\dados link"

}
*




******************************************
* STEP 0: obter base com apenas id_irmao *
******************************************



********************************************************************************
//    ATENCAO: nos vamos ter 2 tipos de base com o SARESP: só as notas e a com 
//             todas as informações. Vamos começar com só pelas notas

********************************************************************************


*bora fazer um painel wide das notas 

//puxar csv, trocar nome variaveis, merge com a proxima base 


use "$link\baseirmaos.dta"
tempfile siblings
save `siblings'
clear 


				  
forvalue i = 2010(1)2019 {

import delimited "$saresp\notas apenas\MICRODADOS_SARESP_`i'.csv", encoding(UTF-8) clear 
keep cd_aluno codmun mun codesc serie turma classe tp_sexo dt_nascimento periodo particip* total_ponto* porc_acert* profic* nivel_profic* classific*


//                           ARRUMAR VARIAVEIS

//1. DATA NASC
split dt_nascimento, p("-")

destring dt_nascimento1, gen(ano_nasc) 
destring dt_nascimento2, gen(mes_nasc) 
drop dt_nascimento1 dt_nascimento2
order cd_aluno dt_nascimento ano_nasc mes_nasc


//2. GENERO
gen fem = 1 if tp_sexo == "2"
replace fem = 0 if tp_sexo == "1"
order  cd_aluno ano_nasc mes_nasc fem 
drop tp_sexo 


//3. MUNICIPIO
gen codigo_mun = codmun 
label var codigo_mun "codigo municipio"
rename mun nome_mun 

label var codesc "codigo escola"

//5. SERIE 
order cd_aluno ano_nasc mes_nasc serie 

replace serie = "3-EM" if serie == "EM-3ª série"
replace serie = "2-EF" if serie == "2º Ano EF"
replace serie = "3-EF" if serie == "3º Ano EF"
replace serie = "5-EF" if serie == "5º Ano EF"
replace serie = "7-EF" if serie == "7º Ano EF"
replace serie = "9-EF" if serie == "9º Ano EF"


// 6. NOTAS
destring porc_acert_lp, replace dpcomma
destring porc_acert_mat, replace dpcomma
replace profic_lp = "." if profic_lp == "NULL"
replace profic_mat = "." if profic_mat == "NULL"
destring profic_lp, replace dpcomma
destring profic_mat, replace dpcomma


local va codigo_mun nome_mun codesc serie turma classe fem ano_nasc mes_nasc periodo  porc_acert* profic* total_ponto* particip* nivel_profic* classific*
foreach x of varlist `va' {

rename `x' `x'_`i'

}





************************  restrição de sample **********************************
duplicates drop cd_aluno, force 

//R1 = mantendo so os irmaos que conseguimos achar em 201i (que estao no 2,3,5,7 e 9 do EF ou 3EM)
merge 1:1 cd_aluno using `siblings', gen(merge)
drop if merge==1




save "$saresp\notas apenas\notas_siblings_`i'.dta", replace 
clear 


}




*                    juntando todas as bases 

use "$saresp\notas apenas\notas_siblings_2019.dta"


forvalue i = 2010(1)2018 {

merge 1:1 cd_aluno using "$saresp\notas apenas\notas_siblings_`i'.dta", nogen 

}


*expandir valor de variaveis que nao alteram no tempo 
drop dt_nasc



local v ano_nasc mes_nasc fem 
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2019 if `x'_2019 !=. 

}

}

local v ano_nasc mes_nasc fem 
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2018 if `x'_2018 !=. 

}

}

local v ano_nasc mes_nasc fem 
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2017 if `x'_2017 !=. 

}

}

local v ano_nasc mes_nasc fem 
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2016 if `x'_2016 !=. 

}

}

local v ano_nasc mes_nasc fem 
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2015 if `x'_2015 !=. 

}

}

local v ano_nasc mes_nasc fem 
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2014 if `x'_2014 !=. 

}

}

local v ano_nasc mes_nasc fem
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2013 if `x'_2013 !=. 

}

}

local v ano_nasc mes_nasc fem 
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2012 if `x'_2012 !=. 

}

}

local v ano_nasc mes_nasc fem 
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2011 if `x'_2011 !=. 

}

}

local v ano_nasc mes_nasc fem 
foreach x of local v {

forvalue i = 2010(1)2019 {


replace `x'_`i' = `x'_2010 if `x'_2010 !=. 

}

}


*verificar se tem nome DIFERENTE para fazermos check de info 
drop merge 


local v2 ano_nasc mes_nasc fem serie codesc 
foreach x of local v2 {

forvalue i = 2010(1)2019 {
rename `x'_`i' `x'_`i'_S


}

}



*juntar todas as informações para produzir painel siblings wide 

merge 1:1 cd_aluno using "$link\total limpo\panelsiblings1_wide.dta", nogen 


*AJUSTES NAS VARIAVEIS 
forvalue i = 2010(1)2019 {

rename cod_esc_`i' codesc_`i'

}


local v3 ano_nasc mes_nasc fem codesc
foreach x of local v3 {

forvalue i = 2010(1)2019 {

replace `x'_`i' = `x'_`i'_S   if `x'_`i' != . 

}
}


forvalue i = 2010(1)2019 {

replace serie_`i' = serie_`i'_S   if serie_`i' != "." 

}


drop *_S

order cd_aluno ano_nasc* mes_nasc* dia_nasc* fem* white* bf* serie* codmun 

label data "painel wide sibling notas do saresp + info esic"

save "$geral\1.main data\painelsib_notas_wide.dta", replace 


//VERSAO LONG 
replace classe_2011 = "." if classe_2011 == "NULL"
destring classe_2011, replace 

reshape long ano_nasc_ mes_nasc_ dia_nasc_ fem_ white_ bf_ cd_cor_raca_ serie_ nome_mun_ turma_ classe_ periodo_ particip_lp_ particip_mat_ total_ponto_lp_ total_ponto_mat_ porc_acert_lp_ porc_acert_mat_  profic_lp_ profic_mat_ nivel_profic_lp_ nivel_profic_mat_ classific_lp_ classific_mat_ codigo_mun_ codesc_, i(cd_aluno) 
rename _j year 

save "$geral\1.main data\painelsib_notas_long.dta", replace 









********************************************************************************
********************************************************************************
********************************************************************************
*****************   VERSAO COM TODAS INFOS *************************************


use "$link\baseirmaos.dta"
tempfile siblings
rename cd_aluno CD_IRMAO 
save `siblings'
clear 



//STEP 1: OBTER base de informacao dos irmaos -> informacao deles no saresp 


//1.1 SARESP FULL -> os anos com quest de pais e alunos 

***************
*    2019     *
***************

use "$saresp\2019\SARESP_2019.dta"
rename cd_aluno CD_IRMAO

merge 1:1 CD_IRMAO using `siblings', gen(merge)
//vamos dropar o povo que não é irmao de ninguem 
drop if merge==1
//temos 580,308 obs, sendo que 88.536 delas estao na base de 2019 e 491,772 não 

save "$user\sibling_2019.dta", replace

clear 
***************
*    2018     *
***************

use "$saresp\2018\SARESP_2018.dta"
rename cd_aluno CD_IRMAO


merge 1:1 CD_IRMAO using `siblings', gen(merge)
//vamos dropar o povo que não é irmao de ninguem 
drop if merge==1
//temos 580,308 obs, sendo que 136.983 delas estao na base de 2019 e 443,325 não 

save "$user\sibling_2018.dta", replace


*********************
*    2009 - 2013    *
*********************

forvalue i = 2009(1)2013 {

use "$saresp\\`i'\SARESP_`i'.dta"
rename cd_aluno CD_IRMAO


merge 1:1 CD_IRMAO using `siblings', gen(merge)
//vamos dropar o povo que não é irmao de ninguem 
drop if merge==1

save "$user\sibling_`i'.dta", replace

}


use "$link\baseirmaos.dta"
tempfile siblings
rename cd_aluno CD_IRMAO 
save `siblings'
clear 



//1.2 bases que só tem a nota: 2014,2015,2016,2017


forvalue i = 2014(1)2017 {
clear 

import delimited "$saresp\notas apenas\MICRODADOS_SARESP_`i'.csv", encoding(UTF-8) 
duplicates drop cd_aluno, force 
rename cd_aluno CD_IRMAO

merge 1:1 CD_IRMAO using `siblings', gen(merge)

drop if merge==1

save "$user\sibling_`i'.dta", replace

}


clear 



***************************************************************
* STEP 2: limpar todas as bases SIBLINGS para pode dar append *
***************************************************************


                      //////////////
                     //   2019   //
                     /////////////

use "$user\sibling_2019.dta"


label var CD_IRMAO "codigo identific irmao"

*data nascimento 
tostring dt_nascimento, replace 
gen ano_nasc = substr(dt_nascimento,1,4)
gen teste = substr(dt_nascimento,5,6)
gen mes_nasc = substr(teste,1,2)
gen dia_nasc = substr(dt_nascimento,7,8)

drop teste dt_nascimento

destring ano_nasc, replace 
destring mes_nasc, replace 
destring dia_nasc, replace 

*sexo
gen fem = 1 if sexo == "F"
replace fem = 0 if sexo == "M"

order CD_IRMAO ano_nasc mes_nasc dia_nasc fem 

drop sexo

*deixando turma, periodo, rede 

*deficiencia 
label var tem_nec "Aluno tem algum tipo de necessidade especial"

*exluir essas por enquanto 
drop cd_dre nm_dre 

order CD_IRMAO ano_nasc mes_nasc dia_nasc fem turma periodo rede cd_mun nm_mun cd_ue cdrede de codmun mun codesc nomesc

gen codigo_mun = cd_mun 
replace codigo_mun = codmun if cd_mun == .
label var codigo_mun "codigo municipio"

gen nome_mun = mun
replace nome_mun = nm_mun if mun == "."

drop rede cd_mun de cd_ue nm_mun codmun mun 


label var cdrede "codigo rede ensino"
label var codesc "codigo escola"

replace serie = "3-EM" if serie == "EM-3ª série"
replace serie = "2-EF" if serie == "2º Ano EF"
replace serie = "3-EF" if serie == "3º Ano EF"
replace serie = "5-EF" if serie == "5º Ano EF"
replace serie = "7-EF" if serie == "7º Ano EF"
replace serie = "9-EF" if serie == "9º Ano EF"


drop nomedep nomedepbol tp_sexo tip_prova cad_prova* 

label var tipoclasse "Código do Tipo de Classe da Turma; Informações: 0 = Classe regular; 3= Classe de Aceleração; 5 = Recuperação de Ciclo e 10 = PIC "

label var nec_esp_1 ""
label var nec_esp_2 ""
label var nec_esp_3 ""
label var nec_esp_4 ""
label var nec_esp_5 ""

*notas 
destring porc_acert_lp, replace dpcomma
destring porc_acert_mat, replace dpcomma

replace profic_lp = "." if profic_lp == "NULL"
replace profic_mat = "." if profic_mat == "NULL"
destring profic_lp, replace dpcomma
destring profic_mat, replace dpcomma

label var validade "se a nota do aluno entra ou nao no calculo de estatisticas"


*********  questoes ALUNO ***********
drop q1_aluno q2_aluno q3_aluno q4_aluno q5_aluno q6_aluno q7_aluno q8_aluno q17_aluno q18_aluno q19_aluno q20_aluno q21_aluno q43_aluno q44_aluno q45_aluno q46_aluno q47_aluno q48_aluno q49_aluno
gen educ_infantil = 1 if q9_aluno == "A"
replace educ_infantil = 0 if q9_aluno == "B"
label var educ_infantil "aluno comecou na educ infantil vs direto EF1"

gen reprov = 1 if q10_aluno == "B" | q10_aluno == "C"
replace reprov = 0 if  q10_aluno == "A" 

drop q9_aluno q10_aluno
*q11-q16 particip pais -> deixar p depois 
*q22 e q24 de gostas das materias tbm

gen fazlicao_mat = 1 if q23_aluno == "A" | q23_aluno == "B"
replace fazlicao_mat = 0 if q23_aluno == "C"

gen fazlicao_port = 1 if q25_aluno == "A" | q25_aluno == "B"
replace fazlicao_port = 0 if q25_aluno == "C"

drop q23_aluno q25_aluno
*q26-q33 deixar p dps, perguntas sobre estudo  

gen discriminacao = 1 if q34_aluno == "A"
replace discriminacao = 0 if q34_aluno == "B"

drop q34_aluno 
*q35-42 tbm deixar p depois


**********  questoes PAIS **************
drop q1_pais q2_pais q3_pais q4_pais q5_pais q6_pais q7_pais q8_pais q9_pais q11_pais

*q10_pais pode ser usada para percepção pais se filho faz licao 
*q12_pais - q18 sao questoes se os pais participam da vida escolar do filho -> isso pode ser usado para ver canais depois 


rename q19_pais educpai
tab educpai, gen(educpai_)

rename q20_pais educmae
tab educmae, gen(educmae_)

rename q21_pais emprego_pai
rename q22_pais emprego_mae

rename q23_pais renda
tab renda, gen(faixarenda)


*q24_pais ate q50_pais sao os bens que vou excluir por enquanto 
drop q24_pais q25_pais q26_pais q27_pais q28_pais q29_pais q3*_pais q4*_pais q50_pais 



****************  restrição de sample ******************************


//R1 = mantendo so os irmaos que conseguimos achar em 2019 (que estao no 2,3,5,7 e 9 do EF ou 3EM)
drop if merge==2



save "$user\C_sibling_2019.dta", replace
clear 




                      //////////////
                     //   2018   //
                     /////////////


use "$user\sibling_2018.dta"

label var CD_IRMAO "codigo identific irmao"

//1. DATA NASC
*data nascimento => AQUI NAO TEMOS O DIA!!!!!!! VER SE CONSIGO ESSA OBS NA BASE NOVA

/*tostring dt_nascimento, replace 
gen ano_nasc = substr(dt_nascimento,1,4)
gen teste = substr(dt_nascimento,5,6)
gen mes_nasc = substr(teste,1,2)
gen dia_nasc = substr(dt_nascimento,7,8)
drop teste dt_nascimento */

split dt_nascimento, p("-")
order CD_IRMAO dt_nascimento dt_nascimento1 dt_nascimento2 

destring dt_nascimento1, gen(ano_nasc) 
destring dt_nascimento2, gen(mes_nasc) 
drop dt_nascimento1 dt_nascimento2
order CD_IRMAO dt_nascimento ano_nasc mes_nasc
*destring dia_nasc, replace 


//2. GENERO
gen fem = 1 if sexo == "F" | tp_sexo == "2"
replace fem = 0 if sexo == "M" | tp_sexo == "1"

order CD_IRMAO ano_nasc mes_nasc fem 
drop sexo tp_sexo 


//3. VARIAS
*deixando turma, periodo, rede 

*deficiencia 
label var tem_nec "Aluno tem algum tipo de necessidade especial"

*exluir essas por enquanto 
drop cd_dre nm_dre 

order CD_IRMAO ano_nasc mes_nasc fem turma periodo rede cd_mun nm_mun cd_ue cdrede de codmun mun codesc nomesc

//4. MUNICIPIO
gen codigo_mun = cd_mun 
replace codigo_mun = codmun if cd_mun == .
label var codigo_mun "codigo municipio"

gen nome_mun = mun
replace nome_mun = nm_mun if mun == "."

drop rede cd_mun de cd_ue nm_mun codmun mun 

label var cdrede "codigo rede ensino"
label var codesc "codigo escola"

//5. SERIE
order CD_IRMAO ano_nasc mes_nasc serie etapa_ensino

gen serie_ = "."
replace serie_ = "3-EM" if serie == 3 & etapa_ensino == "ENSINO MÉDIO"
replace serie_ = "2-EM" if serie == 2 & etapa_ensino == "ENSINO MÉDIO"
replace serie_ = "1-EM" if (serie == 1 & etapa_ensino == "ENSINO MÉDIO") | (serie == 1 & etapa_ensino == " ")

replace serie_ = "1-EF" if serie == 1 & etapa_ensino == "ENSINO FUNDAMENTAL CICLO I"
replace serie_ = "2-EF" if serie == 2 & etapa_ensino == "ENSINO FUNDAMENTAL CICLO I"
replace serie_ = "3-EF" if serie == 3 & etapa_ensino == "ENSINO FUNDAMENTAL CICLO I"
replace serie_ = "4-EF" if serie == 4 & etapa_ensino == "ENSINO FUNDAMENTAL CICLO I"
replace serie_ = "5-EF" if serie == 5 & etapa_ensino == "ENSINO FUNDAMENTAL CICLO I"
replace serie_ = "6-EF" if serie == 6 & etapa_ensino == "ENSINO FUNDAMENTAL CICLO II"
replace serie_ = "7-EF" if serie == 7 & etapa_ensino == "ENSINO FUNDAMENTAL CICLO II"
replace serie_ = "8-EF" if serie == 8 & etapa_ensino == "ENSINO FUNDAMENTAL CICLO II"
replace serie_ = "9-EF" if serie == 9 & etapa_ensino == "ENSINO FUNDAMENTAL CICLO II"

drop serie
rename serie_ serie 
*obs: esse povo q ta na base mais nao tem nota é o povo dos anos 2,4,6 etc!!!

drop nomedep nomedepbol tip_prova cad_prova* 

label var tipoclasse "Código do Tipo de Classe da Turma; Informações: 0 = Classe regular; 3= Classe de Aceleração; 5 = Recuperação de Ciclo e 10 = PIC "



//6. NECESSIDADES ESPECIAIS
label var nec_esp_1 ""
label var nec_esp_2 ""
label var nec_esp_3 ""
label var nec_esp_4 ""
label var nec_esp_5 ""

// 7. NOTAS
destring porc_acert_lp, replace dpcomma
destring porc_acert_mat, replace dpcomma

replace profic_lp = "." if profic_lp == "NULL"
replace profic_mat = "." if profic_mat == "NULL"
destring profic_lp, replace dpcomma
destring profic_mat, replace dpcomma

label var validade "se a nota do aluno entra ou nao no calculo de estatisticas"


//8. QUESTIONARIOS IDESP 

//8.1
*********  questoes ALUNO ***********
drop q1_aluno q2_aluno q3_aluno q4_aluno q5_aluno q6_aluno q7_aluno q8_aluno q17_aluno q18_aluno q19_aluno q20_aluno q21_aluno q43_aluno q44_aluno q45_aluno q46_aluno q47_aluno q48_aluno q49_aluno

gen educ_infantil = 1 if q9_aluno == "A"
replace educ_infantil = 0 if q9_aluno == "B"
label var educ_infantil "aluno comecou na educ infantil vs direto EF1"

gen reprov = 1 if q10_aluno == "B" | q10_aluno == "C"
replace reprov = 0 if  q10_aluno == "A" 

drop q9_aluno q10_aluno
*q11-q16 particip pais -> deixar p depois 
*q22 e q24 de gostas das materias tbm

gen fazlicao_mat = 1 if q23_aluno == "A" | q23_aluno == "B"
replace fazlicao_mat = 0 if q23_aluno == "C"

gen fazlicao_port = 1 if q25_aluno == "A" | q25_aluno == "B"
replace fazlicao_port = 0 if q25_aluno == "C"

drop q23_aluno q25_aluno
*q26-q33 deixar p dps, perguntas sobre estudo  

gen discriminacao = 1 if q34_aluno == "A"
replace discriminacao = 0 if q34_aluno == "B"

drop q34_aluno 
*q35-42 tbm deixar p depois


//8.2
**********  questoes PAIS **************
drop q1_pais q2_pais q3_pais q4_pais q5_pais q6_pais q7_pais q8_pais q9_pais q11_pais

*q10_pais pode ser usada para percepção pais se filho faz licao 
*q12_pais - q18 sao questoes se os pais participam da vida escolar do filho -> isso pode ser usado para ver canais depois 


rename q19_pais educpai
tab educpai, gen(educpai_)

rename q20_pais educmae
tab educmae, gen(educmae_)

rename q21_pais emprego_pai
rename q22_pais emprego_mae

rename q23_pais renda
tab renda, gen(faixarenda)


*q24_pais ate q50_pais sao os bens que vou excluir por enquanto 
drop q24_pais q25_pais q26_pais q27_pais q28_pais q29_pais q3*_pais q4*_pais 



************************  restrição de sample **********************************


//R1 = mantendo so os irmaos que conseguimos achar em 2019 (que estao no 2,3,5,7 e 9 do EF ou 3EM)
drop if merge==2



save "$user\C_sibling_2018.dta", replace
clear 



                    ///////////////////
                   //   2014-2017   //
                  ///////////////////

				  
forvalue i = 2014(1)2017 {

				  
use "$user\sibling_`i'.dta"

label var CD_IRMAO "codigo identific irmao"

//1. DATA NASC
*data nascimento => AQUI NAO TEMOS O DIA!!!!!!! VER SE CONSIGO ESSA OBS NA BASE NOVA

/*tostring dt_nascimento, replace 
gen ano_nasc = substr(dt_nascimento,1,4)
gen teste = substr(dt_nascimento,5,6)
gen mes_nasc = substr(teste,1,2)
gen dia_nasc = substr(dt_nascimento,7,8)
drop teste dt_nascimento */

split dt_nascimento, p("-")
order CD_IRMAO dt_nascimento dt_nascimento1 dt_nascimento2 

destring dt_nascimento1, gen(ano_nasc) 
destring dt_nascimento2, gen(mes_nasc) 
drop dt_nascimento1 dt_nascimento2
order CD_IRMAO dt_nascimento ano_nasc mes_nasc
*destring dia_nasc, replace 


//2. GENERO
gen fem = 1 if tp_sexo == "2"
replace fem = 0 if tp_sexo == "1"

order CD_IRMAO ano_nasc mes_nasc fem 
drop tp_sexo 


//3. VARIAS
*deixando turma, periodo, rede 

*deficiencia 
label var tem_nec "Aluno tem algum tipo de necessidade especial"


order CD_IRMAO ano_nasc mes_nasc fem turma periodo cdrede de codmun mun codesc

//4. MUNICIPIO
gen codigo_mun = codmun 
*replace codigo_mun = codmun if cd_mun == .
label var codigo_mun "codigo municipio"

rename mun nome_mun 

/*gen nome_mun = mun
replace nome_mun = nm_mun if mun == "."
drop rede cd_mun de cd_ue nm_mun codmun mun*/
drop de codmun 

label var cdrede "codigo rede ensino"
label var codesc "codigo escola"

//5. SERIE => aqui ta igual 2019
order CD_IRMAO ano_nasc mes_nasc serie 

replace serie = "3-EM" if serie == "EM-3ª série"
replace serie = "2-EF" if serie == "2º Ano EF"
replace serie = "3-EF" if serie == "3º Ano EF"
replace serie = "5-EF" if serie == "5º Ano EF"
replace serie = "7-EF" if serie == "7º Ano EF"
replace serie = "9-EF" if serie == "9º Ano EF"


drop nomedep nomedepbol tip_prova cad_prova* 

label var tipoclasse "Código do Tipo de Classe da Turma; Informações: 0 = Classe regular; 3= Classe de Aceleração; 5 = Recuperação de Ciclo e 10 = PIC "



//6. NECESSIDADES ESPECIAIS
label var nec_esp_1 ""
label var nec_esp_2 ""
label var nec_esp_3 ""
label var nec_esp_4 ""
label var nec_esp_5 ""

// 7. NOTAS
destring porc_acert_lp, replace dpcomma
destring porc_acert_mat, replace dpcomma

replace profic_lp = "." if profic_lp == "NULL"
replace profic_mat = "." if profic_mat == "NULL"
destring profic_lp, replace dpcomma
destring profic_mat, replace dpcomma

label var validade "se a nota do aluno entra ou nao no calculo de estatisticas"


************************  restrição de sample **********************************


//R1 = mantendo so os irmaos que conseguimos achar em 201i (que estao no 2,3,5,7 e 9 do EF ou 3EM)
drop if merge==2

gen year = `i'

save "$user\C_sibling_`i'.dta", replace
clear 


}




                    ///////////////////
                   //     2013      //
                  ///////////////////
				  

use "$user\sibling_2013.dta"

label var CD_IRMAO "codigo identific irmao"

//1. DATA NASC
*data nascimento => AQUI NAO TEMOS O DIA!!!!!!! VER SE CONSIGO ESSA OBS NA BASE NOVA

/*tostring dt_nascimento, replace 
gen ano_nasc = substr(dt_nascimento,1,4)
gen teste = substr(dt_nascimento,5,6)
gen mes_nasc = substr(teste,1,2)
gen dia_nasc = substr(dt_nascimento,7,8)
drop teste dt_nascimento */

replace dt_nascimento = "." if dt_nascimento == "NULL"
split dt_nascimento, p("-")
order CD_IRMAO dt_nascimento dt_nascimento1 dt_nascimento2 

destring dt_nascimento1, gen(ano_nasc) 
destring dt_nascimento2, gen(mes_nasc) 
drop dt_nascimento1 dt_nascimento2
order CD_IRMAO dt_nascimento ano_nasc mes_nasc
*destring dia_nasc, replace 


//2. GENERO
gen fem = 1 if sexo == "F" | tp_sexo == "2"
replace fem = 0 if sexo == "M" | tp_sexo == "1"

order CD_IRMAO ano_nasc mes_nasc fem 
drop sexo tp_sexo 


//3. VARIAS
*deixando turma, periodo, rede 

*deficiencia 
label var tem_nec "Aluno tem algum tipo de necessidade especial"

*exluir essas por enquanto 
*drop cd_dre nm_dre 

order CD_IRMAO ano_nasc mes_nasc fem turma periodo cdrede de codmun mun codesc nomesc

//4. MUNICIPIO
gen codigo_mun = codmun
label var codigo_mun "codigo municipio"

rename mun nome_mun
drop de codmun

label var cdrede "codigo rede ensino"
label var codesc "codigo escola"

//5. SERIE
order CD_IRMAO ano_nasc mes_nasc serie 

*aqui nao tempo a variavel etapa de ensino -> o terceiro colegial deve ser 11, mas seria bom olhar se o povo nao ta colocando 3
tab ano_nasc if serie == 3

gen serie_ = "."
replace serie_ = "3-EM" if serie == 11

replace serie_ = "2-EF" if serie == 2 
replace serie_ = "3-EF" if serie == 3 
replace serie_ = "5-EF" if serie == 5 
replace serie_ = "7-EF" if serie == 7 
replace serie_ = "9-EF" if serie == 9 

drop serie
rename serie_ serie 
*obs: esse povo q ta na base mais nao tem nota é o povo dos anos 2,4,6 etc!!!

drop nomedep nomedepbol tip_prova cad_prova* 

label var tipoclasse "Código do Tipo de Classe da Turma; Informações: 0 = Classe regular; 3= Classe de Aceleração; 5 = Recuperação de Ciclo e 10 = PIC "



//6. NECESSIDADES ESPECIAIS
label var nec_esp_1 ""
label var nec_esp_2 ""
label var nec_esp_3 ""
label var nec_esp_4 ""
label var nec_esp_5 ""

// 7. NOTAS
destring porc_acert_lp, replace dpcomma
destring porc_acert_mat, replace dpcomma

replace profic_lp = "." if profic_lp == "NULL"
replace profic_mat = "." if profic_mat == "NULL"
destring profic_lp, replace dpcomma
destring profic_mat, replace dpcomma

label var validade "se a nota do aluno entra ou nao no calculo de estatisticas"


//8. QUESTIONARIOS IDESP 

//8.1
*********  questoes ALUNO ***********
gen educ_infantil = 1 if q32_aluno == "A"
replace educ_infantil = 0 if q32_aluno == "B" | q32_aluno == "C"
label var educ_infantil "aluno comecou na educ infantil vs direto EF1"

gen reprov = .
replace reprov = 1 if q33_aluno == "C" | q33_aluno == "D" | q33_aluno == "E" | q33_aluno == "F" | q34_aluno == "C" | q34_aluno == "D" | q34_aluno == "E" | q34_aluno == "F"
replace reprov = 0 if  q33_aluno == "A"  | q33_aluno == "B" | q34_aluno == "A"  | q34_aluno == "B" 
*obs: alunos do EM tem que considerar tbm q34 


*faz licao e discriminacao eu não gerei aqui 


*RACA
gen branco =.
//EF1
replace branco=1 if q41_aluno == "A"
replace branco=0 if q41_aluno == "B" | q41_aluno == "C" | q41_aluno == "D" | q41_aluno == "E"
//EF2
replace branco=1 if q59 == "A" & (serie == "7-EF" | serie == "9-EF")
replace branco=0 if (q59 == "B"| q59 == "C" | q59 == "D" | q59 == "E") & (serie == "7-EF" | serie == "9-EF")
//EM3 
replace branco=1 if q56 == "A" & (serie == "3-EM")
replace branco=0 if (q56 == "B"| q56 == "C" | q56 == "D" | q56 == "E") & (serie == "3-EM")

*vamos dropar todas as q_aluno que nao estamos usando agora e ai depois eu recupero eventualmente se necessario 
drop q*_aluno


//8.2
**********  questoes PAIS **************

rename q18_pais_pais educpai
tab educpai, gen(educpai_)

rename q21_pais_pais educmae
tab educmae, gen(educmae_)

rename q16_pais_pais emprego_pai
rename q19_pais_pais emprego_mae

rename q24_pais_pais renda
tab renda, gen(faixarenda)

*vamos dropar todas as q_aluno que nao estamos usando agora e ai depois eu recupero eventualmente se necessario 
drop q*_pais 
drop q54 q55 q56 q57 q58 q59 q60 q61


************************  restrição de sample **********************************


//R1 = mantendo so os irmaos que conseguimos achar em 2019 (que estao no 2,3,5,7 e 9 do EF ou 3EM)
drop if merge==2



save "$user\C_sibling_2013.dta", replace
clear 






                    ///////////////////
                   //     2012     //
                  ///////////////////
				  

use "$user\sibling_2012.dta"

label var CD_IRMAO "codigo identific irmao"

//1. DATA NASC
*data nascimento => AQUI NAO TEMOS O DIA!!!!!!! VER SE CONSIGO ESSA OBS NA BASE NOVA

/*tostring dt_nascimento, replace 
gen ano_nasc = substr(dt_nascimento,1,4)
gen teste = substr(dt_nascimento,5,6)
gen mes_nasc = substr(teste,1,2)
gen dia_nasc = substr(dt_nascimento,7,8)
drop teste dt_nascimento */

replace dt_nascimento = "." if dt_nascimento == "NULL"
split dt_nascimento, p("-")
order CD_IRMAO dt_nascimento dt_nascimento1 dt_nascimento2 

destring dt_nascimento1, gen(ano_nasc) 
destring dt_nascimento2, gen(mes_nasc) 
drop dt_nascimento1 dt_nascimento2
order CD_IRMAO dt_nascimento ano_nasc mes_nasc
*destring dia_nasc, replace 


//2. GENERO
gen fem = 1 if sexo == "F" | tp_sexo == "2"
replace fem = 0 if sexo == "M" | tp_sexo == "1"

order CD_IRMAO ano_nasc mes_nasc fem 
drop sexo tp_sexo 


//3. VARIAS
*deixando turma, periodo, rede 

*deficiencia 
label var tem_nec "Aluno tem algum tipo de necessidade especial"

*exluir essas por enquanto 
*drop cd_dre nm_dre 

order CD_IRMAO ano_nasc mes_nasc fem turma periodo cdrede de codmun mun codesc nomesc

//4. MUNICIPIO
gen codigo_mun = codmun
label var codigo_mun "codigo municipio"

rename mun nome_mun
drop de codmun

label var cdrede "codigo rede ensino"
label var codesc "codigo escola"

//5. SERIE
order CD_IRMAO ano_nasc mes_nasc serie 

*aqui nao tempo a variavel etapa de ensino -> o terceiro colegial deve ser 11, mas seria bom olhar se o povo nao ta colocando 3
tab ano_nasc if serie == 3

gen serie_ = "."
replace serie_ = "3-EM" if serie == 11

*replace serie_ = "2-EF" if serie == 2 
replace serie_ = "3-EF" if serie == 3 
replace serie_ = "5-EF" if serie == 5 
replace serie_ = "7-EF" if serie == 7 
replace serie_ = "9-EF" if serie == 9 

drop serie
rename serie_ serie 
*obs: esse povo q ta na base mais nao tem nota é o povo dos anos 2,4,6 etc!!!

drop nomedep nomedepbol tip_prova cad_prova* 

label var tipoclasse "Código do Tipo de Classe da Turma; Informações: 0 = Classe regular; 3= Classe de Aceleração; 5 = Recuperação de Ciclo e 10 = PIC "



//6. NECESSIDADES ESPECIAIS
label var nec_esp_1 ""
label var nec_esp_2 ""
label var nec_esp_3 ""
label var nec_esp_4 ""
label var nec_esp_5 ""

// 7. NOTAS
destring porc_acert_lp, replace dpcomma
destring porc_acert_mat, replace dpcomma

replace profic_lp = "." if profic_lp == "NULL"
replace profic_mat = "." if profic_mat == "NULL"
destring profic_lp, replace dpcomma
destring profic_mat, replace dpcomma

label var validade "se a nota do aluno entra ou nao no calculo de estatisticas"


//8. QUESTIONARIOS IDESP 

//8.1
*********  questoes ALUNO ***********
gen educ_infantil = 1 if q32_aluno == "A"
replace educ_infantil = 0 if q32_aluno == "B" | q32_aluno == "C"
label var educ_infantil "aluno comecou na educ infantil vs direto EF1"

gen reprov = .
replace reprov = 1 if q33_aluno == "C" | q33_aluno == "D" | q33_aluno == "E" | q33_aluno == "F" | q34_aluno == "C" | q34_aluno == "D" | q34_aluno == "E" | q34_aluno == "F"
replace reprov = 0 if  q33_aluno == "A"  | q33_aluno == "B" | q34_aluno == "A"  | q34_aluno == "B" 
*obs: alunos do EM tem que considerar tbm q34 


*faz licao e discriminacao eu não gerei aqui 


*RACA
gen branco =.
//EF1
replace branco=1 if q41_aluno == "A"
replace branco=0 if q41_aluno == "B" | q41_aluno == "C" | q41_aluno == "D" | q41_aluno == "E"
//EF2
replace branco=1 if q58 == "A" & (serie == "7-EF" | serie == "9-EF")
replace branco=0 if (q58== "B"| q58 == "C" | q58 == "D" | q58 == "E") & (serie == "7-EF" | serie == "9-EF")
//EM3 
replace branco=1 if q57 == "A" & (serie == "3-EM")
replace branco=0 if (q57 == "B"| q57 == "C" | q57 == "D" | q57 == "E") & (serie == "3-EM")

*vamos dropar todas as q_aluno que nao estamos usando agora e ai depois eu recupero eventualmente se necessario 
drop q*_aluno


//8.2
**********  questoes PAIS **************

rename q18_pais_pais educpai
tab educpai, gen(educpai_)

rename q21_pais_pais educmae
tab educmae, gen(educmae_)

rename q16_pais_pais emprego_pai
rename q19_pais_pais emprego_mae

rename q24_pais_pais renda
tab renda, gen(faixarenda)

*vamos dropar todas as q_aluno que nao estamos usando agora e ai depois eu recupero eventualmente se necessario 
drop q*_pais 


************************  restrição de sample **********************************


//R1 = mantendo so os irmaos que conseguimos achar em 2019 (que estao no 2,3,5,7 e 9 do EF ou 3EM)
drop if merge==2



save "$user\C_sibling_2012.dta", replace
clear 






                    ///////////////////
                   //     2011     //
                  ///////////////////
				  

use "$user\sibling_2011.dta"

label var CD_IRMAO "codigo identific irmao"

//1. DATA NASC
*data nascimento => AQUI NAO TEMOS O DIA!!!!!!! VER SE CONSIGO ESSA OBS NA BASE NOVA

/*tostring dt_nascimento, replace 
gen ano_nasc = substr(dt_nascimento,1,4)
gen teste = substr(dt_nascimento,5,6)
gen mes_nasc = substr(teste,1,2)
gen dia_nasc = substr(dt_nascimento,7,8)
drop teste dt_nascimento */

replace dt_nascimento = "." if dt_nascimento == "NULL"
split dt_nascimento, p("-")
order CD_IRMAO dt_nascimento dt_nascimento1 dt_nascimento2 

destring dt_nascimento1, gen(ano_nasc) 
destring dt_nascimento2, gen(mes_nasc) 
drop dt_nascimento1 dt_nascimento2
order CD_IRMAO dt_nascimento ano_nasc mes_nasc
*destring dia_nasc, replace 


//2. GENERO
gen fem = 1 if sexo == "F" | tp_sexo == "2"
replace fem = 0 if sexo == "M" | tp_sexo == "1"

order CD_IRMAO ano_nasc mes_nasc fem 
drop sexo tp_sexo 


//3. VARIAS
*deixando turma, periodo, rede 

*deficiencia 
label var tem_nec "Aluno tem algum tipo de necessidade especial"

*exluir essas por enquanto 
*drop cd_dre nm_dre 

order CD_IRMAO ano_nasc mes_nasc fem turma periodo cdrede de codmun mun codesc 

//4. MUNICIPIO
gen codigo_mun = codmun
label var codigo_mun "codigo municipio"

rename mun nome_mun
drop de codmun

label var cdrede "codigo rede ensino"
label var codesc "codigo escola"

//5. SERIE -> TALVEZ DE PARA GERAR ANTES DE AGREGAR COM BASE NA DATA DE NASC
order CD_IRMAO ano_nasc mes_nasc serie 

*aqui nao tempo a variavel etapa de ensino -> o terceiro colegial deve ser 11, mas seria bom olhar se o povo nao ta colocando 3
*AQUI A VARIAVEL SERIE NAO TEM VALORES!!!!

/*
gen serie_ = "."
replace serie_ = "3-EM" if serie == 11

*replace serie_ = "2-EF" if serie == 2 
replace serie_ = "3-EF" if serie == 3 
replace serie_ = "5-EF" if serie == 5 
replace serie_ = "7-EF" if serie == 7 
replace serie_ = "9-EF" if serie == 9 

drop serie
rename serie_ serie  */
*obs: esse povo q ta na base mais nao tem nota é o povo dos anos 2,4,6 etc!!!

drop nomedep nomedepbol tip_prova cad_prova* 

label var tipoclasse "Código do Tipo de Classe da Turma; Informações: 0 = Classe regular; 3= Classe de Aceleração; 5 = Recuperação de Ciclo e 10 = PIC "



//6. NECESSIDADES ESPECIAIS
label var nec_esp_1 ""
label var nec_esp_2 ""
label var nec_esp_3 ""
label var nec_esp_4 ""
label var nec_esp_5 ""

// 7. NOTAS
destring porc_acert_lp, replace dpcomma
destring porc_acert_mat, replace dpcomma

replace profic_lp = "." if profic_lp == "NULL"
replace profic_mat = "." if profic_mat == "NULL"
destring profic_lp, replace dpcomma
destring profic_mat, replace dpcomma

label var validade "se a nota do aluno entra ou nao no calculo de estatisticas"


//8. QUESTIONARIOS IDESP 

//8.1
*********  questoes ALUNO ***********
gen educ_infantil = 1 if q32_aluno == "A"
replace educ_infantil = 0 if q32_aluno == "B" | q32_aluno == "C"
label var educ_infantil "aluno comecou na educ infantil vs direto EF1"

gen reprov = .
replace reprov = 1 if q33_aluno == "C" | q33_aluno == "D" | q33_aluno == "E" | q33_aluno == "F" | q34_aluno == "C" | q34_aluno == "D" | q34_aluno == "E" | q34_aluno == "F"
replace reprov = 0 if  q33_aluno == "A"  | q33_aluno == "B" | q34_aluno == "A"  | q34_aluno == "B" 
*obs: alunos do EM tem que considerar tbm q34 


*faz licao e discriminacao eu não gerei aqui 

*RACA vai ter que gerar antes de agregar!!!! pq cada etapa de ensino a pergunta de raca é um numero diferente
/*
*RACA
gen branco =.
//EF1
replace branco=1 if q41_aluno == "A"
replace branco=0 if q41_aluno == "B" | q41_aluno == "C" | q41_aluno == "D" | q41_aluno == "E"
//EF2
replace branco=1 if q59 == "A" & (serie == "7-EF" | serie == "9-EF")
replace branco=0 if (q59== "B"| q58 == "C" | q58 == "D" | q58 == "E") & (serie == "7-EF" | serie == "9-EF")
//EM3 
replace branco=1 if q57 == "A" & (serie == "3-EM")
replace branco=0 if (q57 == "B"| q57 == "C" | q57 == "D" | q57 == "E") & (serie == "3-EM")
*/
*vamos dropar todas as q_aluno que nao estamos usando agora e ai depois eu recupero eventualmente se necessario 
drop q*_aluno


//8.2
**********  questoes PAIS **************

rename q18_pais_pais educpai
tab educpai, gen(educpai_)

rename q21_pais_pais educmae
tab educmae, gen(educmae_)

rename q16_pais_pais emprego_pai
rename q19_pais_pais emprego_mae

rename q24_pais_pais renda
tab renda, gen(faixarenda)

*vamos dropar todas as q_aluno que nao estamos usando agora e ai depois eu recupero eventualmente se necessario 
drop q*_pais 
drop q54 q55 q56 q57 q58 q59 q60 q61


************************  restrição de sample **********************************


//R1 = mantendo so os irmaos que conseguimos achar em 2019 (que estao no 2,3,5,7 e 9 do EF ou 3EM)
drop if merge==2



save "$user\C_sibling_2011.dta", replace
clear 




                    ///////////////////
                   //     2010     //
                  ///////////////////
				  

use "$user\sibling_2010.dta"

label var CD_IRMAO "codigo identific irmao"

//1. DATA NASC
*data nascimento => AQUI NAO TEMOS O DIA!!!!!!! VER SE CONSIGO ESSA OBS NA BASE NOVA

/*tostring dt_nascimento, replace 
gen ano_nasc = substr(dt_nascimento,1,4)
gen teste = substr(dt_nascimento,5,6)
gen mes_nasc = substr(teste,1,2)
gen dia_nasc = substr(dt_nascimento,7,8)
drop teste dt_nascimento */

replace dt_nascimento = "." if dt_nascimento == "NULL"
split dt_nascimento, p("-")
order CD_IRMAO dt_nascimento dt_nascimento1 dt_nascimento2 

destring dt_nascimento1, gen(ano_nasc) 
destring dt_nascimento2, gen(mes_nasc) 
drop dt_nascimento1 dt_nascimento2
order CD_IRMAO dt_nascimento ano_nasc mes_nasc
*destring dia_nasc, replace 


//2. GENERO
gen fem = 1 if sexo == "F" | tp_sexo == "2"
replace fem = 0 if sexo == "M" | tp_sexo == "1"

order CD_IRMAO ano_nasc mes_nasc fem 
drop sexo tp_sexo 


//3. VARIAS
*deixando turma, periodo, rede 

*deficiencia 
label var tem_nec "Aluno tem algum tipo de necessidade especial"

*exluir essas por enquanto 
*drop cd_dre nm_dre 

order CD_IRMAO ano_nasc mes_nasc fem turma periodo cdrede de codmun mun codesc 

//4. MUNICIPIO
gen codigo_mun = codmun
label var codigo_mun "codigo municipio"

rename mun nome_mun
drop de codmun

label var cdrede "codigo rede ensino"
label var codesc "codigo escola"

//5. SERIE -> TALVEZ DE PARA GERAR ANTES DE AGREGAR COM BASE NA DATA DE NASC
order CD_IRMAO ano_nasc mes_nasc serie 

*aqui nao tempo a variavel etapa de ensino -> o terceiro colegial deve ser 11, mas seria bom olhar se o povo nao ta colocando 3

gen serie_ = "."
replace serie_ = "3-EM" if serie_ano == "EM - 3ª Serie"

replace serie_ = "3-EF" if serie_ano == "3º Ano"
replace serie_ = "5-EF" if serie_ano == "5º Ano"
replace serie_ = "7-EF" if serie_ano == "7Âº Ano"
replace serie_ = "9-EF" if serie_ano == "9Âº Ano"

drop serie
rename serie_ serie 
*obs: esse povo q ta na base mais nao tem nota é o povo dos anos 2,4,6 etc!!!

drop nomedep nomedepbol tip_prova cad_prova* 

label var tipoclasse "Código do Tipo de Classe da Turma; Informações: 0 = Classe regular; 3= Classe de Aceleração; 5 = Recuperação de Ciclo e 10 = PIC "



//6. NECESSIDADES ESPECIAIS
label var nec_esp_1 ""
label var nec_esp_2 ""
label var nec_esp_3 ""
label var nec_esp_4 ""
label var nec_esp_5 ""

// 7. NOTAS
destring porc_acert_lp, replace dpcomma
destring porc_acert_mat, replace dpcomma

replace profic_lp = "." if profic_lp == "NULL"
replace profic_mat = "." if profic_mat == "NULL"
destring profic_lp, replace dpcomma
destring profic_mat, replace dpcomma

label var validade "se a nota do aluno entra ou nao no calculo de estatisticas"


//8. QUESTIONARIOS IDESP 

//8.1
*********  questoes ALUNO ***********
gen educ_infantil = 1 if q32__aluno == "A"
replace educ_infantil = 0 if q32__aluno == "B" | q32__aluno == "C"
label var educ_infantil "aluno comecou na educ infantil vs direto EF1"

gen reprov = .
replace reprov = 1 if q33__aluno == "C" | q33__aluno == "D" | q33__aluno == "E" | q33__aluno == "F" | q34__aluno == "C" | q34__aluno == "D" | q34__aluno == "E" | q34__aluno == "F"
replace reprov = 0 if  q33__aluno == "A"  | q33__aluno == "B" | q34__aluno == "A"  | q34__aluno == "B" 
*obs: alunos do EM tem que considerar tbm q34 


*faz licao e discriminacao eu não gerei aqui 

*RACA vai ter que gerar antes de agregar!!!! pq cada etapa de ensino a pergunta de raca é um numero diferente
/*
*RACA
gen branco =.
//EF1
replace branco=1 if q41_aluno == "A"
replace branco=0 if q41_aluno == "B" | q41_aluno == "C" | q41_aluno == "D" | q41_aluno == "E"
//EF2
replace branco=1 if q59 == "A" & (serie == "7-EF" | serie == "9-EF")
replace branco=0 if (q59== "B"| q58 == "C" | q58 == "D" | q58 == "E") & (serie == "7-EF" | serie == "9-EF")
//EM3 
replace branco=1 if q57 == "A" & (serie == "3-EM")
replace branco=0 if (q57 == "B"| q57 == "C" | q57 == "D" | q57 == "E") & (serie == "3-EM")
*/
*vamos dropar todas as q_aluno que nao estamos usando agora e ai depois eu recupero eventualmente se necessario 



//8.2
**********  questoes PAIS **************

rename q18 educpai
tab educpai, gen(educpai_)

rename q21 educmae
tab educmae, gen(educmae_)

rename q16 emprego_pai
rename q19 emprego_mae

rename q24 renda
tab renda, gen(faixarenda)

*vamos dropar todas as q_aluno que nao estamos usando agora e ai depois eu recupero eventualmente se necessario 
drop q_*
drop q*


************************  restrição de sample **********************************


//R1 = mantendo so os irmaos que conseguimos achar em 2010 (que estao no 2,3,5,7 e 9 do EF ou 3EM)
drop if merge==2



save "$user\C_sibling_2010.dta", replace
clear 








********************************************************************************

*                       STEP 3: APPEND                                         *

********************************************************************************

use "$user\C_sibling_2019.dta"
 
forvalue i = 2010(1)2018 {

append using "$user\C_sibling_`i'.dta", force 

}

unique CD_IRMAO
sort CD_IRMAO year
order CD_IRMAO year
*temos 346.022 irmaos na amostra 
*842.127 obs 


*indicador = me diz quantas vezes o irmão aparece na base 
bysort CD_IRMAO: gen indicador = _n

label data "SARESP siblings info + nota painel long"
save "$user\siblings_complete.dta", replace

save "$geral\1.main data\siblings_complete.dta", replace





*************************************************************************************************

*                       STEP 4: juntar com as infos irmaos                                      *

*************************************************************************************************






