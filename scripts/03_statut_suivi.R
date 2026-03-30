#%%%%%%%%%%%%%%%%%%%% Statut de suivi des carrés %%%%%%%%%%%%%%%%%%%%%%%%%%%%

###---------------------------------------------------------#
cli::cli_h1("STOC") 

passage_stoc_ofb <- data_stoc %>%
  mutate(
    Printemps = paste0("Printemps_", Annee),
    passage_mars  = Date >= as.Date(paste0(Annee, "-03-01")) &
      Date <= as.Date(paste0(Annee, "-03-31")),
    passage_avril = Date >= as.Date(paste0(Annee, "-04-01")) &
      Date <= as.Date(paste0(Annee, "-05-08")),
    passage_mai   = Date >  as.Date(paste0(Annee, "-05-08")) &
      Date <= as.Date(paste0(Annee, "-06-15"))
  ) %>%
  group_by(Carre, Printemps, Annee, Agent) %>%
  summarise(
    nb_passages_mars  = n_distinct(Date[passage_mars]),
    nb_passages_avril = n_distinct(Date[passage_avril]),
    nb_passages_mai   = n_distinct(Date[passage_mai]),
    .groups = "drop"
  ) %>%
  group_by(Carre) %>%
  mutate(
    derniere_an_passage = ifelse(
      any(nb_passages_mars + nb_passages_avril + nb_passages_mai > 0),
      max(Annee[nb_passages_mars + nb_passages_avril + nb_passages_mai > 0], na.rm = TRUE),
      NA_integer_
    )
  ) %>%
  ungroup() %>%
  mutate(
    classe_passage = case_when(
      (params$annee - derniere_an_passage) >= 2 ~ "Abandonné",
      nb_passages_mars > 0 & nb_passages_avril > 0 & nb_passages_mai > 0 ~ "Bien suivi",
      Annee < 2022 & nb_passages_avril > 0 & nb_passages_mai > 0 ~ "Bien suivi",
      TRUE ~ "Mal suivi"
    )
  )

statut_carre_stoc_ofb <- passage_stoc_ofb %>%
  mutate(passages_total = (nb_passages_mars + nb_passages_avril + nb_passages_mai)) %>%
  group_by(Carre, Agent) %>%
  summarise(
    n_printemps_total = n(),
    n_passages_total = sum(passages_total),
    last_printemps = ifelse(
      any(passages_total > 0),
      max(Annee[passages_total > 0]),
      NA_real_),
    printemps = max(Annee),
    bien_suivi = sum(classe_passage == "Bien suivi"),
    mal_suivi = sum(classe_passage == "Mal suivi"),
    .groups = "drop") %>%
  mutate(statut = case_when(
    is.na(last_printemps) ~ "Jamais suivi",
    (max(printemps) - last_printemps) >= 2 ~ "Abandonné",
    mal_suivi == 0 ~ "Bien suivi",
    bien_suivi == 0 ~ "Mal suivi",
    bien_suivi > mal_suivi ~ "Plutôt bien suivi",
    bien_suivi < mal_suivi ~ "Plutôt mal suivi",
    TRUE ~ "Neutre"))

st_write(statut_carre_stoc_ofb, "processed_data/statut_stoc.gpkg", 
         append = FALSE,
         driver = "GPKG")


###---------------------------------------------------------#
cli::cli_h1("SHOC") 

passage_shoc_ofb <- data_shoc %>%
  mutate(mois = month(Date)) %>%
  filter(mois %in% c(12,1)) %>%
  mutate(Hiver = if_else(mois == 1, Annee - 1, Annee),
         mois_hiver = case_when(
           mois == 12 ~ "décembre",
           mois == 1 ~ "janvier")) %>%
  group_by(Carre, Hiver, Agent) %>%
  summarise(nb_passages_dec = n_distinct(Date[mois_hiver == "décembre"]),
            nb_passages_janv = n_distinct(Date[mois_hiver == "janvier"]), .groups = "drop") %>%
  group_by(Carre) %>%
  mutate(
    derniere_an_passage = ifelse(
      any(nb_passages_dec + nb_passages_janv > 0),
      max(Hiver[nb_passages_dec + nb_passages_janv > 0], na.rm = TRUE),
      NA_integer_
    )
  ) %>%
  ungroup() %>%
  mutate(
    classe_passage = case_when(
      is.na(derniere_an_passage) ~ "Jamais suivi",
      (params$annee - derniere_an_passage) >= 2 ~ "Abandonné",
      nb_passages_dec > 0 & nb_passages_janv > 0 ~ "Bien suivi",
      TRUE ~ "Mal suivi"))


statut_carre_shoc_ofb <- passage_shoc_ofb %>%
  mutate(passages_total = (nb_passages_dec + nb_passages_janv)) %>%
  group_by(Carre, Agent) %>%
  summarise(
    n_hiver_total = n(),
    n_passages_total = sum(passages_total),
    last_hiver = ifelse(
      any(passages_total > 0),
      max(Hiver[passages_total > 0]),
      NA_real_),
    hiver = max(Hiver),
    bien_suivi = sum(classe_passage == "Bien suivi"),
    mal_suivi = sum(classe_passage == "Mal suivi"),
    .groups = "drop") %>%
  mutate(statut = case_when(
    is.na(last_hiver) ~ "Jamais suivi",
    (max(hiver) - last_hiver) > 1 ~ "Abandonné",
    mal_suivi == 0 ~ "Bien suivi",
    bien_suivi == 0 ~ "Mal suivi",
    bien_suivi > mal_suivi ~ "Plutôt bien suivi",
    bien_suivi < mal_suivi ~ "Plutôt mal suivi",
    TRUE ~ "Neutre"))

st_write(statut_carre_shoc_ofb, "processed_data/statut_shoc.gpkg", 
         append = FALSE,
         driver = "GPKG")
