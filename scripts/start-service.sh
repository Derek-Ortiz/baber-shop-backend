#!/bin/bash

echo "🚀 Iniciando despliegue de BarberShop API..."

# Variables
APP_NAME="barbershop-api"
APP_DIR="$HOME/barbershop-api"
JAR_FILE=$(ls $APP_DIR/*.jar | head -n 1)
PID_FILE="$APP_DIR/app.pid"
LOG_FILE="$APP_DIR/app.log"
PORT=9090

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para detener el servicio existente
stop_service() {
    echo -e "${YELLOW}🛑 Deteniendo servicio existente...${NC}"

    if [ -f "$PID_FILE" ]; then
        PID=$(cat $PID_FILE)
        if ps -p $PID > /dev/null 2>&1; then
            kill $PID
            echo "Esperando a que el proceso termine..."
            sleep 5

            # Si todavía está corriendo, forzar
            if ps -p $PID > /dev/null 2>&1; then
                kill -9 $PID
                echo -e "${RED}Proceso forzado a terminar${NC}"
            fi
        fi
        rm -f $PID_FILE
    fi

    # Buscar y matar cualquier proceso en el puerto
    PORT_PID=$(lsof -ti:$PORT)
    if [ ! -z "$PORT_PID" ]; then
        echo -e "${YELLOW}Matando proceso en puerto $PORT (PID: $PORT_PID)${NC}"
        kill -9 $PORT_PID
        sleep 2
    fi

    echo -e "${GREEN}✅ Servicio detenido${NC}"
}

# Función para iniciar el servicio
start_service() {
    echo -e "${YELLOW}🚀 Iniciando servicio...${NC}"

    if [ ! -f "$JAR_FILE" ]; then
        echo -e "${RED}❌ Error: No se encontró el archivo JAR${NC}"
        exit 1
    fi

    # Configurar variables de entorno para la BD
    export DB_URL="jdbc:mysql://localhost:3306/barber_shop"
    export DB_USER="BS"
    export DB_PASSWORD="barbershop"

    # Iniciar la aplicación en segundo plano
    cd $APP_DIR
    nohup java -jar "$JAR_FILE" > "$LOG_FILE" 2>&1 &

    # Guardar PID
    echo $! > $PID_FILE

    echo -e "${GREEN}✅ Servicio iniciado (PID: $(cat $PID_FILE))${NC}"
    echo -e "${GREEN}📝 Logs disponibles en: $LOG_FILE${NC}"
}

# Función para verificar el estado
check_status() {
    echo -e "${YELLOW}🔍 Verificando estado del servicio...${NC}"

    sleep 10

    # Verificar si el proceso está corriendo
    if [ -f "$PID_FILE" ]; then
        PID=$(cat $PID_FILE)
        if ps -p $PID > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Proceso corriendo (PID: $PID)${NC}"

            # Verificar si responde en el puerto
            sleep 5
            response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT/api/health 2>/dev/null || echo "000")

            if [ "$response" = "200" ]; then
                echo -e "${GREEN}✅ API respondiendo correctamente en puerto $PORT${NC}"
                echo -e "${GREEN}🌐 URL: http://localhost:$PORT/api/health${NC}"
            else
                echo -e "${YELLOW}⚠️ El servicio está iniciando... (Código: $response)${NC}"
                echo -e "${YELLOW}📝 Revisa los logs: tail -f $LOG_FILE${NC}"
            fi
        else
            echo -e "${RED}❌ El proceso no está corriendo${NC}"
            echo -e "${RED}📝 Revisa los logs: tail -f $LOG_FILE${NC}"
        fi
    else
        echo -e "${RED}❌ No se encontró el archivo PID${NC}"
    fi
}

# Función principal
main() {
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    echo -e "${GREEN}   BarberShop API Deployment Script    ${NC}"
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    echo ""

    # Detener servicio existente
    stop_service

    echo ""

    # Iniciar nuevo servicio
    start_service

    echo ""

    # Verificar estado
    check_status

    echo ""
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    echo -e "${GREEN}         Deployment Completado          ${NC}"
    echo -e "${GREEN}════════════════════════════════════════${NC}"
}

# Ejecutar
main

