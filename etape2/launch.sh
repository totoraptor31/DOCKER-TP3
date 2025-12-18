set -e

echo "[ETAPE 2] Nettoyage des containers existants..."
docker rm -f http script data 2>/dev/null || true

echo "[ETAPE 2] Création du réseau (si absent)..."
docker network inspect tp3net >/dev/null 2>&1 || docker network create tp3net

echo "[ETAPE 2] Lancement MariaDB..."
docker run -d --name data --network tp3net \
  -e MARIADB_RANDOM_ROOT_PASSWORD=1 \
  -e MARIADB_DATABASE=tp3 \
  -e MARIADB_USER=tp3user \
  -e MARIADB_PASSWORD=tp3pass \
  -v "$(pwd)/db-init:/docker-entrypoint-initdb.d:ro" \
  mariadb:latest

echo "[ETAPE 2] Build de l'image PHP avec mysqli..."
docker build -t tp3-php-mysqli:1.0 .

echo "[ETAPE 2] Lancement PHP-FPM..."
docker run -d --name script --network tp3net \
  -v "$(pwd)/src:/app" \
  tp3-php-mysqli:1.0

echo "[ETAPE 2] Lancement NGINX..."
docker run -d --name http --network tp3net -p 8080:80 \
  -v "$(pwd)/src:/app" \
  -v "$(pwd)/config/default.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:latest

echo "[ETAPE 2] Application disponible sur http://localhost:8080/test.php"
