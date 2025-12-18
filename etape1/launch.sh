#!/bin/bash
set -e

# Compat Git Bash (Windows) : empêche la conversion automatique des chemins /app etc.
export MSYS_NO_PATHCONV=1
export MSYS2_ARG_CONV_EXCL="*"

echo "[ETAPE 1] Suppression des containers (éviter conflits noms/ports)..."
docker rm -f http script 2>/dev/null || true

echo "[ETAPE 1] Création du réseau dédié (si absent)..."
docker network inspect tp3net >/dev/null 2>&1 || docker network create tp3net

# Chemin absolu Windows du répertoire de l'étape (pour les volumes)
BASE_DIR="$(cd "$(dirname "$0")" && pwd -W)"
BASE_DIR="${BASE_DIR//\\//}"

echo "[ETAPE 1] Lancement PHP-FPM (script)..."
docker run -d --name script --network tp3net \
  -v "${BASE_DIR}/src:/app" \
  php:8.3-fpm

echo "[ETAPE 1] Lancement NGINX (http)..."
docker run -d --name http --network tp3net -p 8080:80 \
  -v "${BASE_DIR}/src:/app" \
  -v "${BASE_DIR}/config/default.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:latest

echo "[ETAPE 1] OK -> http://localhost:8080"
