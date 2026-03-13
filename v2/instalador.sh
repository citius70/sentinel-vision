#!/bin/bash

echo ""
echo "======================================================"
echo "  INSTALADOR - SentinelVision v1.2.1"
echo "  Detector de Gafas de Seguridad"
echo "======================================================"
echo ""

# Colores para mensajes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Actualizar repositorios
echo "[1/4] Actualizando repositorios..."
sudo apt update || {
    echo -e "${RED}Error: No se pudo actualizar repositorios${NC}"
    exit 1
}
echo ""

# 2. Instalar Python3, pip y dependencias del sistema
echo "[2/4] Instalando Python3 y pip..."
sudo apt install -y python3 python3-pip python3-venv || {
    echo -e "${RED}Error: No se pudieron instalar las herramientas basicas${NC}"
    exit 1
}
echo -e "${GREEN}Python y pip instalados correctamente${NC}"
echo ""

# 3. Crear entorno virtual
echo "[3/4] Creando entorno virtual..."
if [ ! -d "venv" ]; then
    python3 -m venv venv || {
        echo -e "${RED}Error: No se pudo crear el entorno virtual${NC}"
        exit 1
    }
    echo -e "${GREEN}Entorno virtual creado${NC}"
else
    echo -e "${YELLOW}El entorno virtual ya existe${NC}"
fi

# Activar entorno virtual
source venv/bin/activate || {
    echo -e "${RED}Error: No se pudo activar el entorno virtual${NC}"
    exit 1
}
echo ""

# 4. Instalar librerias Python
echo "[4/4] Instalando librerias Python..."
echo "    - opencv-python"
echo "    - ultralytics"
echo ""

pip install --upgrade pip

# Instalar con reintentos en el caso de fallo temporal
for i in 1 2 3; do
    pip install opencv-python ultralytics && break || {
        if [ $i -eq 3 ]; then
            echo -e "${RED}Error: No se pudieron instalar las librerias despues de 3 intentos${NC}"
            echo "Verifica tu conexion a Internet e intenta de nuevo"
            exit 1
        fi
        echo -e "${YELLOW}Intento $i fallido, reintentando en 5 segundos...${NC}"
        sleep 5
    }
done

echo ""
echo "======================================================"
echo -e "${GREEN}Instalacion completada correctamente${NC}"
echo "======================================================"
echo ""
echo "Uso:"
echo "  - Activar el entorno virtual:"
echo "    source venv/bin/activate"
echo ""
echo "  - Ejecutar el detector:"
echo "    python3 safety_glasses_detector.py"
echo ""
echo "  - Desactivar el entorno virtual cuando termines:"
echo "    deactivate"
echo ""
