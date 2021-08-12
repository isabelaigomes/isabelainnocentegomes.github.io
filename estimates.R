################################################################################

#          ESTIMACAO DISSERTACAO -> KOLESAR AND ROTHE (2018)                   #

################################################################################

#Isabela Innocente Gomes

setwd("C:\\Users\\isai\\Documents\\1. EESP\\0. Dissertação!!\\1. Projeto\\Dados SP")


#Pacotes necessarios
install.packages("devtools")
install.packages("miceadds")
install.packages("reprex")
devtools::install_github("kolesarm/RDHonest")

############################
# 1. data older to younger #
###########################

library(haven)
panel_estimation_oldertoyounger <- read_dta("~/1. EESP/0. Dissertação!!/1. Projeto/Dados SP/1.main data/panel_estimation_oldertoyounger.dta")
View(panel_estimation_oldertoyounger)

#base completa e de acordo com o BF
dataOY = as.data.frame(`panel_estimation_oldertoyounger`)
dataOYbf <- dataOY[which(dataOY$bf == 1), ]
dataOYnbf <- dataOY[which(dataOY$bf == 0), ]

#vetores
selvarsOYm <- c("z_profic_mat", "running2")
selvarsOYp <- c("z_profic_port", "running2")


dataOYt_m <- dataOY[selvarsOYm]
dataOYt_p <- dataOY[selvarsOYp]

dataOYbft_m <- dataOYbf[selvarsOYm]
dataOYbft_p <- dataOYbf[selvarsOYp]

dataOYnbft_m <- dataOYnbf[selvarsOYm]
dataOYnbft_p <- dataOYnbf[selvarsOYp]


############################
# 2. younger to older     #
###########################
library(haven)
panel_estimation_youngertoolder <- read_dta("~/1. EESP/0. Dissertação!!/1. Projeto/Dados SP/1.main data/panel_estimation_youngertoolder.dta")
View(panel_estimation_youngertoolder)


#base completa e de acordo com o BF
dataYO = as.data.frame(`panel_estimation_youngertoolder`)
dataYObf <- dataYO[which(dataYO$bf == 1), ]
dataYOnbf <- dataYO[which(dataYO$bf == 0), ]

#vetores
selvarsYOm <- c("z_profic_mat", "running2")
selvarsYOp <- c("z_profic_port", "running2")


dataYOt_m <- dataYO[selvarsYOm]
dataYOt_p <- dataYO[selvarsYOp]

dataYObft_m <- dataYObf[selvarsYOm]
dataYObft_p <- dataYObf[selvarsYOp]

dataYOnbft_m <- dataYOnbf[selvarsYOm]
dataYOnbft_p <- dataYOnbf[selvarsYOp]
