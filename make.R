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
## 1. Création des dossiers manquants

dir.create("assets") #ajouter une couche spatiale contenant les limites départementales de la région
dir.create("processed_data")
dir.create("raw_data") #ajouter les extractions de données STOC et SHOC, format OFB+
dir.create("output")

##----------------------------------------------------------------------------##
## 2. Lancement des scripts

source("scripts/00_packages.R")
source("scripts/01_importation_data_SHOC.R")
source("scripts/01_importation_data_STOC.R")


##----------------------------------------------------------------------------##
## 3. Lancement du rapport régional Word

rmarkdown::render(input = "template/Rapport_automatise.Rmd",
                  output_file = paste0("../output/Valorisation_Regionale_STOC_SHOC.docx"))
