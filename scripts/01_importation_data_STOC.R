#%%%%%%%%%%%%%%%%%%%% Importation données STOC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

###---------------------------------------------------------#
cli::cli_h1("Lire le fichier format .txt") 

data_stoc <- read.table("raw_data/stoc_11032026.txt", 
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
  mutate(Date = as.Date(Date, format = "%d.%m.%Y")) %>% #Formater la date en format Date
  filter(Date >= as.Date(paste0(year(Date), "-03-01")) &
           Date <= as.Date(paste0(year(Date), "-06-15"))) %>% #Ne garder que les données comprises entre le 1er mars et le 15 juin
  select(Id = UUID,
         Maille,
         Nom_espece = Nom.espèce,
         Nom_scientifique = Nom.scientifique,
         Nombre,
         Famille,
         Date,
         Annee = Année,
         Type_localisation = Type.de.localisation,
         Insee_com = Code.INSEE,
         Commune,
         Departement = Département,
         Protocole,
         Protection = Protégée,
         Contributeur = Personne.morale,
         X_lambert = X.Lambert93..m.,
         Y_lambert = Y.Lambert93..m.) #Sélection des colonnes à garder

###---------------------------------------------------------#
cli::cli_h1("Convertir en objet spatial") 

data_stoc <- st_as_sf(data_stoc, coords = c("X_lambert", "Y_lambert"), crs = 2154)


###---------------------------------------------------------#
cli::cli_h1("Vérifier les doublons")

data_stoc <- data_stoc[!duplicated(data_stoc$Id), ]


