********************************************************************************
*                  Siblings spillovers BR paper                                *
*                       DATA FROM SARESP - TEST SCORES                        *
********************************************************************************

//Isabela Innocente Gomes de Oliveira

clear all

//defining paths

global isabela 1

if $isabela	     {
	gl  intermed "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\0. Replication\2_data\2.1_raw\intermed"
	gl saresp "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\0. Replication\2_data\2.1_raw\SARESP"
    gl geral "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\0. Replication\2_data"
	gl link "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\0. Replication\2_data\2.1_raw"

}
*

// Here we get information coming from SARESP on tests scores for the siblings


*********************************************
* STEP 0: have a dataset we only sibling id *
*********************************************

********************************************************************************
//    ATTENTION: my goal is to get 2 datasets: one with only tests scores and 
//            the other with tests scores and characteristics
********************************************************************************


*wide panel of tests scores 

use "$link\baseirmaos.dta"
tempfile siblings
save `siblings'
clear 


forvalue i = 2010(1)2019 {

import delimited "$saresp\notas apenas\MICRODADOS_SARESP_`i'.csv", encoding(UTF-8) clear 
keep cd_aluno codmun mun codesc serie turma classe tp_sexo dt_nascimento periodo particip* total_ponto* porc_acert* profic* nivel_profic* classific*


//                           ADJUSTING VARIABLES

//1. BIRTH DATE
split dt_nascimento, p("-")
destring dt_nascimento1, gen(ano_nasc) 
destring dt_nascimento2, gen(mes_nasc) 
drop dt_nascimento1 dt_nascimento2
order cd_aluno dt_nascimento ano_nasc mes_nasc

//2. GENDER
gen fem = 1 if tp_sexo == "2"
replace fem = 0 if tp_sexo == "1"
order  cd_aluno ano_nasc mes_nasc fem 
drop tp_sexo 

//3. MUNICIPALITY
gen codigo_mun = codmun 
label var codigo_mun "codigo municipio"
rename mun nome_mun 
label var codesc "codigo escola"

//5. GRADE
order cd_aluno ano_nasc mes_nasc serie 

replace serie = "3-EM" if serie == "EM-3ª série"
replace serie = "2-EF" if serie == "2º Ano EF"
replace serie = "3-EF" if serie == "3º Ano EF"
replace serie = "5-EF" if serie == "5º Ano EF"
replace serie = "7-EF" if serie == "7º Ano EF"
replace serie = "9-EF" if serie == "9º Ano EF"

// 6. TEST SCORES
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


************************  RESTRICTING SAMPLE **********************************
duplicates drop cd_aluno, force 

//R1 = keeping brothers we find in  201i (who are in grades 2,3,5,7 or 9)
merge 1:1 cd_aluno using `siblings', gen(merge)
drop if merge==1




save "$saresp\notas apenas\notas_siblings_`i'.dta", replace 
clear 


}


*******************************************************
*                    aggregate data
*******************************************************
use "$saresp\notas apenas\notas_siblings_2019.dta"


forvalue i = 2010(1)2018 {

merge 1:1 cd_aluno using "$saresp\notas apenas\notas_siblings_`i'.dta", nogen 

}




*expand variables that do not vary in time/year 
drop dt_nasc


*gender, birth month and birth year 
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



*double check
drop merge 
local v2 ano_nasc mes_nasc fem serie codesc 
foreach x of local v2 {

forvalue i = 2010(1)2019 {
rename `x'_`i' `x'_`i'_S

}
}


*merge all info
merge 1:1 cd_aluno using "$link\panelsiblings1_wide.dta", nogen 


****** variable adjustments
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

save "$link\painelsib_notas_wide.dta", replace 



//LONG VERSION
replace classe_2011 = "." if classe_2011 == "NULL"
destring classe_2011, replace 

reshape long ano_nasc_ mes_nasc_ dia_nasc_ fem_ white_ bf_ cd_cor_raca_ serie_ nome_mun_ turma_ classe_ periodo_ particip_lp_ particip_mat_ total_ponto_lp_ total_ponto_mat_ porc_acert_lp_ porc_acert_mat_  profic_lp_ profic_mat_ nivel_profic_lp_ nivel_profic_mat_ classific_lp_ classific_mat_ codigo_mun_ codesc_, i(cd_aluno) 
rename _j year 

save "$link\painelsib_notas_long.dta", replace 



********************************************************************************
*****************   VERSION WITH ALL VARIABLES *********************************
********************************************************************************


use "$link\baseirmaos.dta"
tempfile siblings
rename cd_aluno CD_IRMAO 
save `siblings'
clear 


//STEP 1: get siblings info from SARESP


//1.1 SARESP FULL -> with parents and students questionare

***************
*    2019     *
***************
use "$saresp\2019\SARESP_2019.dta"
rename cd_aluno CD_IRMAO

merge 1:1 CD_IRMAO using `siblings', gen(merge)
//lets drop students without siblings 
drop if merge==1

save "$intermed\sibling_2019.dta", replace

clear 


***************
*    2018     *
***************
use "$saresp\2018\SARESP_2018.dta"
rename cd_aluno CD_IRMAO

merge 1:1 CD_IRMAO using `siblings', gen(merge)
//lets drop students without siblings 
drop if merge==1

save "$intermed\sibling_2018.dta", replace


*********************
*    2009 - 2013    *
*********************
forvalue i = 2009(1)2013 {

use "$saresp\\`i'\SARESP_`i'.dta"
rename cd_aluno CD_IRMAO


merge 1:1 CD_IRMAO using `siblings', gen(merge)
//lets drop students without siblings 
drop if merge==1

save "$intermed\sibling_`i'.dta", replace

}

use "$link\baseirmaos.dta"
tempfile siblings
rename cd_aluno CD_IRMAO 
save `siblings'
clear 



***********************************************************************************
// 2014,2015,2016,2017 -> we do not have questionare information, only test scores 
***********************************************************************************



forvalue i = 2014(1)2017 {
clear 

import delimited "$saresp\notas apenas\MICRODADOS_SARESP_`i'.csv", encoding(UTF-8) 
duplicates drop cd_aluno, force 
rename cd_aluno CD_IRMAO

merge 1:1 CD_IRMAO using `siblings', gen(merge)

drop if merge==1

save "$intermed\sibling_`i'.dta", replace

}


clear 




***************************************************************
*     STEP 2: cleaning siblings data by year                  *
***************************************************************
                      //////////////
                     //   2019   //
                     /////////////

use "$intermed\sibling_2019.dta"


label var CD_IRMAO "sibling id"

*birth date 
tostring dt_nascimento, replace 
gen ano_nasc = substr(dt_nascimento,1,4)
gen teste = substr(dt_nascimento,5,6)
gen mes_nasc = substr(teste,1,2)
gen dia_nasc = substr(dt_nascimento,7,8)

drop teste dt_nascimento

destring ano_nasc, replace 
destring mes_nasc, replace 
destring dia_nasc, replace 

*gender 
gen fem = 1 if sexo == "F"
replace fem = 0 if sexo == "M"

order CD_IRMAO ano_nasc mes_nasc dia_nasc fem 

drop sexo

*disability
label var tem_nec "any type of disability"
drop cd_dre nm_dre 

order CD_IRMAO ano_nasc mes_nasc dia_nasc fem turma periodo rede cd_mun nm_mun cd_ue cdrede de codmun mun codesc nomesc

gen codigo_mun = cd_mun 
replace codigo_mun = codmun if cd_mun == .
label var codigo_mun "municipality code"

gen nome_mun = mun
replace nome_mun = nm_mun if mun == "."

drop rede cd_mun de cd_ue nm_mun codmun mun 


label var cdrede "id rede ensino"
label var codesc "school id"

replace serie = "3-EM" if serie == "EM-3ª série"
replace serie = "2-EF" if serie == "2º Ano EF"
replace serie = "3-EF" if serie == "3º Ano EF"
replace serie = "5-EF" if serie == "5º Ano EF"
replace serie = "7-EF" if serie == "7º Ano EF"
replace serie = "9-EF" if serie == "9º Ano EF"


drop nomedep nomedepbol tp_sexo tip_prova cad_prova* 
label var tipoclasse "type of class: 0 = regular; 3= aceleration; 5 = recovery e 10 = PIC "

label var nec_esp_1 ""
label var nec_esp_2 ""
label var nec_esp_3 ""
label var nec_esp_4 ""
label var nec_esp_5 ""

*test scores  
destring porc_acert_lp, replace dpcomma
destring porc_acert_mat, replace dpcomma

replace profic_lp = "." if profic_lp == "NULL"
replace profic_mat = "." if profic_mat == "NULL"
destring profic_lp, replace dpcomma
destring profic_mat, replace dpcomma


*********  questions ***********
drop q1_aluno q2_aluno q3_aluno q4_aluno q5_aluno q6_aluno q7_aluno q8_aluno q17_aluno q18_aluno q19_aluno q20_aluno q21_aluno q43_aluno q44_aluno q45_aluno q46_aluno q47_aluno q48_aluno q49_aluno
gen educ_infantil = 1 if q9_aluno == "A"
replace educ_infantil = 0 if q9_aluno == "B"
label var educ_infantil "if the student did kindergarten or not"

gen reprov = 1 if q10_aluno == "B" | q10_aluno == "C"
replace reprov = 0 if  q10_aluno == "A" 

drop q9_aluno q10_aluno

gen fazlicao_mat = 1 if q23_aluno == "A" | q23_aluno == "B"
replace fazlicao_mat = 0 if q23_aluno == "C"

gen fazlicao_port = 1 if q25_aluno == "A" | q25_aluno == "B"
replace fazlicao_port = 0 if q25_aluno == "C"

drop q23_aluno q25_aluno

gen discriminacao = 1 if q34_aluno == "A"
replace discriminacao = 0 if q34_aluno == "B"

drop q34_aluno 

**********  parents questionare **************
drop q1_pais q2_pais q3_pais q4_pais q5_pais q6_pais q7_pais q8_pais q9_pais q11_pais

*q10_pais parents perception if kids do homework
*q12_pais - q18 parents participate in their kids school life's 

rename q19_pais educpai
tab educpai, gen(educpai_)

rename q20_pais educmae
tab educmae, gen(educmae_)

rename q21_pais emprego_pai
rename q22_pais emprego_mae

rename q23_pais renda
tab renda, gen(faixarenda)

drop q24_pais q25_pais q26_pais q27_pais q28_pais q29_pais q3*_pais q4*_pais q50_pais 

****************  restrict sample ******************************
//R1 = keeping students who have siblings from 2010-2019
drop if merge==2

save "$intermed\C_sibling_2019.dta", replace
clear 



                     //////////////
                     //   2018   //
                     /////////////


use "$intermed\sibling_2018.dta"

label var CD_IRMAO "sibling id"

//1. BIRTH DATE
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


//2. GENDER
gen fem = 1 if sexo == "F" | tp_sexo == "2"
replace fem = 0 if sexo == "M" | tp_sexo == "1"

order CD_IRMAO ano_nasc mes_nasc fem 
drop sexo tp_sexo 


//3. OTHER VARIABLES 

*DISABILITY
label var tem_nec "any type of disability"

drop cd_dre nm_dre 

order CD_IRMAO ano_nasc mes_nasc fem turma periodo rede cd_mun nm_mun cd_ue cdrede de codmun mun codesc nomesc

//4. MUNICIPALITY
gen codigo_mun = cd_mun 
replace codigo_mun = codmun if cd_mun == .
label var codigo_mun "MUN CODE"

gen nome_mun = mun
replace nome_mun = nm_mun if mun == "."

drop rede cd_mun de cd_ue nm_mun codmun mun 

label var cdrede "rede ensino ID "
label var codesc "SCHOOL ID"

//5. GRADE 
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

drop nomedep nomedepbol tip_prova cad_prova* 

label var tipoclasse "Código do Tipo de Classe da Turma; Informações: 0 = Classe regular; 3= Classe de Aceleração; 5 = Recuperação de Ciclo e 10 = PIC "


//6. MORE DISABILITY VARIABLES 
label var nec_esp_1 ""
label var nec_esp_2 ""
label var nec_esp_3 ""
label var nec_esp_4 ""
label var nec_esp_5 ""

// 7. TEST SCORES 
destring porc_acert_lp, replace dpcomma
destring porc_acert_mat, replace dpcomma

replace profic_lp = "." if profic_lp == "NULL"
replace profic_mat = "." if profic_mat == "NULL"
destring profic_lp, replace dpcomma
destring profic_mat, replace dpcomma



//8. SOCIO ECONOMIC QUESTIONS 

//8.1
*********  STUDENTS ***********
drop q1_aluno q2_aluno q3_aluno q4_aluno q5_aluno q6_aluno q7_aluno q8_aluno q17_aluno q18_aluno q19_aluno q20_aluno q21_aluno q43_aluno q44_aluno q45_aluno q46_aluno q47_aluno q48_aluno q49_aluno

gen educ_infantil = 1 if q9_aluno == "A"
replace educ_infantil = 0 if q9_aluno == "B"
label var educ_infantil "student enrolled at kindergarten or not"

gen reprov = 1 if q10_aluno == "B" | q10_aluno == "C"
replace reprov = 0 if  q10_aluno == "A" 

drop q9_aluno q10_aluno

gen fazlicao_mat = 1 if q23_aluno == "A" | q23_aluno == "B"
replace fazlicao_mat = 0 if q23_aluno == "C"

gen fazlicao_port = 1 if q25_aluno == "A" | q25_aluno == "B"
replace fazlicao_port = 0 if q25_aluno == "C"

drop q23_aluno q25_aluno

gen discriminacao = 1 if q34_aluno == "A"
replace discriminacao = 0 if q34_aluno == "B"

drop q34_aluno 


//8.2
**********  parents **************
drop q1_pais q2_pais q3_pais q4_pais q5_pais q6_pais q7_pais q8_pais q9_pais q11_pais

*q10_pais - parents percention on childrens' homework
*q12_pais - q18 parents participate in their kids school life

rename q19_pais educpai
tab educpai, gen(educpai_)

rename q20_pais educmae
tab educmae, gen(educmae_)

rename q21_pais emprego_pai
rename q22_pais emprego_mae

rename q23_pais renda
tab renda, gen(faixarenda)

drop q24_pais q25_pais q26_pais q27_pais q28_pais q29_pais q3*_pais q4*_pais 



************************  sample restricition **********************************
//R1 = keeping students who have siblings from 2010-2019
drop if merge==2
save "$intermed\C_sibling_2018.dta", replace
clear 


                    ///////////////////
                   //   2014-2017   //
                  ///////////////////

				  
forvalue i = 2014(1)2017 {

				  
use "$intermed\sibling_`i'.dta"

label var CD_IRMAO "sibling id"

//1. BIRTH DATE 
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


//2. GENDER 
gen fem = 1 if tp_sexo == "2"
replace fem = 0 if tp_sexo == "1"

order CD_IRMAO ano_nasc mes_nasc fem 
drop tp_sexo 


//3. OTHER VARIABLES 

*DISABILITY
label var tem_nec "any type of disability"


order CD_IRMAO ano_nasc mes_nasc fem turma periodo cdrede de codmun mun codesc

//4. MUN
gen codigo_mun = codmun 
*replace codigo_mun = codmun if cd_mun == .
label var codigo_mun "mun id"

rename mun nome_mun 

/*gen nome_mun = mun
replace nome_mun = nm_mun if mun == "."
drop rede cd_mun de cd_ue nm_mun codmun mun*/
drop de codmun 

label var cdrede "rede ensino id "
label var codesc "school id"

//5. grade
order CD_IRMAO ano_nasc mes_nasc serie 

replace serie = "3-EM" if serie == "EM-3ª série"
replace serie = "2-EF" if serie == "2º Ano EF"
replace serie = "3-EF" if serie == "3º Ano EF"
replace serie = "5-EF" if serie == "5º Ano EF"
replace serie = "7-EF" if serie == "7º Ano EF"
replace serie = "9-EF" if serie == "9º Ano EF"

drop nomedep nomedepbol tip_prova cad_prova* 

label var tipoclasse "Código do Tipo de Classe da Turma; Informações: 0 = Classe regular; 3= Classe de Aceleração; 5 = Recuperação de Ciclo e 10 = PIC "



//6. more disability 
label var nec_esp_1 ""
label var nec_esp_2 ""
label var nec_esp_3 ""
label var nec_esp_4 ""
label var nec_esp_5 ""

// 7. tests scores 
destring porc_acert_lp, replace dpcomma
destring porc_acert_mat, replace dpcomma

replace profic_lp = "." if profic_lp == "NULL"
replace profic_mat = "." if profic_mat == "NULL"
destring profic_lp, replace dpcomma
destring profic_mat, replace dpcomma



************************  sample restricition **********************************
//R1 = keeping students who have siblings from 2010-2019
drop if merge==2

gen year = `i'

save "$intermed\C_sibling_`i'.dta", replace
clear 


}


                   ///////////////////
                   //     2013      //
                  ///////////////////
				  

use "$intermed\sibling_2013.dta"

label var CD_IRMAO "sibling id"

//1. BIRTH DATE
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


//2. GENDER
gen fem = 1 if sexo == "F" | tp_sexo == "2"
replace fem = 0 if sexo == "M" | tp_sexo == "1"

order CD_IRMAO ano_nasc mes_nasc fem 
drop sexo tp_sexo 



//3. OTHER VARIABLES 

*DISABILITY
label var tem_nec "any type of disability"


order CD_IRMAO ano_nasc mes_nasc fem turma periodo cdrede de codmun mun codesc nomesc

//4. MUNICIPALITY

gen codigo_mun = codmun
label var codigo_mun "MUN CODE"

rename mun nome_mun
drop de codmun

label var cdrede "rede ensino ID "
label var codesc "SCHOOL ID"

//5. GRADE 
order CD_IRMAO ano_nasc mes_nasc serie 

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


//6. MORE DISABILITY VARIABLES 

label var nec_esp_1 ""
label var nec_esp_2 ""
label var nec_esp_3 ""
label var nec_esp_4 ""
label var nec_esp_5 ""

// 7. TEST SCORES 
destring porc_acert_lp, replace dpcomma
destring porc_acert_mat, replace dpcomma

replace profic_lp = "." if profic_lp == "NULL"
replace profic_mat = "." if profic_mat == "NULL"
destring profic_lp, replace dpcomma
destring profic_mat, replace dpcomma


//8. SOCIO ECONOMIC QUESTIONS 

//8.1
*********  STUDENTS ***********
gen educ_infantil = 1 if q32_aluno == "A"
replace educ_infantil = 0 if q32_aluno == "B" | q32_aluno == "C"
label var educ_infantil "aluno comecou na educ infantil vs direto EF1"

gen reprov = .
replace reprov = 1 if q33_aluno == "C" | q33_aluno == "D" | q33_aluno == "E" | q33_aluno == "F" | q34_aluno == "C" | q34_aluno == "D" | q34_aluno == "E" | q34_aluno == "F"
replace reprov = 0 if  q33_aluno == "A"  | q33_aluno == "B" | q34_aluno == "A"  | q34_aluno == "B" 
*obs: alunos do EM tem que considerar tbm q34 
*faz licao e discriminacao eu não gerei aqui 


//RACE
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

drop q*_aluno


//8.2
**********  parents **************

rename q18_pais_pais educpai
tab educpai, gen(educpai_)

rename q21_pais_pais educmae
tab educmae, gen(educmae_)

rename q16_pais_pais emprego_pai
rename q19_pais_pais emprego_mae

rename q24_pais_pais renda
tab renda, gen(faixarenda)

drop q*_pais 
drop q54 q55 q56 q57 q58 q59 q60 q61

************************  sample restricition **********************************
//R1 = keeping students who have siblings from 2010-2019
drop if merge==2



save "$intermed\C_sibling_2013.dta", replace
clear 


                    ///////////////////
                   //     2012     //
                  ///////////////////
				  

use "$intermed\sibling_2012.dta"

label var CD_IRMAO "sibling id"

//1. BIRTH DATE

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


//2. GENDER
gen fem = 1 if sexo == "F" | tp_sexo == "2"
replace fem = 0 if sexo == "M" | tp_sexo == "1"

order CD_IRMAO ano_nasc mes_nasc fem 
drop sexo tp_sexo 


//3. OTHER VARIABLES 
*DISABILITY
label var tem_nec "any type of disability" 
order CD_IRMAO ano_nasc mes_nasc fem turma periodo cdrede de codmun mun codesc nomesc

//4. MUN
gen codigo_mun = codmun
label var codigo_mun "MUN CODE"

rename mun nome_mun
drop de codmun

label var cdrede "rede ensino ID "
label var codesc "SCHOOL ID"

//5. GRADE 
order CD_IRMAO ano_nasc mes_nasc serie 

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

drop nomedep nomedepbol tip_prova cad_prova* 

label var tipoclasse "Código do Tipo de Classe da Turma; Informações: 0 = Classe regular; 3= Classe de Aceleração; 5 = Recuperação de Ciclo e 10 = PIC "

//6. MORE DISABILITY VARIABLES 
label var nec_esp_1 ""
label var nec_esp_2 ""
label var nec_esp_3 ""
label var nec_esp_4 ""
label var nec_esp_5 ""

// 7. TEST SCORES 
destring porc_acert_lp, replace dpcomma
destring porc_acert_mat, replace dpcomma

replace profic_lp = "." if profic_lp == "NULL"
replace profic_mat = "." if profic_mat == "NULL"
destring profic_lp, replace dpcomma
destring profic_mat, replace dpcomma


//8. SOCIO ECONOMIC QUESTIONS 

//8.1
*********  STUDENTS ***********
gen educ_infantil = 1 if q32_aluno == "A"
replace educ_infantil = 0 if q32_aluno == "B" | q32_aluno == "C"
label var educ_infantil "student enrolled at kindergarten or not"

gen reprov = .
replace reprov = 1 if q33_aluno == "C" | q33_aluno == "D" | q33_aluno == "E" | q33_aluno == "F" | q34_aluno == "C" | q34_aluno == "D" | q34_aluno == "E" | q34_aluno == "F"
replace reprov = 0 if  q33_aluno == "A"  | q33_aluno == "B" | q34_aluno == "A"  | q34_aluno == "B" 

*RACE 
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

drop q*_aluno


//8.2
**********  parents **************

rename q18_pais_pais educpai
tab educpai, gen(educpai_)

rename q21_pais_pais educmae
tab educmae, gen(educmae_)

rename q16_pais_pais emprego_pai
rename q19_pais_pais emprego_mae

rename q24_pais_pais renda
tab renda, gen(faixarenda)

drop q*_pais 


************************  sample restricition **********************************
//R1 = keeping students who have siblings from 2010-2019
drop if merge==2



save "$intermed\C_sibling_2012.dta", replace
clear 






                    ///////////////////
                   //     2011     //
                  ///////////////////
				  

use "$intermed\sibling_2011.dta"

label var CD_IRMAO "sibling id"

//1. BIRTH DATE

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


//2. GENDER
gen fem = 1 if sexo == "F" | tp_sexo == "2"
replace fem = 0 if sexo == "M" | tp_sexo == "1"

order CD_IRMAO ano_nasc mes_nasc fem 
drop sexo tp_sexo 


//3. OTHER VARIABLES 

*DISABILITY
label var tem_nec "any type of disability"

order CD_IRMAO ano_nasc mes_nasc fem turma periodo cdrede de codmun mun codesc 

//4. MUN
gen codigo_mun = codmun
label var codigo_mun "MUN CODE"

rename mun nome_mun
drop de codmun

label var cdrede "rede ensino ID "
label var codesc "SCHOOL ID"

//5. CLASS
order CD_IRMAO ano_nasc mes_nasc serie 

*CLASS variable named serie has no value

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

drop nomedep nomedepbol tip_prova cad_prova* 

label var tipoclasse "Código do Tipo de Classe da Turma; Informações: 0 = Classe regular; 3= Classe de Aceleração; 5 = Recuperação de Ciclo e 10 = PIC "


//6. MORE DISABILITY VARIABLES
 label var nec_esp_1 ""
label var nec_esp_2 ""
label var nec_esp_3 ""
label var nec_esp_4 ""
label var nec_esp_5 ""

// 7. TEST SCORES 
destring porc_acert_lp, replace dpcomma
destring porc_acert_mat, replace dpcomma

replace profic_lp = "." if profic_lp == "NULL"
replace profic_mat = "." if profic_mat == "NULL"
destring profic_lp, replace dpcomma
destring profic_mat, replace dpcomma



//8. SOCIO ECONOMIC QUESTIONS 

//8.1
*********  STUDENTS ***********
gen educ_infantil = 1 if q32_aluno == "A"
replace educ_infantil = 0 if q32_aluno == "B" | q32_aluno == "C"
label var educ_infantil "student enrolled at kindergarten or not"

gen reprov = .
replace reprov = 1 if q33_aluno == "C" | q33_aluno == "D" | q33_aluno == "E" | q33_aluno == "F" | q34_aluno == "C" | q34_aluno == "D" | q34_aluno == "E" | q34_aluno == "F"
replace reprov = 0 if  q33_aluno == "A"  | q33_aluno == "B" | q34_aluno == "A"  | q34_aluno == "B" 



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
drop q*_aluno


//8.2
**********  parents **************

rename q18_pais_pais educpai
tab educpai, gen(educpai_)

rename q21_pais_pais educmae
tab educmae, gen(educmae_)

rename q16_pais_pais emprego_pai
rename q19_pais_pais emprego_mae

rename q24_pais_pais renda
tab renda, gen(faixarenda)

drop q*_pais 
drop q54 q55 q56 q57 q58 q59 q60 q61

************************  sample restricition **********************************
//R1 = keeping students who have siblings from 2010-2019
drop if merge==2

save "$intermed\C_sibling_2011.dta", replace
clear 




                    ///////////////////
                   //     2010     //
                  ///////////////////	  

use "$intermed\sibling_2010.dta"
label var CD_IRMAO "sibling id"

//1. BIRTH DATE

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


//2. GENDER
gen fem = 1 if sexo == "F" | tp_sexo == "2"
replace fem = 0 if sexo == "M" | tp_sexo == "1"

order CD_IRMAO ano_nasc mes_nasc fem 
drop sexo tp_sexo 


//3. OTHER VARIABLES 

*DISABILITY
label var tem_nec "any type of disability"


order CD_IRMAO ano_nasc mes_nasc fem turma periodo cdrede de codmun mun codesc 

//4. MUNICIPALITY
gen codigo_mun = codmun
label var codigo_mun "MUN CODE"

rename mun nome_mun
drop de codmun

label var cdrede "rede ensino ID "
label var codesc "SCHOOL ID"

//5. TEST SCORES 
order CD_IRMAO ano_nasc mes_nasc serie 

gen serie_ = "."
replace serie_ = "3-EM" if serie_ano == "EM - 3ª Serie"

replace serie_ = "3-EF" if serie_ano == "3º Ano"
replace serie_ = "5-EF" if serie_ano == "5º Ano"
replace serie_ = "7-EF" if serie_ano == "7Âº Ano"
replace serie_ = "9-EF" if serie_ano == "9Âº Ano"

drop serie
rename serie_ serie 

drop nomedep nomedepbol tip_prova cad_prova* 

label var tipoclasse "Código do Tipo de Classe da Turma; Informações: 0 = Classe regular; 3= Classe de Aceleração; 5 = Recuperação de Ciclo e 10 = PIC "



//6. MORE DISABILITY VARIABLES
label var nec_esp_1 ""
label var nec_esp_2 ""
label var nec_esp_3 ""
label var nec_esp_4 ""
label var nec_esp_5 ""

// 7. TEST SCORES 
destring porc_acert_lp, replace dpcomma
destring porc_acert_mat, replace dpcomma

replace profic_lp = "." if profic_lp == "NULL"
replace profic_mat = "." if profic_mat == "NULL"
destring profic_lp, replace dpcomma
destring profic_mat, replace dpcomma


//8. SOCIO ECONOMIC QUESTIONS 

//8.1
*********  STUDENTS ***********
gen educ_infantil = 1 if q32__aluno == "A"
replace educ_infantil = 0 if q32__aluno == "B" | q32__aluno == "C"
label var educ_infantil "student enrolled at kindergarten or not"

gen reprov = .
replace reprov = 1 if q33__aluno == "C" | q33__aluno == "D" | q33__aluno == "E" | q33__aluno == "F" | q34__aluno == "C" | q34__aluno == "D" | q34__aluno == "E" | q34__aluno == "F"
replace reprov = 0 if  q33__aluno == "A"  | q33__aluno == "B" | q34__aluno == "A"  | q34__aluno == "B" 


//8.2
**********  parents **************
rename q18 educpai
tab educpai, gen(educpai_)

rename q21 educmae
tab educmae, gen(educmae_)

rename q16 emprego_pai
rename q19 emprego_mae

rename q24 renda
tab renda, gen(faixarenda)

drop q_*
drop q*


************************  sample restricition **********************************
//R1 = keeping students who have siblings from 2010-2019
drop if merge==2



save "$intermed\C_sibling_2010.dta", replace
clear 


********************************************************************************

*                       STEP 3: APPEND                                         *

********************************************************************************

use "$intermed\C_sibling_2019.dta"
 
forvalue i = 2010(1)2018 {

append using "$intermed\C_sibling_`i'.dta", force 

}

unique CD_IRMAO
sort CD_IRMAO year
order CD_IRMAO year


bysort CD_IRMAO: gen indicador = _n

label data "SARESP siblings information + tests scores in long panel"
save "$intermed\siblings_complete.dta", replace



