#%%%%%%%%%%%%%%%%%%%% Importation données SHOC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

###---------------------------------------------------------#
cli::cli_h1("Lire le fichier format .txt") 

# Mettre votre extraction de données SHOC dans le dossier "raw_data".
# Modifier le nom du fichier dans la ligne ci-dessous : 

data_shoc <- read.table("raw_data/shoc_ofbplus.txt", 
                        header = TRUE, 
                        sep = "\t", 
                        quote = "",
                        dec = ",",
                        stringsAsFactors = FALSE,
                        skip = 1) #Export selon le format STOC+ OFB

###---------------------------------------------------------#
cli::cli_h1("Nettoyer le fichier") 

SHOC_verif <- data_shoc %>%  #Vérifier le statut de validation des données
  group_by(Vérification) %>%
  summarise(total = n())


data_shoc <- data_shoc %>%
  filter(!Vérification %in% c("Refusée", "Incomplet", "Probablement incorrecte")) %>% #Supression des données non valides
  mutate(Date = as.Date(Date, format = "%d.%m.%Y"),
         Agent = paste0(Prénom," ", Nom)) %>% #Formater la date en format Date
  filter(month(Date) %in% c(1,12), #Ne garder que les données de janvier et décembre
         Date > "2022-01-31") %>% #Ne garder que les données à partir de l'hiver 2022 (donc décembre 2022)
  select(Id = UUID,
         Nom_espece = Nom.espèce,
         Nom_scientifique = Nom.scientifique,
         Nombre,
         Famille,
         Date,
         Annee = Année,
         Insee_com = Code.INSEE,
         Commune,
         Departement = Département,
         Protocole,
         Agent,
         Carre = Nom.de.référence.national,
         Contributeur = Abréviation.personne.morale,
         Passage = Numéro.du.passage,
         Milieu_1 = Habitat.principal.1,
         Habitat_1 = Habitat.principal.2,
         Milieu_2 = Habitat.secondaire.1,
         Habitat_2 = Habitat.secondaire.2,
         X_lambert = X.Lambert93..m.,
         Y_lambert = Y.Lambert93..m.) #Sélection des colonnes à garder

###---------------------------------------------------------#
cli::cli_h1("Convertir en objet spatial") 

data_shoc <- st_as_sf(data_shoc, coords = c("X_lambert", "Y_lambert"), crs = 2154)


###---------------------------------------------------------#
cli::cli_h1("Vérifier les doublons")

data_shoc <- data_shoc[!duplicated(data_shoc$Id), ]


###---------------------------------------------------------#
cli::cli_h1("Sauvegarder le fichier")

st_write(data_shoc, "processed_data/data_shoc.gpkg", 
         append = FALSE,
         driver = "GPKG")
