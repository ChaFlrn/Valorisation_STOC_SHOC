#%%%%%%%%%%%%%%%%%%%%%%%% Chargement des parckages %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (!require(pacman)) install.packages("pacman")

pacman::p_load(sf,
               dplyr,
               tidyverse,
               lubridate,
               ggplot2,
               readr,
               patchwork,
               flextable,
               pheatmap,
               gt,
               gridExtra)
