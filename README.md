# Valorisation des données issues des protocoles STOC et SHOC

Ce projet produit un rapport automatisé de l'évolution des saisies des données STOC et SHOC recueillies par les agents de l'OFB volontaires. 

## Arborescence du projet
### Fichier "Make.R"
Lancer ce fichier après avoir téléchargé le zip du projet.
  1. Création des dossiers manquants : lancer ces premières lignes de codes pour créer les dossiers manquants

Faire les changements nécessaires dans les scripts 01_importation (nom du fichier de données à modifier)

  2. Lancement des scripts : lancer ces lignes de codes pour importer et préparer vos données
  
  3. Lancement du rapport word : lancer ces lignes pour créer le document de bilan sous format word


### Assets
Couche spatiale représentant les limites départementales de la région Nouvelle-Aquitaine. Ce fichier est utilisé dans le Rmarkdown permettant la génération du rapport, pour la réalisation de cartes.

### Output
Sortie du rapport automatisé régional.

### Processed_data
Fichiers intémédiaires créés à partir des scripts, nécessaires pour le rapport final.

### Raw_data
Les données brutes extraites de Faune France, un fichier par protocole, exporté au format STOC+OFB et en tabulation (.txt).

### Scripts
- 00_packages : chargement des packages nécessaires
- 01_importation_data_SHOC : chargement des données brutes d'observations du protocole SHOC
- 01_importation_data_STOC : chargement des données brutes d'observations du protocole STOC
- 02_statut_suivi : création de couches spatiales contenant les informations de suivi des carrés d'observation (pour utilisation dans Qgis)

### Template
Script Rmarkdown pour la production du rapport automatisé et document Word à utiliser comme modèle (caractéristiques de la police, masque de la charte graphique,...).
