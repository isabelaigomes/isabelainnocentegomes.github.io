********************************************************************************
*                  Siblings spillovers BR paper                                *
*                       DATA FROM SARESP - OTHER DATA                          *
********************************************************************************

//Isabela Innocente Gomes de Oliveira


******************************
*unfinished
******************************


clear all

//defining paths

global isabela 1

if $isabela	     {
	global 		user 	"C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\0. Replication\2_data\2.1_raw\SARESP"
}
*
cd "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\0. Replication\2_data\2.1_raw\SARESP"


******************************************
* 1. changing data from csv to dta format
******************************************
***************
//2019
***************

*students data
import delimited "$user\2019\Questionario_alunos_2019.csv", encoding(UTF-8) 
drop if cd_aluno == "NULL"

rename q01 q1_aluno 
rename q02 q2_aluno 
rename q03 q3_aluno 
rename q04 q4_aluno 
rename q05 q5_aluno 
rename q06 q6_aluno 
rename q07 q7_aluno 
rename q08 q8_aluno 
rename q09 q9_aluno 

forvalue i = 10(1)49 {
rename q`i' q`i'_aluno
}

save "$user\2019\quest_alunos_2019.dta", replace


clear 
*parents data
import delimited "$user\2019\Questionario_Pais_2019.csv", encoding(UTF-8) 
drop if cd_aluno == "NULL"

rename q01 q1_pais 
rename q02 q2_pais 
rename q03 q3_pais  
rename q04 q4_pais 
rename q05 q5_pais 
rename q06 q6_pais  
rename q07 q7_pais  
rename q08 q8_pais  
rename q09 q9_pais  

forvalue i = 10(1)50 {
rename q`i' q`i'_pais 
}

merge 1:1 cd_aluno using "$user\2019\quest_alunos_2019.dta"
rename _merge merge1

*test scores
preserve
clear 
import delimited "$user\2019\MICRODADOS_SARESP_2019.csv", encoding(UTF-8) 
duplicates drop cd_aluno, force 
save "$user\2019\SARESP_2019.dta", replace
restore 

destring cd_aluno, replace 

merge 1:1 cd_aluno using "$user\2019\SARESP_2019.dta", force
 
gen year = 2019
save "$user\2019\SARESP_2019.dta", replace


clear 



********************************************************************************
***************
//2018
***************

*students 
import delimited "$user\2018\Saresp2018_Quest_Alunos.csv", encoding(UTF-8) 
forvalue i = 1(1)49 {
rename q`i' q`i'_aluno
}

save "$user\2018\quest_alunos_2018.dta", replace

clear 
*parents 
import delimited "$user\2018\Saresp2018_Quest_Pais.csv", encoding(UTF-8) 
forvalue i = 1(1)49 {
rename q`i' q`i'_pais
}

merge 1:1 cd_aluno using "$user\2018\quest_alunos_2018.dta"
rename _merge merge1

*test scores
preserve
clear 
import delimited "$user\2018\MICRODADOS_SARESP_2018.csv", encoding(UTF-8) 
duplicates drop cd_aluno, force 
save "$user\2018\SARESP_2018.dta", replace
restore 

merge 1:1 cd_aluno using "$user\2018\SARESP_2018.dta", force
 
gen year = 2018
save "$user\2018\SARESP_2018.dta", replace


clear 


*************************************************************************************
// 2014,2015,2016,2017 -> we do not have questionare information, only test scores 
*************************************************************************************
***************
//2013
***************

*students 
import delimited "$user\2013\Saresp2013_Alunos_2_3_5EF.csv", encoding(UTF-8)
save "$user\2013\quest_alunos_1_2013.dta", replace
clear 

import delimited "$user\2013\Saresp2013_Alunos_7_9EF.csv", encoding(UTF-8) 

save "$user\2013\quest_alunos_2_2013.dta", replace
clear 

import delimited "$user\2013\Saresp2013_Alunos_3EM.csv", encoding(UTF-8) 
gen terceirao = 1

*append 
append using "$user\2013\quest_alunos_2_2013.dta"
append using "$user\2013\quest_alunos_1_2013.dta"

duplicates drop cd_aluno, force 

forvalue i = 32(1)53 {
rename q`i'* q`i'*_aluno
} 

save "$user\2013\quest_alunos_2013.dta", replace
erase  "$user\2013\quest_alunos_1_2013.dta" 
erase "$user\2013\quest_alunos_2_2013.dta"

clear 

*parents 
import delimited "$user\2013\Saresp2013_Pais_2_3_5EF.csv", encoding(UTF-8) 
save "$user\2013\quest_pais_1_2013.dta", replace
clear 

import delimited "$user\2013\Saresp2013_Pais_7_9EF.csv", encoding(UTF-8) 
save "$user\2013\quest_pais_2_2013.dta", replace
clear 

import delimited "$user\2013\Saresp2013_Pais_3EM.csv", encoding(UTF-8) 
gen terceirao = 1

*append 
append using "$user\2013\quest_pais_2_2013.dta"
append using "$user\2013\quest_pais_1_2013.dta"

duplicates drop cd_aluno, force 

forvalue i = 1(1)3 {
rename q`i'* q`i'*_pais
}


forvalue i = 5(1)31 {
rename q`i'* q`i'*_pais
}

save "$user\2013\quest_pais_2013.dta", replace

erase  "$user\2013\quest_pais_1_2013.dta" 
erase "$user\2013\quest_pais_2_2013.dta"

*merge students and parents 

merge 1:1 cd_aluno using "$user\2013\quest_alunos_2013.dta" 
drop _merge

erase "$user\2013\quest_alunos_2013.dta"
erase "$user\2013\quest_pais_2013.dta"

*test scores 
preserve
clear 
import delimited "$user\2013\MICRODADOS_SARESP_2013.csv", encoding(UTF-8) 
duplicates drop cd_aluno, force 
save "$user\2013\SARESP_2013.dta", replace
restore 

merge 1:1 cd_aluno using "$user\2013\SARESP_2013.dta", force

gen year = 2013
save "$user\2013\SARESP_2013.dta", replace

clear




***************
//2012
***************


*ALUNOS
import delimited "$user\2012\Saresp2012_Alunos_3_5EF.csv", encoding(UTF-8) 
save "$user\2012\quest_alunos_1_2012.dta", replace
clear 

import delimited "$user\2012\Saresp2012_Alunos_7_9EF.csv", encoding(UTF-8) 
save "$user\2012\quest_alunos_2_2012.dta", replace
clear 

import delimited "$user\2012\Saresp2012_Alunos_3EM.csv", encoding(UTF-8) 
gen terceirao = 1

*append 
append using "$user\2012\quest_alunos_2_2012.dta", force
append using "$user\2012\quest_alunos_1_2012.dta", force

duplicates drop cd_aluno, force 

forvalue i = 32(1)53 {
rename q`i'* q`i'*_aluno
} 


save "$user\2012\quest_alunos_2012.dta", replace
erase  "$user\2012\quest_alunos_1_2012.dta" 
erase "$user\2012\quest_alunos_2_2012.dta"

clear 

*PAIS
import delimited "$user\2012\Saresp2012_Pais_3_5EF.csv", encoding(UTF-8) 
save "$user\2012\quest_pais_1_2012.dta", replace
clear 

import delimited "$user\2012\Saresp2012_Pais_7_9EF.csv", encoding(UTF-8) 
save "$user\2012\quest_pais_2_2012.dta", replace
clear 

import delimited "$user\2012\Saresp2012_Pais_3EM.csv", encoding(UTF-8) 
gen terceirao = 1

*append 
append using "$user\2012\quest_pais_2_2012.dta", force
append using "$user\2012\quest_pais_1_2012.dta", force

duplicates drop cd_aluno, force 

forvalue i = 1(1)3 {
rename q`i'* q`i'*_pais
}


forvalue i = 5(1)31 {
rename q`i'* q`i'*_pais
}


save "$user\2012\quest_pais_2012.dta", replace

erase  "$user\2012\quest_pais_1_2012.dta" 
erase "$user\2012\quest_pais_2_2012.dta"

*JUNTANDO ALUNOS E PAIS

merge 1:1 cd_aluno using "$user\2012\quest_alunos_2012.dta",force
//match perfeito 
drop _merge

erase "$user\2012\quest_alunos_2012.dta"
erase "$user\2012\quest_pais_2012.dta"

*notas
preserve
clear 
import delimited "$user\2012\MICRODADOS_SARESP_2012.csv", encoding(UTF-8) 
duplicates drop cd_aluno, force 
save "$user\2012\SARESP_2012.dta", replace
restore 

merge 1:1 cd_aluno using "$user\2012\SARESP_2012.dta", force

gen year = 2012
save "$user\2012\SARESP_2012.dta", replace


clear




*****************
*     2011      *
*****************

*students 
import delimited "$user\2011\Saresp2011_Quest_Alunos_3_5.csv", encoding(UTF-8) 
save "$user\2011\quest_alunos_1_2011.dta", replace
clear 

import delimited "$user\2011\Saresp2011_Quest_Alunos_7_9.csv", encoding(UTF-8) 
save "$user\2011\quest_alunos_2_2011.dta", replace
clear 

import delimited "$user\2011\Saresp2011_Quest_Alunos_3EM.csv", encoding(UTF-8) 
gen terceirao = 1

*append 
append using "$user\2011\quest_alunos_2_2011.dta", force
append using "$user\2011\quest_alunos_1_2011.dta", force

duplicates drop cd_aluno, force 

*rename q_32 q_32_
*rename q_33 q_33_
*rename q_34 q_34_

forvalue i = 32(1)53 {
rename q`i'* q`i'*_aluno
} 


save "$user\2011\quest_alunos_2011.dta", replace
erase  "$user\2011\quest_alunos_1_2011.dta" 
erase "$user\2011\quest_alunos_2_2011.dta"

clear 

*parents 
import delimited "$user\2011\Saresp2011_Quest_Pais_3_5.csv", encoding(UTF-8) 
save "$user\2011\quest_pais_1_2011.dta", replace
clear 

import delimited "$user\2011\Saresp2011_Quest_Pais_7_9.csv", encoding(UTF-8) 
save "$user\2011\quest_pais_2_2011.dta", replace
clear 

import delimited "$user\2011\Saresp2011_Quest_Pais_3EM.csv", encoding(UTF-8) 
gen terceirao = 1

*append 
append using "$user\2011\quest_pais_2_2011.dta", force
append using "$user\2011\quest_pais_1_2011.dta", force

duplicates drop cd_aluno, force 


forvalue i = 1(1)31 {
rename q`i'* q`i'*_pais
}

save "$user\2011\quest_pais_2011.dta", replace

erase  "$user\2011\quest_pais_1_2011.dta" 
erase "$user\2011\quest_pais_2_2011.dta"

*merge 

merge 1:1 cd_aluno using "$user\2011\quest_alunos_2011.dta",force
drop _merge

erase "$user\2011\quest_alunos_2011.dta"
erase "$user\2011\quest_pais_2011.dta"

*test scores 
preserve
clear 
import delimited "$user\2011\MICRODADOS_SARESP_2011.csv", encoding(UTF-8) 
duplicates drop cd_aluno, force 
save "$user\2011\SARESP_2011.dta", replace
restore 

merge 1:1 cd_aluno using "$user\2011\SARESP_2011.dta", force

gen year = 2011
save "$user\2011\SARESP_2011.dta", replace


clear 



*****************
*     2010      *
*****************


*students 
import delimited "$user\2010\Saresp2010_Quest_Alunos_3_5.csv", encoding(UTF-8) 
save "$user\2010\quest_alunos_1_2010.dta", replace
clear 

import delimited "$user\2010\Saresp2010_Quest_Alunos_7_9.csv", encoding(UTF-8) 
save "$user\2010\quest_alunos_2_2010.dta", replace
clear 

import delimited "$user\2010\Saresp2010_Quest_Alunos_3EM.csv", encoding(UTF-8) 
gen terceirao = 1

*append 
append using "$user\2010\quest_alunos_2_2010.dta", force
append using "$user\2010\quest_alunos_1_2010.dta", force

duplicates drop cd_aluno, force 

rename q_32 q_32_
rename q_33 q_33_
rename q_34 q_34_


forvalue i = 32(1)53 {
rename q_`i'* q`i'*_aluno
} 


save "$user\2010\quest_alunos_2010.dta", replace
erase  "$user\2010\quest_alunos_1_2010.dta" 
erase "$user\2010\quest_alunos_2_2010.dta"

clear 

*Parents
import delimited "$user\2010\Saresp2010_Quest_Pais_3_5.csv", encoding(UTF-8) 
save "$user\2010\quest_pais_1_2010.dta", replace
clear 

import delimited "$user\2010\Saresp2010_Quest_Pais_7_9.csv", encoding(UTF-8) 
save "$user\2010\quest_pais_2_2010.dta", replace
clear 

import delimited "$user\2010\Saresp2010_Quest_Pais_3EM.csv", encoding(UTF-8) 
gen terceirao = 1

*append 
append using "$user\2010\quest_pais_2_2010.dta", force
append using "$user\2010\quest_pais_1_2010.dta", force

duplicates drop cd_aluno, force 

rename q_04 q04_pais
rename q_05 q05_pais
rename q_01 q01_pais

forvalue i = 2(1)3 {
rename q_`i'* q`i'*_pais
}

*forvalue i = 6(1)31 {
*rename q_`i'* q`i'*_pais
*}

save "$user\2010\quest_pais_2010.dta", replace

erase  "$user\2010\quest_pais_1_2010.dta" 
erase "$user\2010\quest_pais_2_2010.dta"

*merge 

merge 1:1 cd_aluno using "$user\2010\quest_alunos_2010.dta",force
drop _merge

erase "$user\2010\quest_alunos_2010.dta"
erase "$user\2010\quest_pais_2010.dta"

*notas
preserve
clear 
import delimited "$user\2010\MICRODADOS_SARESP_2010.csv", encoding(UTF-8) 
duplicates drop cd_aluno, force 
save "$user\2010\SARESP_2010.dta", replace
restore 

merge 1:1 cd_aluno using "$user\2010\SARESP_2010.dta", force

gen year = 2010
save "$user\2010\SARESP_2010.dta", replace





clear 
