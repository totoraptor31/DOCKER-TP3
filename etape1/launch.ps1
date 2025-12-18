docker rm -f http script 2>$null | Out-Null

docker network inspect tp3net *> $null
if ($LASTEXITCODE -ne 0) { docker network create tp3net | Out-Null }

docker run -d --name script --network tp3net `
  -v "${PSScriptRoot}\src:/app" `
  php:8.3-fpm | Out-Null

docker run -d --name http --network tp3net -p 8080:80 `
  -v "${PSScriptRoot}\src:/app" `
  -v "${PSScriptRoot}\config\default.conf:/etc/nginx/conf.d/default.conf:ro" `
  nginx:latest | Out-Null

Write-Host "OK -> http://localhost:8080"
