********************************************************************************
*                  BASE ESTADO DE SP - DISSERTACAO 
*                  
*             GOAL: esse do-file vai (i)juntar a base info irmao + focal child 
*                    & (ii) começar as estimações iniciais ou estat descrit                 
********************************************************************************

//Isabela Innocente Gomes de Oliveira

clear all

//defining paths

global isabela 1

if $isabela	     {
	gl  user 	"C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\saresp+irmaos"
	gl saresp "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\SARESP"
    gl geral "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP"
	gl link "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\dados link"
	gl main "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\1.main data"
	gl descrit "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\2. Descritivas"
}
*

//O que faremos aqui:
// 1º juntar a base link dos siblings_info_notas com FC
// 2º criar as variaveis de link entre os irmãos e fazer os corte de amostra necessarios
// 3º pegar informações de nota das FC if necessary (ver paper)
// 4º fechar a base no formato certo (check wide ou long) + "ajeitar" as variaveis para cada caso -> é long!!!
// 5º FUTURO!! -> fazer os 4 passos acima p a base siblings_info_total_saresp



********************************************************************************
*         STEP 1: juntar a base link dos siblings_info_notas com FC            *
********************************************************************************

//renomear variaveis base cohort p indicar que são infos do IRMAO

use "$link\total limpo\cohort_FC-S.dta" 

drop temp nr_serie sg_uf nm_zona


rename year cohort 
label var cohort "cohort focal child"



local vaFC cod_esc cd_cor_raca cd_nacionalidade nm_cidade_nascmto nm_distrt_nasc birthdate ano_nasc mes_nasc dia_nasc fem white serie repetiu_prim_ano
foreach x of varlist `vaFC'{

rename `x' `x'_FC
label var `x'  "`x' da focal child"

}


tempfile cohort
save `cohort'

clear 

use "$main\painelsib_notas_long.dta"
rename cd_aluno cd_irmao


merge m:m cd_irmao using `cohort', nogen 


********************************************************************************
*         STEP 2: criar as variaveis de link entre os irmãos e fazer os corte 
*                            de amostra necessarios                            
********************************************************************************


//A)VARIAVEIS LINKANDO FOCAL CHILD & SIBLING

*ja temos twin 

///1. diferença de idade entre irmaos em dias

gen date_s = mdy(mes_nasc_, dia_nasc_, ano_nasc_)
gen date_FC = mdy(mes_nasc_FC, dia_nasc_FC, ano_nasc_FC)

format date_s %td
format date_FC %td

gen age_dif_days = date_s - date_FC


//2. quem é mais velho

*va older_fc sendo dummy se a FC é mais velha

gen older_FC = 0
replace older_FC = 1 if date_FC < date_s
label var older_FC "focal child is older than sibling"
replace older_FC=. if date_s == .

order cd_aluno cd_irmao date_s date_FC older_FC

tempfile intermed
save `intermed'

//3. mais de um sibling -> variavel criada na base wide 
clear 
use "$link\total limpo\cohort_FC-S.dta" 
tempfile cohort
save `cohort'

clear 
use "$main\painelsib_notas_wide.dta"
rename cd_aluno cd_irmao

merge 1:m cd_irmao using `cohort', nogen 

keep cd_aluno cd_irmao 
duplicates tag cd_aluno, gen(more_siblings)
tab more_siblings, gen(ms_) //aqui vai ATE 12!!!!
drop ms_1

merge 1:m cd_aluno cd_irmao using `intermed', nogen 






//B) CORTES DE AMOSTRA -> nao vamos fazer assim, a full sample ainda vai ser usada
// nº obs inicial 215.343

*C1: gemeos
///drop if twin == 1

*C2: restringir para irmao que tem pelo menos uma info de nota! 

gen particip = 1 if particip_lp_ == 1 | particip_mat_ == 1 

//decidi dropar mesmo pq com o corte abaixo vao sobrar poucos
//drop if particip != 1


*C3: dropar irmaos com mais de 8 anos de diferença de idade (focal child) -> isso são 2922 dias -> vamo round p 3000
//PODE SER QUESTIONAVEL
//drop if age_dif_days <-3000
//drop if age_dif_days > 3000


*C4: se tiver +de 1 irmao na amostra, pegar aquele cuja idade é mais proxima -> discutivel 


gen drop = 0
replace drop = 1 if twin == 1 | particip != 1 |  age_dif_days <-3000 | age_dif_days > 3000


save "$main\finalpanel_v1.dta", replace 




********************************************************************************
* STEP 5: vamos pegar as informações da base siblings.complete e adc aqui
********************************************************************************


// pegar a base siblings complete e deixar só as infos que NÃO temos aqui
// expandir infos que nao mudam de ano
//vamos dar um merge year cd_irmao e obter as infos


clear
use "$main\siblings_complete.dta"

rename CD_IRMAO cd_irmao 

*NAO VOU INCLUIR aqui as variaveis dos quest dos pais que podem ser usadas no futuro
drop ano_nasc mes_nasc dia_nasc fem turma cdrede serie q*_pais q*_aluno merge1 tipoclasse classe regiaometropolitana particip_lp particip_mat total_ponto_lp total_ponto_mat porc_acert_lp porc_acert_mat profic_lp profic_mat nivel_profic_lp nivel_profic_mat classific_lp classific_mat validade merge _merge codigo_mun nome_mun depadm co_instancia ds_instancia seqde coddist distr cod_per cod_ano serie_ano serie_ resp_pai resp_aluno inscricao terceirao coord municipio q5_10 q7_k q5* q6* etapa_ensino indicador periodo codesc cod_necep educmae_13 educpai_13

* Agora vamos "estender as informações" que são fixas


local v educ_infantil tem_nec educpai educmae 
foreach x of local v {
forvalue i =  2010(1)2019 {

gen `x'_`i' = `x' if year == `i'

}
}


local v educ_infantil tem_nec 
foreach x of local v {

forvalue i = 2010(1)2019 {

replace `x' = `x'_`i' if `x'_`i' !=. 

}
}



local v educpai educmae 
foreach x of local v {

forvalue i = 2010(1)2019 {

replace `x' = `x'_`i' if `x'_`i' != "." 

}
}

drop educ_infantil_* tem_nec_* educpai_* educmae_*


merge 1:1 cd_irmao year using "$main\finalpanel_v1.dta"

drop _merge

replace white_ = 1 if branco == 1 & white_ == .
replace white_ = 0 if branco == 0 & white_ == .

drop branco

********************************************************************************
********************************************************************************
*                           DESCRITIVAS E ETC                                  *
********************************************************************************
********************************************************************************
order cd_aluno cd_irmao cohort year older_FC




//     OUTCOMES - NOTAS
egen z_tp_mat = std(total_ponto_mat_)
label var z_tp_mat "normalizacao do total de pontos mat"

egen z_porc_mat = std(porc_acert_mat_)
label var z_porc_mat "normalizacao da porcentagem acertos mat"

egen z_profic_mat = std(profic_mat_)
label var z_profic_mat "normalizacao proficiencia mat"


egen z_tp_port = std(total_ponto_lp_)
label var z_tp_port "normalizacao do total de pontos port"

egen z_porc_port = std(porc_acert_lp_)
label var z_porc_port "normalizacao da porcentagem acertos port"

egen z_profic_port = std(profic_lp_)
label var z_profic_port "normalizacao proficiencia port"



// arrumando algumas variaveis 
drop bf_

rename white_ white
rename fem_ fem
rename ano_nasc_ ano_nasc 
rename mes_nasc_ mes_nasc
rename dia_nasc_ dia_nasc

order cd_aluno cd_irmao cohort year older_FC more_siblings age_dif_days white white_FC bf fem fem_FC ano_nasc mes_nasc dia_nasc ano_nasc_FC mes_nasc_FC dia_nasc_FC z_tp_mat z_porc_mat z_profic_mat z_tp_port z_porc_port z_profic_port tem_nec renda reprov


//running variable com zero no cutoff -> fazer na mao por enquanto

gen running = 0 if mes_nasc_FC == 6 & dia_nasc_FC == 30



*julho
forvalue i = 1(1)31 {

replace running = `i' if mes_nasc_FC == 7 & dia_nasc_FC == `i'
}


*agosto 
forvalue i = 1(1)31 {

replace running = `i' + 31 if mes_nasc_FC == 8 & dia_nasc_FC == `i'
}


*setembro 
forvalue i = 1(1)30 {

replace running = `i' + 62 if mes_nasc_FC == 9 & dia_nasc_FC == `i'
}


*outubro
forvalue i = 1(1)31 {

replace running = `i' + 92 if mes_nasc_FC == 10 & dia_nasc_FC == `i'
}


*novembro 
forvalue i = 1(1)30 {

replace running = `i' + 123 if mes_nasc_FC == 11 & dia_nasc_FC == `i'
}

*dezembro 
forvalue i = 1(1)31 {

replace running = `i' + 153 if mes_nasc_FC == 12 & dia_nasc_FC == `i'
}


*junho
forvalue i = 1(1)29 {

replace running = `i' - 30 if mes_nasc_FC == 6 & dia_nasc_FC == `i'
}


*maio
forvalue i = 1(1)31 {

replace running = `i' - 61 if mes_nasc_FC == 5 & dia_nasc_FC == `i'
}


*abril 
forvalue i = 1(1)30 {

replace running = `i' - 91 if mes_nasc_FC == 4 & dia_nasc_FC == `i'
}


*março 
forvalue i = 1(1)31 {

replace running = `i' - 122 if mes_nasc_FC == 3 & dia_nasc_FC == `i'
}


*fevereiro
forvalue i = 1(1)29 {

replace running = `i' - 151 if mes_nasc_FC == 2 & dia_nasc_FC == `i'
}


*janeiro 
forvalue i = 1(1)31 {

replace running = `i' - 182 if mes_nasc_FC == 1 & dia_nasc_FC == `i'
}


********************************************************************************
********************************************************************************
*                        ESTATISTICAS DESCRITIVAS 
********************************************************************************
********************************************************************************


order cd_aluno cd_irmao year cohort mes_nasc_FC dia_nasc_FC running

//definindo base como painel
xtset cd_irmao year

//o stata vai indicar como balanceado, mas eu meio que balanciei forçadamente, tem mtos missings -> para eu "tirar" isso eu teria que dropar obs que nao dao match quando eu junto info sibligs do SARESP com o id_irmao
// obs2: nao vou pegar por enquanto informacoes "extras" o saresp pq pode ter mto missings

// vamos usar a versao nao normalizada da porcentagem de acertos com as variaveis de nota -> porc_acert_lp_ porc_acert_mat_


//TESTE tabela descritiva q vai direto para o latex
tabstat white bf fem ano_nasc tem_nec porc_acert_lp_ porc_acert_mat_, c(stat) stat(mean sd min max n)
ereturn list

est clear

label var white "White"
label var bf "Bolsa Familia Program" //aqui podia ser ever on BF tbm
label var fem "Female"
label var ano_nasc "Birth year"

label var tem_nec "Disable"
label var porc_acert_lp_ "Portuguese test score"
label var porc_acert_mat_ "Math test score"


*vou criar uma variavel aqui para gerar as minhas descrit por group 

gen group = 1 if twin == 0
replace group = 2 if twin == 0 & particip == 1
replace group = 3 if drop == 0
gen group2 = 4 if drop == 0 & older_FC == 0
replace group2 = 5 if drop == 0 & older_FC == 1


est clear

estpost tabstat white bf fem ano_nasc tem_nec porc_acert_lp_ porc_acert_mat_, by(group) c(stat) stat(mean  n)
esttab, ///
 cells(" mean(fmt(%13.2fc)) sd(fmt(%13.2fc)) count") nonumber ///
  nomtitle nonote noobs label collabels("Mean" "N")

  
  
  
***********************************
*  TABELA 1: estilo paper Ozek    *
***********************************  
  
  
//ESSA É A TABELA (in the following) -> melhor fazer duas e juntar
est clear
estpost tabstat white bf fem ano_nasc tem_nec porc_acert_lp_ porc_acert_mat_, by(group) c(stat) stat(mean sd) nototal

esttab, main(mean) aux(sd) nostar nonumber unstack ///
   nonote noobs label ///
   collabels(none) ///
   eqlabels("Full" "Only grade" "Max 8 diff") /// 
   nomtitles

 esttab using "$descrit/table1_estatdesc_p1.tex", replace ////  
 cells("mean(fmt(%15.2fc))" "sd(par fmt(%15.2fc))") nostar unstack nonumber ///
  compress nonote noobs gap label booktabs f  ///
   collabels(none) ///
   eqlabels("Full" "Only grade" "Max 8 diff") /// 
   nomtitles
   
   
   est clear

estpost tabstat white bf fem ano_nasc tem_nec porc_acert_lp_ porc_acert_mat_, by(group) c(stat) stat(mean  n)
esttab, ///
 cells(" mean(fmt(%13.2fc)) sd(fmt(%13.2fc)) count") nonumber ///
  nomtitle nonote noobs label collabels("Mean" "N")

  
  
//RESTANTE  
est clear
estpost tabstat white bf fem ano_nasc tem_nec porc_acert_lp_ porc_acert_mat_, by(group2) c(stat) stat(mean sd) nototal

esttab, main(mean) aux(sd) nostar nonumber unstack ///
   nonote noobs label ///
   collabels(none) ///
   eqlabels("Focal child younger" "Focal child older") /// 
   nomtitles

 esttab using "$descrit/table1_estatdesc_p2.tex", replace ////  
 cells("mean(fmt(%15.2fc))" "sd(par fmt(%15.2fc))") nostar unstack nonumber ///
  compress nonote noobs gap label booktabs f  ///
   collabels(none) ///
   eqlabels("Focal child younger" "Focal child older") /// 
   nomtitles
   
   
   
   
  
*******************************************
*  TABELA 2: mais completa subamostras    *
******************************************* 
//ObS: quando eu considero o drop==0 eu "desbalanceio o painel" de novo, pq jogo fora as obs que nao possuem nota naquele ano 

est clear
estpost tabstat white bf fem ano_nasc tem_nec porc_acert_lp_ porc_acert_mat_, by(group2) c(stat) stat(mean sd  min max n) nototal

esttab, ///
 cells("sum(fmt(%13.0fc)) mean(fmt(%13.2fc)) sd(fmt(%13.2fc)) min max count") nonumber ///
  nomtitle nonote noobs label collabels("Sum" "Mean" "SD" "Min" "Max" "N")
  

 esttab using "$descrit/table2_estatdesc.tex", replace ////  
 cells("sum(fmt(%13.0fc)) mean(fmt(%13.2fc)) sd(fmt(%13.2fc)) min max count") nonumber ///
  nomtitle nonote noobs label booktabs f ///
  collabels("Sum" "Mean" "SD" "Min" "Max" "N")




  
*******************************************
*  TABELA 3: investigando irmaos a mais   *
******************************************* 

* Identificando cd_alunos que possuem mais de um irmao 
unique cd_aluno year if drop == 0 
  
bysort cd_aluno year: gen mais_ident = _n

  
order cd_aluno cd_irmao year mais_ident
sort cd_aluno cd_irmao year  
  
  
*tabela na mao

//2010
count if mais_ident > 1 & drop == 0 & year == 2010  // -> 2,673
count if drop == 0 & year == 2010  //  -> 10,919
  
//2011
count if mais_ident > 1 & drop == 0 & year == 2011  // 
count if drop == 0 & year == 2011  //  
  

  *ESSA TABELA É MELHOR
tab mais_ident if drop == 0
//eu tenho aproximandamente 17% da amostra de irmaos que repete

  
  
  
  
*******************************************
*  GRAFICO 1: grafico da descontinuidade  *
******************************************* 
  
*Preciso definir D (tratamento de fato -> old for grade)
  
  
gen old_for_grade = 1 if ano_nasc_FC < 2004 & cohort == 2010
replace  old_for_grade = 0 if ano_nasc_FC > 2003 & cohort == 2010

replace old_for_grade = 1 if ano_nasc_FC < 2005 & cohort == 2011
replace old_for_grade = 0 if ano_nasc_FC > 2004 & cohort == 2011

replace old_for_grade = 1 if ano_nasc_FC < 2006 & cohort == 2012
replace old_for_grade = 0 if ano_nasc_FC > 2005 & cohort == 2012

replace old_for_grade = 1 if ano_nasc_FC < 2007 & cohort == 2013
replace old_for_grade = 0 if ano_nasc_FC > 2006 & cohort == 2013

replace old_for_grade = 1 if ano_nasc_FC < 2008 & cohort == 2014
replace old_for_grade = 0 if ano_nasc_FC > 2007 & cohort == 2014

replace old_for_grade = 1 if ano_nasc_FC < 2009 & cohort == 2015
replace old_for_grade = 0 if ano_nasc_FC > 2008 & cohort == 2015

replace old_for_grade = 1 if ano_nasc_FC < 2010 & cohort == 2016
replace old_for_grade = 0 if ano_nasc_FC > 2009 & cohort == 2016

replace old_for_grade = 1 if ano_nasc_FC < 2011 & cohort == 2017
replace old_for_grade = 0 if ano_nasc_FC > 2010 & cohort == 2017

replace old_for_grade = 1 if ano_nasc_FC < 2012 & cohort == 2018
replace old_for_grade = 0 if ano_nasc_FC > 2011 & cohort == 2018
  
replace old_for_grade = 1 if ano_nasc_FC < 2013 & cohort == 2019
replace old_for_grade = 0 if ano_nasc_FC > 2012 & cohort == 2019
  
rdplot old_for_grade running if drop == 0, c(0)
rdplot old_for_grade running if drop == 0 & running<100 & running>-100, c(0)
  
  
  
  
  
  

  
  
  
 *******************************************************************************
 *******************************************************************************
 // Preparando base para estimação 
 
*ajuster finais variaveis
rename serie_ serie
replace serie = "." if serie == "NULL" 
 
 
gen serie_ = . 
replace serie_ = 2 if serie == "2-EF"
replace serie_ = 3 if serie == "3-EF"
replace serie_ = 5 if serie == "5-EF"
replace serie_ = 7 if serie == "7-EF"
replace serie_ = 9 if serie == "9-EF"
replace serie_ = 12 if serie == "3-EM"



keep if drop == 0


*grafico descontinuidade na idade 
 gen dt_school = .
 
forvalue i = 2010(1)2019 {

replace dt_school = mdy(01, 01, `i') if cohort == `i'


}

format dt_school %td

personage date_FC dt_school, gen(age_FC)

//SERA Q EU DROPO MESMO???
drop if age_FC == 2
drop if age_FC > 7 
  
  
********************************************************************************
*                           NORMALIZANDO O CUTOFF 
********************************************************************************
rename codigo_mun_ codigo_mun

gen mar31 = 1 if codigo_mun == 244 | codigo_mun == 298 | codigo_mun == 336 |  codigo_mun == 582 |  codigo_mun == 600 | codigo_mun == 637 | codigo_mun == 645 | codigo_mun == 100 | codigo_mun == 669 | codigo_mun == 672 
 
gen running2 = running  

replace running2 = running + 91 if mar31 == 1
  
/*  
forvalue i = 185(1)275 {

replace running2 = `i' - 366 if  running2 == `i' & mar31 == 1

}  
*/ 
  
  
   
  
 *indicator FC born after cutoff
gen A_cutoff=1 if old_for_grade == 1 & running2>0
replace A_cutoff=0 if old_for_grade == 0 & running2<=0
gen inter = running2*A_cutoff
  

  
*grafico descontinuidade com novo cutoff
rdplot old_for_grade running2 , c(0) graphregion(color(white)) xtitle("Days to/from cutoff") ytitle("Fraction Old-for-Grade") mcolor(blue)
// rdplot (y = old_for_grade x = running2 , x.label ="Days to/from cutoff", y.label ="Fraction Old-for-Grade") -> no R
graph export "$descrit\graph_descont2_norm.png",  replace  

  
  
  
*selecao de band otimo

rdbwselect z_profic_mat running2, fuzzy(old_for_grade)

rdbwselect z_profic_port running2, fuzzy(old_for_grade)



gen sample = 1 if running2 >= -59 & running2 <= 60

  
save "$main\panel_estimation.dta", replace

preserve 
keep if older_FC == 1
save "$main\panel_estimation_oldertoyounger.dta", replace

restore 
  
  
preserve 
keep if older_FC == 0
save "$main\panel_estimation_youngertoolder.dta", replace

restore 
  
  

  


  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  
  
gen temp = .
replace temp = 1 if nome_mun_ == "AMERICANA"
replace temp = 2 if nome_mun_ == "BAURU"
replace temp = 3 if nome_mun_ == "CAMPINAS"
replace temp = 4 if nome_mun_ == "CARAPICUIBA"
replace temp = 5 if nome_mun_ == "DIADEMA"
replace temp = 6 if nome_mun_ == "EMBU DAS ARTES"
replace temp = 7 if nome_mun_ == "EMBU-GUACU"
replace temp = 8 if nome_mun_ == "FRANCO DA ROCHA"
replace temp = 9 if nome_mun_ == "GUARULHOS"
replace temp = 10 if nome_mun_ == "ITABERA"
replace temp = 11 if nome_mun_ == "JUQUITIBA"
replace temp = 12 if nome_mun_ == "MARILIA"
replace temp = 13 if nome_mun_ == "MAUA"
replace temp = 14 if nome_mun_ == "RIBEIRAO PIRES"
replace temp = 15 if nome_mun_ == "RIBEIRAO PRETO"
replace temp = 16 if nome_mun_ == "RIO GRANDE DA SERRA"
replace temp = 17 if nome_mun_ == "SALTO"
replace temp = 18 if nome_mun_ == "SANTA BARBARA D'OESTE"
replace temp = 19 if nome_mun_ == "SANTO ANDRE"
replace temp = 20 if nome_mun_ == "SAO CARLOS"
replace temp = 21 if nome_mun_ == "SAO JOSE DOS CAMPOS"
replace temp = 22 if nome_mun_ == "SAO PAULO"
replace temp = 23 if nome_mun_ == "SOROCABA"
replace temp = 24 if nome_mun_ == "SUZANO"

  
  
preserve
drop if age_FC == 2
drop if age_FC > 7 


forvalue i = 1(1)24 {

rdplot old_for_grade running if temp == `i', c(0)
graph export "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\2. Descritivas\Teste\g`i'.png", as(png) name("Graph")
}



restore 
  
  

  
  
  
  
  
  
  
****** TABELA seguindo o exemplo de fuzzy do Cattaneo

//variavel T: assume valor 1 quem nasceu depois de 30 de junho (=focal child ASSIGNED to be old for grade)
//variavel D: assume valor 1 quem de fato começou no ano seguinte (DE FATO é old for grade)
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
//CRIAR OUTRO DO-FILE PARA ISSO
  
********************************************************************************
********************************************************************************
*               Algumas coisas recomendadas pelo CATTANEO
********************************************************************************
********************************************************************************
keep if drop == 0

//1) Testando se running variable é continua ou discreta 
rddensity running 
  
///rej h0 -> rej a hip de que that the density of the score changes discontinuously at the cutoff point.
  

  // local randomization steps
  
//1) falsification test 

rdwinselect running, wmin(1) nwindows(1) cutoff(0) 
  
//511 obs below cutoff and  1113 obs above 
//results are bad -> tem mto mais obs de um lado do que do outro

//mas isso n vai ter problema se os alunos forem na media iguais, vamos testar:

rdrandinf fem running , seed(50) wl(0) wr(1) // n ta funcionando

  
  
  
//SELECIONAR BAND OTIMO

*Step 1: criar variavel eixo y do grafico da descontinuidade -> old for grade 

//lembrando que é em relaçao a focal child -> acho que o jeito é fazer por cohort 
//a variavel é old for grade -> 

gen old_for_grade = 1 if ano_nasc_FC < 2004 & cohort == 2010
replace  old_for_grade = 0 if ano_nasc_FC > 2003 & cohort == 2010

replace old_for_grade = 1 if ano_nasc_FC < 2005 & cohort == 2011
replace old_for_grade = 0 if ano_nasc_FC > 2004 & cohort == 2011

replace old_for_grade = 1 if ano_nasc_FC < 2006 & cohort == 2012
replace old_for_grade = 0 if ano_nasc_FC > 2005 & cohort == 2012

replace old_for_grade = 1 if ano_nasc_FC < 2007 & cohort == 2013
replace old_for_grade = 0 if ano_nasc_FC > 2006 & cohort == 2013

replace old_for_grade = 1 if ano_nasc_FC < 2008 & cohort == 2014
replace old_for_grade = 0 if ano_nasc_FC > 2007 & cohort == 2014

replace old_for_grade = 1 if ano_nasc_FC < 2009 & cohort == 2015
replace old_for_grade = 0 if ano_nasc_FC > 2008 & cohort == 2015

replace old_for_grade = 1 if ano_nasc_FC < 2010 & cohort == 2016
replace old_for_grade = 0 if ano_nasc_FC > 2009 & cohort == 2016

replace old_for_grade = 1 if ano_nasc_FC < 2011 & cohort == 2017
replace old_for_grade = 0 if ano_nasc_FC > 2010 & cohort == 2017

replace old_for_grade = 1 if ano_nasc_FC < 2012 & cohort == 2018
replace old_for_grade = 0 if ano_nasc_FC > 2011 & cohort == 2018


*Step 2: usar no comando rdbwselect para saber qual vai ser o band otimo -> só para usarmos/comparmos com as descritivas 
//ver qual é a fuzzy variable!!!
rdbwselect old_for_grade running
