********************************************************************************
********************************************************************************
*          ESTIMAÇÕES INICIAIS DISSERTACAO: adaptando from Ozek                *
********************************************************************************
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
	gl results "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\2. Descritivas\Preliminary Results"
}
*

cd  "C:\Users\isaig\Documents\1. EESP\0. Dissertação!!\1. Projeto\Dados SP\2. Descritivas\Preliminary Results"


********************************************************************************
*       1. Vamos fazer LC estimates e cluster by RV só para começar            *
********************************************************************************
use "$main\panel_estimation.dta"

************************************************************
//A.    OLDER (FC) to YOUNGER (sibling) -> older_FC == 1
************************************************************

//outreg2 using "results\t3a.xls", nocons bdec(3) keep(trt) replace



local r1 A_cutoff running2 inter if older_FC == 1 & sample==1, cluster(running2)
local r2 A_cutoff running2 inter i.ano_nasc i.mes_nasc fem white i.serie_ if older_FC == 1 & sample==1, cluster(running2)
local r3 A_cutoff running2 inter i.ano_nasc i.mes_nasc fem white i.serie_ i.cohort fem_FC age_dif_days if older_FC == 1 & sample==1, cluster(running2)

local r4 A_cutoff running2 inter if older_FC == 1 & sample==1 & bf==0, cluster(running2)
local r5 A_cutoff running2 inter i.ano_nasc i.mes_nasc fem white i.serie_ if older_FC == 1 & sample==1 & bf==0, cluster(running2)
local r6 A_cutoff running2 inter i.ano_nasc i.mes_nasc fem white i.serie_ i.cohort fem_FC age_dif_days if older_FC == 1 & sample==1 & bf==0, cluster(running2)

local r7 A_cutoff running2 inter if older_FC == 1 & sample==1 & bf==1, cluster(running2)
local r8 A_cutoff running2 inter i.ano_nasc i.mes_nasc fem white i.serie_ if older_FC == 1 & sample==1 & bf==1, cluster(running2)
local r9 A_cutoff running2 inter i.ano_nasc i.mes_nasc fem white i.serie_ i.cohort fem_FC age_dif_days if older_FC == 1 & sample==1 & bf==1, cluster(running2)

local regres r1 r2 r3 r4 r5 r6 r7 r8 r9

*math 
foreach p of local regres {

reg z_profic_mat ``p''
outreg2 using table_old_yo_m, p bdec(4) title("") append tex

}

*port
foreach p of local regres {

reg z_profic_port ``p''
outreg2 using table_old_yo_p, p bdec(4) title("") append tex

}
















************************************************************
//B.    YOUNGER (FC) to OLDER(sibling) -> older_FC == 0
************************************************************



local r1 A_cutoff running2 inter if older_FC == 0 & sample==1, cluster(running2)
local r2 A_cutoff running2 inter i.ano_nasc i.mes_nasc fem white i.serie_ if older_FC == 0 & sample==1, cluster(running2)
local r3 A_cutoff running2 inter i.ano_nasc i.mes_nasc fem white i.serie_ i.cohort fem_FC age_dif_days if older_FC == 0 & sample==1, cluster(running2)

local r4 A_cutoff running2 inter if older_FC == 0 & sample==1 & bf==0, cluster(running2)
local r5 A_cutoff running2 inter i.ano_nasc mes_nasc fem white i.serie_ if older_FC == 0 & sample==1 & bf==0, cluster(running2)
local r6 A_cutoff running2 inter i.ano_nasc mes_nasc fem white i.serie_ i.cohort fem_FC age_dif_days if older_FC == 0 & sample==1 & bf==0, cluster(running2)

local r7 A_cutoff running2 inter if older_FC == 0 & sample==1 & bf==1, cluster(running2)
local r8 A_cutoff running2 inter i.ano_nasc i.mes_nasc fem white i.serie_ if older_FC == 0 & sample==1 & bf==1, cluster(running)
local r9 A_cutoff running2 inter i.ano_nasc i.mes_nasc fem white i.serie_ i.cohort fem_FC age_dif_days if older_FC == 0 & sample==1 & bf==1, cluster(running2)

local regres r1 r2 r3 r4 r5 r6 r7 r8 r9

*math 
foreach p of local regres {

reg z_profic_mat ``p''
outreg2 using table_yo_to_old_m, p bdec(4) title("") append tex

}

*port
foreach p of local regres {

reg z_profic_port ``p''
outreg2 using table_yo_to_old_p, p bdec(4) title("") append tex

}







