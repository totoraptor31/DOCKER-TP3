#!/bin/bash
set -e

export MSYS_NO_PATHCONV=1
export MSYS2_ARG_CONV_EXCL="*"

echo "[ETAPE 2] Suppression des containers (éviter conflits noms/ports)..."
docker rm -f http script data 2>/dev/null || true

echo "[ETAPE 2] Création du réseau dédié (si absent)..."
docker network inspect tp3net >/dev/null 2>&1 || docker network create tp3net

BASE_DIR="$(cd "$(dirname "$0")" && pwd -W)"
BASE_DIR="${BASE_DIR//\\//}"

echo "[ETAPE 2] Lancement MariaDB (data) + init SQL..."
docker run -d --name data --network tp3net \
  -e MARIADB_RANDOM_ROOT_PASSWORD=1 \
  -e MARIADB_DATABASE=tp3 \
  -e MARIADB_USER=tp3user \
  -e MARIADB_PASSWORD=tp3pass \
  -v "${BASE_DIR}/db-init:/docker-entrypoint-initdb.d:ro" \
  mariadb:latest

echo "[ETAPE 2] Build PHP (mysqli)..."
docker build -t tp3-php-mysqli:1.0 "${BASE_DIR}"

echo "[ETAPE 2] Lancement PHP-FPM (script)..."
docker run -d --name script --network tp3net \
  -v "${BASE_DIR}/src:/app" \
  tp3-php-mysqli:1.0

echo "[ETAPE 2] Lancement NGINX (http)..."
docker run -d --name http --network tp3net -p 8080:80 \
  -v "${BASE_DIR}/src:/app" \
  -v "${BASE_DIR}/config/default.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:latest

echo "[ETAPE 2] OK -> http://localhost:8080/test.php"
