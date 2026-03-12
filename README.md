# Valorisation des données issues des protocoles STOC et SHOC

Ce projet produit un rapport automatisé de l'évolution des saisies des données STOC et SHOC recueillies par les agents de l'OFB volontaires. 

## Arborescence du projet
### Fichier "Make.R"
Lancer ce fichier après avoir téléchargé le zip du projet. Lancer les premiers scripts pour créer les fichiers intermédiaires dans processed_data.

### Assets
Couche spatiale représentant les limites départementales de la région Nouvelle-Aquitaine. Ce fichier est utilisé dans le Rmarkdown permettant la génération du rapport, pour la réalisation de cartes.

### Output
Sortie du rapport automatisé régional.

### Processed_data
Fichiers intémédiaires créés à partir des scripts, nécessaires pour le rapport final.

### Raw_data
Les données brutes extraites de Faune France : 
- observations par protocole (STOC et SHOC)
- liste des agents OFB avec leur numéro de carré suivi
- liste des sites concernés par le protocole

### Scripts
- 00_packages : chargement des packages nécessaires
- 01_importation_data_SHOC : chargement des données brutes d'observations du protocole SHOC
- 01_importation_data_STOC : chargement des données brutes d'observations du protocole STOC
- 02_jointure_carre_agent : jointure des sites avec la liste d'agents pour identifier le carré suivi pour chaque observation

### Template
Script Rmarkdown pour la production du rapport automatisé et document Word à utiliser comme modèle (caractéeristiques de la police, masque de la charte graphique,...)
