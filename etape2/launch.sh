echo "[ETAPE 2] Nettoyage des containers existants..."
docker stop http script data 2>/dev/null
docker rm http script data 2>/dev/null

echo "[ETAPE 2] Création du réseau Docker..."
docker network inspect tp3net >/dev/null 2>&1 || docker network create tp3net

echo "[ETAPE 2] Lancement de MariaDB (data)..."
docker run -d --name data --network tp3net \
  -e MARIADB_RANDOM_ROOT_PASSWORD=1 \
  -e MARIADB_DATABASE=tp3 \
  -e MARIADB_USER=tp3user \
  -e MARIADB_PASSWORD=tp3pass \
  -v "$(pwd)/db-init:/docker-entrypoint-initdb.d:ro" \
  mariadb:latest

echo "[ETAPE 2] Build du container PHP avec mysqli..."
docker build -t tp3-php-mysqli:1.0 .

echo "[ETAPE 2] Lancement du container PHP-FPM (script)..."
docker run -d --name script --network tp3net \
  -v "$(pwd)/src:/app" \
  tp3-php-mysqli:1.0

echo "[ETAPE 2] Lancement du container NGINX (http)..."
docker run -d --name http --network tp3net -p 8080:80 \
  -v "$(pwd)/src:/app" \
  -v "$(pwd)/config/default.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:latest

echo "[ETAPE 2] Application disponible sur http://localhost:8080/test.php"
