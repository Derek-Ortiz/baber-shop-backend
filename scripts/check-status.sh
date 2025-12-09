#!/bin/bash

# Script para verificar el estado del servicio BarberShop API

APP_DIR="$HOME/barbershop-api"
PID_FILE="$APP_DIR/app.pid"
LOG_FILE="$APP_DIR/app.log"
PORT=9090

echo "🔍 Estado de BarberShop API"
echo "════════════════════════════════"

# Verificar proceso
if [ -f "$PID_FILE" ]; then
    PID=$(cat $PID_FILE)
    if ps -p $PID > /dev/null 2>&1; then
        echo "✅ Proceso: Corriendo (PID: $PID)"

        # Verificar memoria y CPU
        ps -p $PID -o %cpu,%mem,etime,cmd
    else
        echo "❌ Proceso: No corriendo (PID file existe pero proceso no)"
    fi
else
    echo "❌ Proceso: No corriendo (No hay PID file)"
fi

echo ""

# Verificar puerto
if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "✅ Puerto $PORT: Escuchando"
else
    echo "❌ Puerto $PORT: No escuchando"
fi

echo ""

# Verificar respuesta HTTP
echo "🌐 Probando endpoint de salud..."
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT/api/health 2>/dev/null || echo "000")

if [ "$response" = "200" ]; then
    echo "✅ API: Respondiendo correctamente"
    curl -s http://localhost:$PORT/api/health | jq '.' 2>/dev/null || curl -s http://localhost:$PORT/api/health
elif [ "$response" = "000" ]; then
    echo "❌ API: No responde (Connection refused)"
else
    echo "⚠️ API: Responde con código $response"
fi

echo ""
echo "════════════════════════════════"
echo "📝 Últimas 10 líneas del log:"
echo "════════════════════════════════"

if [ -f "$LOG_FILE" ]; then
    tail -n 10 "$LOG_FILE"
else
    echo "No hay archivo de log disponible"
fi

echo ""
echo "💡 Comandos útiles:"
echo "  Ver logs completos: tail -f $LOG_FILE"
echo "  Detener servicio: ~/barbershop-api/stop-service.sh"
echo "  Reiniciar servicio: ~/barbershop-api/start-service.sh"

