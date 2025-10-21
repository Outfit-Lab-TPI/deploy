#!/bin/bash

# Script para configurar SSL con Let's Encrypt para outfitlab.com.ar

echo "🔐 Configuración de SSL para outfitlab.com.ar"
echo "=============================================="

# Variables
DOMAIN="outfitlab.com.ar"
EMAIL="tu-email@example.com"  # CAMBIA ESTO por tu email real

echo ""
echo "⚠️  IMPORTANTE: Antes de continuar, asegúrate de que:"
echo "   1. El dominio $DOMAIN apunta a la IP de esta VM"
echo "   2. Los puertos 80 y 443 están abiertos en el firewall"
echo "   3. Docker compose está corriendo (docker compose up -d)"
echo ""
read -p "¿Todo listo? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Abortado. Configura lo necesario y vuelve a ejecutar."
    exit 1
fi

echo ""
echo "📝 Paso 1: Verificando que nginx esté corriendo..."
if ! docker ps | grep -q nginx_proxy; then
    echo "❌ Error: nginx_proxy no está corriendo"
    echo "   Ejecuta: docker compose up -d"
    exit 1
fi
echo "✅ Nginx corriendo"

echo ""
echo "📝 Paso 2: Obteniendo certificado SSL..."
echo "   Esto puede tardar un minuto..."

docker compose run --rm certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email $EMAIL \
    --agree-tos \
    --no-eff-email \
    -d $DOMAIN \
    -d www.$DOMAIN

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Certificado obtenido exitosamente!"
    echo ""
    echo "📝 Paso 3: Reiniciando nginx para aplicar SSL..."
    docker compose restart nginx-proxy
    
    echo ""
    echo "🎉 ¡Listo! Tu sitio debería estar accesible en:"
    echo "   https://$DOMAIN"
    echo "   https://www.$DOMAIN"
    echo ""
    echo "📌 El certificado se renovará automáticamente."
else
    echo ""
    echo "❌ Error al obtener el certificado."
    echo "   Verifica que:"
    echo "   - El dominio $DOMAIN apunte correctamente a esta VM"
    echo "   - El puerto 80 esté accesible desde internet"
    echo "   - nginx esté corriendo correctamente"
    exit 1
fi
