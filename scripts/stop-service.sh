#!/bin/bash

# Script para detener el servicio BarberShop API

APP_DIR="$HOME/barbershop-api"
PID_FILE="$APP_DIR/app.pid"
PORT=9090

echo "🛑 Deteniendo BarberShop API..."

# Detener usando PID file
if [ -f "$PID_FILE" ]; then
    PID=$(cat $PID_FILE)
    if ps -p $PID > /dev/null 2>&1; then
        kill $PID
        echo "Esperando a que el proceso termine..."
        sleep 5

        if ps -p $PID > /dev/null 2>&1; then
            kill -9 $PID
            echo "Proceso forzado a terminar"
        fi
    fi
    rm -f $PID_FILE
fi

# Buscar y matar cualquier proceso en el puerto
PORT_PID=$(lsof -ti:$PORT 2>/dev/null)
if [ ! -z "$PORT_PID" ]; then
    echo "Matando proceso en puerto $PORT (PID: $PORT_PID)"
    kill -9 $PORT_PID
fi

echo "✅ Servicio detenido"

