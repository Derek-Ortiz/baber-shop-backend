#!/bin/bash

echo "🔍 Diagnóstico de BarberShop API"
echo "════════════════════════════════════════"

APP_DIR="$HOME/barbershop-api"
LOG_FILE="$APP_DIR/app.log"
JAR_FILE=$(ls $APP_DIR/*.jar 2>/dev/null | head -n 1)

echo ""
echo "📁 Verificando archivos..."
if [ -f "$JAR_FILE" ]; then
    echo "✅ JAR encontrado: $(basename $JAR_FILE)"
    ls -lh "$JAR_FILE"
else
    echo "❌ No se encontró el archivo JAR"
    echo "Archivos en $APP_DIR:"
    ls -lh "$APP_DIR"
fi

echo ""
echo "📝 Últimas 50 líneas del log:"
echo "════════════════════════════════════════"
if [ -f "$LOG_FILE" ]; then
    tail -n 50 "$LOG_FILE"
else
    echo "❌ No se encontró el archivo de log"
fi

echo ""
echo "════════════════════════════════════════"
echo "🔍 Verificando Java..."
java -version 2>&1 | head -n 3

echo ""
echo "🔍 Verificando MySQL..."
if command -v mysql &> /dev/null; then
    systemctl status mysql --no-pager | grep -E "(Active|Loaded)"

    echo ""
    echo "Probando conexión a MySQL..."
    mysql -u BS -pbarbershop -e "SELECT 1;" 2>&1 | head -n 5
else
    echo "⚠️ MySQL no está instalado o no se encuentra en PATH"
fi

echo ""
echo "🔍 Verificando puertos..."
echo "Puerto 9090:"
netstat -tlnp 2>/dev/null | grep 9090 || echo "No hay nada escuchando en 9090"
echo "Puerto 8080:"
netstat -tlnp 2>/dev/null | grep 8080 || echo "No hay nada escuchando en 8080"

echo ""
echo "🔍 Procesos Java corriendo:"
ps aux | grep java | grep -v grep || echo "No hay procesos Java corriendo"

echo ""
echo "════════════════════════════════════════"
echo "💡 Comandos útiles:"
echo "  Ver logs completos: tail -f $LOG_FILE"
echo "  Reintentar inicio: $APP_DIR/start-service.sh"
echo "  Ejecutar manualmente: cd $APP_DIR && java -jar $(basename $JAR_FILE)"

