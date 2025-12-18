Write-Host "[ETAPE 2] Nettoyage des containers existants..."
docker rm -f http script data 2>$null | Out-Null

Write-Host "[ETAPE 2] Création du réseau (si absent)..."
docker network inspect tp3net *> $null
if ($LASTEXITCODE -ne 0) {
    docker network create tp3net | Out-Null
}

Write-Host "[ETAPE 2] Lancement MariaDB..."
docker run -d --name data --network tp3net `
  -e MARIADB_RANDOM_ROOT_PASSWORD=1 `
  -e MARIADB_DATABASE=tp3 `
  -e MARIADB_USER=tp3user `
  -e MARIADB_PASSWORD=tp3pass `
  -v "$PSScriptRoot\db-init:/docker-entrypoint-initdb.d:ro" `
  mariadb:latest | Out-Null

Write-Host "[ETAPE 2] Build de l'image PHP (mysqli)..."
docker build -t tp3-php-mysqli:1.0 $PSScriptRoot

Write-Host "[ETAPE 2] Lancement PHP-FPM..."
docker run -d --name script --network tp3net `
  -v "$PSScriptRoot\src:/app" `
  tp3-php-mysqli:1.0 | Out-Null

Write-Host "[ETAPE 2] Lancement NGINX..."
docker run -d --name http --network tp3net -p 8080:80 `
  -v "$PSScriptRoot\src:/app" `
  -v "$PSScriptRoot\config\default.conf:/etc/nginx/conf.d/default.conf:ro" `
  nginx:latest | Out-Null

Write-Host "[ETAPE 2] OK -> http://localhost:8080/test.php"
