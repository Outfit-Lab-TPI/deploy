#!/bin/bash

# Carga las variables de entorno desde el archivo .env
export $(grep -v '^#' .env | xargs)

# Loguearse a GitHub Container Registry
# Se asume que ya has hecho 'docker login ghcr.io' manualmente una vez
# o que estás usando un token.
echo $CR_PAT | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin

# Detiene los contenedores actuales si están corriendo
docker-compose down

# Trae las últimas imágenes de los servicios definidos
docker-compose pull

# Levanta los servicios en modo detached
docker-compose up -d

# Muestra los logs de watchtower para confirmar que está corriendo
echo "Deployment finished. Watchtower is monitoring for new images."
docker logs watchtower
