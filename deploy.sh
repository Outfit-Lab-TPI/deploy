#!/bin/bash

# NOTA: Ya no se usa 'export'. Docker Compose se encarga de las variables con --env-file.

# Loguearse a GitHub Container Registry
# La variable CR_PAT se lee desde el .env gracias a --env-file
echo "Iniciando sesión en ghcr.io..."
CR_PAT_VALUE=$(grep CR_PAT .env | cut -d '=' -f2)
echo $CR_PAT_VALUE | docker login ghcr.io -u outfit-lab-tpi --password-stdin

# Detiene los contenedores actuales si están corriendo
echo "Deteniendo contenedores existentes..."
docker compose --env-file .env down

# Trae las últimas imágenes de los servicios definidos
echo "Descargando las últimas imágenes..."
docker compose --env-file .env pull

# Levanta los servicios en modo detached
echo "Iniciando nuevos contenedores..."
docker compose --env-file .env up -d

# Muestra el estado de los contenedores para confirmar
echo "¡Despliegue finalizado! Verificando estado de los contenedores..."
docker compose --env-file .env ps
