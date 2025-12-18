# DOCKER-TP3

## Les scripts launch.ps1 fournissent un équivalent PowerShell des scripts launch.sh afin de permettre l’exécution du projet sous Windows, tout en conservant une compatibilité Linux complète.

## Étape 1 – NGINX + PHP-FPM
Cette étape met en place une architecture web minimale composée de deux conteneurs Docker : NGINX pour la partie HTTP et PHP-FPM pour l’exécution des scripts PHP. Le lancement est automatisé via le script `launch.sh`, rendant l’application accessible sur `http://localhost:8080`.

- Étape 1 :
  Linux / macOS / Git Bash : cd etape1 && ./launch.sh
  Windows (PowerShell)     : cd etape1 && .\launch.ps1

## Étape 2 – Ajout de MariaDB
Cette étape ajoute un troisième conteneur MariaDB afin d’introduire une persistance des données et des opérations CRUD via PHP. Le script `launch.sh` permet de déployer automatiquement la base, le service PHP avec l’extension `mysqli`, et NGINX, avec un compteur accessible sur `/test.php`.

- Étape 2 :
  Linux / macOS / Git Bash : cd etape2 && ./launch.sh
  Windows (PowerShell)     : cd etape2 && .\launch.ps1

## Étape 3 – Orchestration avec Docker Compose
L’architecture complète est migrée vers Docker Compose afin de centraliser la configuration et simplifier le déploiement. Une seule commande `docker compose up -d --build` suffit à lancer l’ensemble des services et à rendre l’application opérationnelle.

- Commande pour lancer l'étape 3: 

cd etape3
docker compose up -d --build

