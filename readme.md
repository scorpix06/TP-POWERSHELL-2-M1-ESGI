
# Outil de provisioning cloud avec une GUI 


Ce projet est un projet scolaire, les prérequis du TP sont :
- Utilisation de Powershell
- Utilisation du WMIC
- Utilisatation d'une WebRequest  (API)
- Suivi des modification / journalisation
- Utilisation d'un fichier de configuration
- Interface graphique avec des variables a renseigner
- Sécurité du contenu ou du script 
- Utilisation du développement modulaire
- Integration de fonctionnalité comme la notification, alerte ou autre.

# Objectif

Ce script a pour but de provisionner de maniere simple et via une interface graphique un serveur avec le cloud provider Linode. Le suivi du provisionning et les informations sont envoyés sur telegram.

Les parametres sont importés depuis le fichier settings.yml pour pouvoir facilement  ajouter / suppprimer des OS, le nom et  mot  de  passe  de la  VM par défaut.

Toutes les actions sont journalisés (logger) dans le fichier log.txt

# Prerequis 

Nous avons choisis de faire le fichier de configuration en YAML car c'est un format beaucoup plus intuitif que json ou xml. Cependant, YAML n'est pas geré nativement par Powershell. Il faut installer un module via la PSGallery
 
```powershell
  Install-Module powershell-yaml
```


# Auteurs
- Thibaut 
- Alban 


