##%######################################################%##
#                                                          #
####      Etude sur les protocoles STOC/SHOC               ####
###       Direction régionale Nouvelle-Aquitaine           ###
#                                                          #
##%------------------------------------------------------%##
##%------------------------------------------------------%##  
####                   C. FLORIN                           ####
###         Chargée de mission analyse de données          ###
##                 Service Connaissance                    ##
##%------------------------------------------------------%##
##                                                         ##
#                                                          #
##%######################################################%##

##----------------------------------------------------------------------------##
## 1. Lancement des scripts

source("scripts/00_packages.R")
source("scripts/01_importation_data_SHOC.R")
source("scripts/01_importation_data_STOC.R")
source("scripts/02_jointure_carre_agent.R")


##----------------------------------------------------------------------------##
## 2. Lancement du rapport Word

rmarkdown::render(input = "template/Rapport_automatise.Rmd",
                  output_file = paste0("../output/Valorisation_Regionale_STOC_SHOC.docx"))
