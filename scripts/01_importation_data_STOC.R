#%%%%%%%%%%%%%%%%%%%% Importation données STOC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

###---------------------------------------------------------#
cli::cli_h1("Lire le fichier format .txt") 

# Mettre votre extraction de données SHOC dans le dossier "raw_data".
# Modifier le nom du fichier dans la ligne ci-dessous : 

data_stoc <- read.table("raw_data/stoc_ofbplus.txt", 
                        header = TRUE, 
                        sep = "\t", 
                        quote = "",
                        dec = ",",
                        stringsAsFactors = FALSE,
                        skip = 1) #Export selon le format SINP+


###---------------------------------------------------------#
cli::cli_h1("Nettoyer le fichier") 

STOC_verif <- data_stoc %>% #Vérifier le statut de validation des données
  group_by(Vérification) %>%
  summarise(total = n())


data_stoc <- data_stoc %>%
  filter(Année < 2026,
         !Vérification %in% c("Refusée", "Incomplet", "Probablement incorrecte")) %>% #Supression des données non valides
  mutate(Date = as.Date(Date, format = "%d.%m.%Y"), #Formater la date en format Date
         Agent = paste0(Prénom," ", Nom)) %>% 
  filter(Date >= as.Date(paste0(year(Date), "-03-01")) &
           Date <= as.Date(paste0(year(Date), "-06-15"))) %>% #Ne garder que les données comprises entre le 1er mars et le 15 juin
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

data_stoc <- st_as_sf(data_stoc, coords = c("X_lambert", "Y_lambert"), crs = 2154)


###---------------------------------------------------------#
cli::cli_h1("Vérifier les doublons")

data_stoc <- data_stoc[!duplicated(data_stoc$Id), ]



###---------------------------------------------------------#
cli::cli_h1("Sauvegarder le fichier")

st_write(data_stoc, "processed_data/data_stoc.gpkg", 
         append = FALSE,
         driver = "GPKG")
