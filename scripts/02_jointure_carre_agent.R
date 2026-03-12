#%%%%%%%%%%%%%%%%%%%% Joiture des mailles et agents %%%%%%%%%%%%%%%%%%%%%%%%%%%%

###---------------------------------------------------------#
cli::cli_h1("Lire les fichiers") 

listing_shoc <- read_delim("raw_data/agents_ofb_shoc.txt",
                           delim = "\t",
                           trim_ws = TRUE)

listing_stoc <- read_delim("raw_data/agents_ofb_stoc.txt",
                           delim = "\t",
                           trim_ws = TRUE,
                           col_types = cols(.default = "c")
)

sites_stoc <- read_delim("raw_data/carre_stoc.txt",
                         delim = "\t",
                         trim_ws = TRUE,
                         skip = 1,
                         col_types = cols(.default = "c"))

sites_shoc <- read_delim("raw_data/carre_shoc.txt",
                           delim = "\t",
                           trim_ws = TRUE,
                           skip = 1,
                           col_types = cols(.default = "c"))


maille_10 <- st_read("raw_data/mailles_10km.shp") #Récupérer la grille de mailles nationale 10x10km


###---------------------------------------------------------#
cli::cli_h1("Préparer les fichiers") 

maille_10 <- maille_10 %>%
  mutate(Maille = substr(cd_sig, 8,15)) %>% #Récupérer les identifiants de maille
  select(Maille) %>%
  st_transform(geom, crs = 2154)


listing_shoc <- listing_shoc %>%
  mutate(Carre = substr(gsub("[^0-9]", "", `Nom de référence national`), 1,6),
         Departement = substr(Carre, 1,2),
         Agent = gsub("\\s*\\([^)]*\\)", "",`Nom de l'utilisateur`),
         Protocole = "SHOC",
         Source = ifelse(str_detect(`Nom de l'utilisateur`, "@ofb"), "OFB", "Hors OFB")) %>%
  filter(Departement %in% c("33","40","64","47","24","86","17","79","16","19","87","23"),
         !Source == "Hors OFB") %>%
  distinct(Carre, .keep_all = TRUE) %>%
  select(Agent,
         Carre,
         Departement,
         Protocole,
         Source)


listing_stoc <- listing_stoc %>%
  mutate(Carre = substr(gsub("[^0-9]", "", `Nom de référence national`), 1,6),
         Departement = substr(Carre, 1,2),
         Agent = gsub("\\s*\\([^)]*\\)", "",`Nom de l'utilisateur`),
         Protocole = "STOC",
         Source = ifelse(str_detect(`Nom de l'utilisateur`, "@ofb"), "OFB", "Hors OFB")) %>%
  filter(Departement %in% c("33","40","64","47","24","86","17","79","16","19","87","23"),
         !Source == "Hors OFB") %>%
  distinct(Carre, .keep_all = TRUE) %>%
  select(Agent,
         Carre,
         Departement,
         Protocole,
         Source)


sites_stoc <- sites_stoc %>%
  mutate(Protocole = "STOC") %>%
  select(Carre = `Numéro du carré`,
         Protocole,
         Insee_com = INSEE,
         Commune,
         X_Lambert = `Lambert 93 E [m]`,
         Y_Lambert = `Lambert 93 N [m]`)

sites_shoc <- sites_shoc %>%
  mutate(Protocole = "SHOC") %>%
  select(Carre = `Numéro du carré`,
         Protocole,
         Insee_com = INSEE,
         Commune,
         X_Lambert = `Lambert 93 E [m]`,
         Y_Lambert = `Lambert 93 N [m]`)


###---------------------------------------------------------#
cli::cli_h1("Jointure carrés et agent") 

sites_agents_stoc <- sites_stoc %>%
  st_as_sf(coords = c("X_Lambert", "Y_Lambert"), crs = 2154) %>%
  left_join(listing_stoc, by = "Carre") %>%
  filter(Source == "OFB")

sites_agents_shoc <- sites_shoc %>%
  st_as_sf(coords = c("X_Lambert", "Y_Lambert"), crs = 2154) %>%
  left_join(listing_shoc, by = "Carre") %>%
  filter(Source == "OFB")

###---------------------------------------------------------#
cli::cli_h1("Jointure avec les bases de données")
#Joindre avec la grille nationale pour faire le lien avec les observations

sites_agents_mailles_stoc <- sites_agents_stoc %>%
  st_join(maille_10, join = st_within) %>%
  st_set_geometry(NULL)

sites_agents_mailles_shoc <- sites_agents_shoc %>%
  st_join(maille_10, join = st_within) %>%
  st_set_geometry(NULL)


#Joindre avec les observations

data_shoc_agent <- data_shoc %>%
  mutate(Insee_com = as.character(Insee_com),
         Protocole = "SHOC") %>%
  left_join(sites_agents_mailles_shoc %>%
              select(Carre,
                     Agent,
                     Source,
                     Maille,
                     Insee_com,
                     Commune),
            by = c("Maille","Insee_com","Commune")) %>%
  filter(!duplicated(Id))


data_stoc_agent <- data_stoc %>%
  mutate(Insee_com = as.character(Insee_com),
         Protocole = "STOC") %>%
  left_join(sites_agents_mailles_stoc %>%
              select(Carre,
                     Agent,
                     Source,
                     Maille,
                     Insee_com,
                     Commune),
            by = c("Maille","Insee_com","Commune")) %>%
  filter(!duplicated(Id))


###---------------------------------------------------------#
cli::cli_h2("Sauvegarder les fichier") 

st_write(data_shoc_agent, "processed_data/data_shoc.gpkg", 
         append = FALSE,
         driver = "GPKG")

st_write(data_stoc_agent, "processed_data/data_stoc.gpkg", 
         append = FALSE,
         driver = "GPKG")

#Format geopackage pour utilisation directement dans Qgis si besoin

