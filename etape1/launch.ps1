Write-Host "[ETAPE 1] Nettoyage des containers existants..."
docker rm -f http script 2>$null | Out-Null

Write-Host "[ETAPE 1] Création du réseau (si absent)..."
docker network inspect tp3net *> $null
if ($LASTEXITCODE -ne 0) {
    docker network create tp3net | Out-Null
}

Write-Host "[ETAPE 1] Lancement PHP-FPM..."
docker run -d --name script --network tp3net `
  -v "$PSScriptRoot\src:/app" `
  php:8.3-fpm | Out-Null

Write-Host "[ETAPE 1] Lancement NGINX..."
docker run -d --name http --network tp3net -p 8080:80 `
  -v "$PSScriptRoot\src:/app" `
  -v "$PSScriptRoot\config\default.conf:/etc/nginx/conf.d/default.conf:ro" `
  nginx:latest | Out-Null

Write-Host "[ETAPE 1] OK -> http://localhost:8080"
