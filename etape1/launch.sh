set -e

echo "[ETAPE 1] Nettoyage des containers existants..."
docker rm -f http script 2>/dev/null || true

echo "[ETAPE 1] Création du réseau (si absent)..."
docker network inspect tp3net >/dev/null 2>&1 || docker network create tp3net

echo "[ETAPE 1] Lancement PHP-FPM..."
docker run -d --name script --network tp3net \
  -v "$(pwd)/src:/app" \
  php:8.3-fpm

echo "[ETAPE 1] Lancement NGINX..."
docker run -d --name http --network tp3net -p 8080:80 \
  -v "$(pwd)/src:/app" \
  -v "$(pwd)/config/default.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:latest

echo "[ETAPE 1] Application disponible sur http://localhost:8080"
