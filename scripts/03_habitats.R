
carhab_16 <- st_read("C:/Users/charlotte.florin/Desktop/Ressources/QGIS/CARHAB/CarHab_16_Charente/CarHab_16_Charente_Habitats_CarHab.gpkg")
carhab_17 <- st_read("C:/Users/charlotte.florin/Desktop/Ressources/QGIS/CARHAB/CarHab_17_Charente-Maritime/CarHab_17_Charente-Maritime_Habitats_CarHab.gpkg")
carhab_23 <- st_read("C:/Users/charlotte.florin/Desktop/Ressources/QGIS/CARHAB/CarHab_23_Creuse/CarHab_23_Creuse_Habitats_CarHab.gpkg")
carhab_24 <- st_read("C:/Users/charlotte.florin/Desktop/Ressources/QGIS/CARHAB/CarHab_24_Dordogne_2/CarHab_24_Dordogne_Habitats_CarHab.gpkg")
carhab_33 <- st_read("C:/Users/charlotte.florin/Desktop/Ressources/QGIS/CARHAB/CarHab_33_Gironde_2/CarHab_33_Gironde_Habitats_CarHab.gpkg")
carhab_40 <- st_read("C:/Users/charlotte.florin/Desktop/Ressources/QGIS/CARHAB/CarHab_40_Landes/CarHab_40_Landes_Habitats_CarHab.gpkg")
carhab_47 <- st_read("C:/Users/charlotte.florin/Desktop/Ressources/QGIS/CARHAB/CarHab_47_Lot-et-Garonne/CarHab_47_Lot-et-Garonne_Habitats_CarHab.gpkg")
carhab_64 <- st_read("C:/Users/charlotte.florin/Desktop/Ressources/QGIS/CARHAB/CarHab_64_Pyrenees-Atlantiques_2/CarHab_64_Pyrenees-Atlantiques_Habitats_CarHab.gpkg")
carhab_87 <- st_read("C:/Users/charlotte.florin/Desktop/Ressources/QGIS/CARHAB/CarHab_87_Haute-Vienne/CarHab_87_Haute-Vienne_Habitats_CarHab.gpkg")

#Départements 19,79 et 86 non disponibles


carhab_na <- rbind(carhab_16,
                   carhab_17,
                   carhab_23,
                   carhab_24,
                   carhab_33,
                   carhab_40,
                   carhab_47,
                   carhab_64,
                   carhab_87)

save(carhab_na, file = "processed_data/carhab_na.RData")

data_stoc_carhab <- st_join(data_stoc,
                            carhab_na[, "occupation"],
                            join = st_within)

data_shoc_carhab <- st_join(data_shoc,
                            carhab_na[, "occupation"],
                            join = st_within)
