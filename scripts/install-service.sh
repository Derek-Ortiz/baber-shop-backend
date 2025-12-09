#!/bin/bash

# Script para instalar el servicio systemd de BarberShop API

echo "📦 Instalando BarberShop API como servicio systemd..."

# Verificar que se ejecute como root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Este script debe ejecutarse como root (usa sudo)"
    exit 1
fi

# Variables
SERVICE_FILE="barbershop-api.service"
SYSTEMD_DIR="/etc/systemd/system"

# Copiar archivo de servicio
echo "📋 Copiando archivo de servicio..."
cp $SERVICE_FILE $SYSTEMD_DIR/

# Recargar systemd
echo "🔄 Recargando systemd..."
systemctl daemon-reload

# Habilitar el servicio para que inicie automáticamente
echo "✅ Habilitando servicio..."
systemctl enable barbershop-api.service

# Iniciar el servicio
echo "🚀 Iniciando servicio..."
systemctl start barbershop-api.service

# Esperar un momento
sleep 5

# Mostrar estado
echo ""
echo "📊 Estado del servicio:"
systemctl status barbershop-api.service --no-pager

echo ""
echo "════════════════════════════════════════"
echo "✅ Instalación completada"
echo "════════════════════════════════════════"
echo ""
echo "💡 Comandos útiles:"
echo "  Estado:    sudo systemctl status barbershop-api"
echo "  Iniciar:   sudo systemctl start barbershop-api"
echo "  Detener:   sudo systemctl stop barbershop-api"
echo "  Reiniciar: sudo systemctl restart barbershop-api"
echo "  Logs:      sudo journalctl -u barbershop-api -f"
echo ""

