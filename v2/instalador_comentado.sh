#!/bin/bash

################################################################################
#  SENTINELVERSION - INSTALADOR PARA LINUX
#  Detector de Gafas de Seguridad en Puestos de Trabajo
#  Versión: 1.2.1
#  Explicado para alumnos de 2º Bachillerato
################################################################################
#
# ¿QUE ES ESTE ARCHIVO?
# ─────────────────────
# Este es un script BASH (shell script) que automatiza la instalación
# de todas las herramientas necesarias para ejecutar SentinelVision en Linux.
#
# BASH es el intérprete de comandos predeterminado en sistemas Linux.
# Un script BASH es como un programa que ejecuta comandos del sistema operativo.
#
# ¿QUE HACE?
# ──────────
# 1. Actualiza los repositorios de paquetes del sistema (apt update)
# 2. Instala Python3, pip y sus herramientas asociadas
# 3. Crea un entorno virtual (entorno aislado para las librerías)
# 4. Descarga e instala las librerías necesarias (opencv, ultralytics)
#
# ¿POR QUE NECESITAMOS UN ENTORNO VIRTUAL?
# ──────────────────────────────────────────
# En Linux, es buena práctica crear un "entorno virtual" para cada proyecto:
#   - Evita conflictos entre librerías de diferentes proyectos
#   - Si algo falla, solo afecta al proyecto, no a todo el sistema
#   - Es fácil de limpiar (simplemente borrar la carpeta venv)
#
# Analogía: Es como tener un "escritorio de trabajo" privado dentro de tu 
# ordenador, donde tienes solo las herramientas que necesitas para este proyecto.
#
################################################################################

# Definir colores para mensajes (para que sean más legibles)
# Estos códigos de color funciona en terminales Linux
GREEN='\033[0;32m'      # Verde (éxito)
RED='\033[0;31m'        # Rojo (error)
YELLOW='\033[1;33m'     # Amarillo (advertencia)
NC='\033[0m'            # No Color (volver a normal)

# Mostrar banner de inicio
echo ""
echo "======================================================"
echo "  INSTALADOR - SentinelVision v1.2.1"
echo "  Detector de Gafas de Seguridad"
echo "  IES Frei Martin Sarmiento - Pontevedra"
echo "======================================================"
echo ""
echo "Este instalador descargara e instalara todas las"
echo "librerias necesarias para ejecutar SentinelVision en Linux."
echo ""

################################################################################
# PASO 1: ACTUALIZAR LOS REPOSITORIOS DEL SISTEMA
################################################################################
#
# ¿Qué son los repositorios?
#     Los repositorios son servidores en Internet que almacenan miles de
#     programas y librerías disponibles para Linux. Debian/Ubuntu usa el
#     gestor de paquetes "apt" (Advanced Package Tool).
#
# ¿Por qué actualizar?
#     Necesitamos la lista más reciente de programas disponibles para poder
#     descargar las versiones más modernas.
#
# "sudo" = Execute as SuperUser (ejecutar como administrador)
#     Necesitamos permisos de administrador para instalar programas en Linux
#
# "apt update" = Descargar la lista actualizada de paquetes disponibles
#
# "|| { ... }" = Si el comando anterior falló, ejecuta esto
#     Es un sistema de control de errores: si algo sale mal, lo detectamos
#
################################################################################

echo "[1/4] Actualizando repositorios del sistema..."
echo ""

sudo apt update || {
    # Si apt update falla, mostrar error y salir
    echo -e "${RED}Error: No se pudo actualizar los repositorios${NC}"
    echo "Posibles causas:"
    echo "  - Sin conexión a Internet"
    echo "  - Problema con los servidores de Ubuntu/Debian"
    echo ""
    exit 1
}

echo ""

################################################################################
# PASO 2: INSTALAR PYTHON3, PIP Y HERRAMIENTAS RELACIONADAS
################################################################################
#
# ¿Qué vamos a instalar?
#
# 1. python3
#    - El intérprete de Python (necesario para ejecutar programas en Python)
#
# 2. python3-pip
#    - El gestor de paquetes de Python
#    - Sirve para descargar e instalar librerías como opencv y ultralytics
#
# 3. python3-venv
#    - Herramienta para crear entornos virtuales
#    - Aísla las librerías de este proyecto del resto del sistema
#
# "apt install -y" = Instalar estos paquetes
#     "-y" = Responder automáticamente "yes" (sí) a cualquier pregunta
#
################################################################################

echo "[2/4] Instalando Python3, pip y herramientas..."
echo ""

sudo apt install -y python3 python3-pip python3-venv || {
    # Si la instalación falla...
    echo -e "${RED}Error: No se pudieron instalar las herramientas basicas${NC}"
    echo "Contacta con el profesor si el problema persiste."
    exit 1
}

echo -e "${GREEN}Python y pip instalados correctamente${NC}"
echo ""

################################################################################
# PASO 3: CREAR Y ACTIVAR EL ENTORNO VIRTUAL
################################################################################
#
# ¿Qué es un entorno virtual?
#     Un "directorio especial" donde Python instalará las librerías
#     de forma aislada del resto del sistema.
#
# Ventajas:
#     - Cada proyecto tiene sus propias librerías
#     - No interfieren con otros proyectos
#     - Fácil de limpiar (borrar la carpeta venv)
#
# "python3 -m venv venv" = Crear un entorno virtual en la carpeta "venv"
#     "-m venv" = Ejecutar el módulo venv de Python
#     El último "venv" = nombre de la carpeta a crear
#
# "source venv/bin/activate" = Activar el entorno virtual
#     Después de esto, pip instalará librerías en el entorno virtual,
#     no en todo el sistema.
#
################################################################################

echo "[3/4] Creando entorno virtual..."
echo ""

if [ ! -d "venv" ]; then
    # Si la carpeta venv NO existe...
    python3 -m venv venv || {
        echo -e "${RED}Error: No se pudo crear el entorno virtual${NC}"
        exit 1
    }
    echo -e "${GREEN}Entorno virtual creado${NC}"
else
    # Si ya existe...
    echo -e "${YELLOW}El entorno virtual ya existe, usando el existente${NC}"
fi

echo ""

# Activar el entorno virtual
# Después de ejecutar esto, (venv) aparecerá en el prompt de la terminal
source venv/bin/activate || {
    echo -e "${RED}Error: No se pudo activar el entorno virtual${NC}"
    exit 1
}

echo ""

################################################################################
# PASO 4: INSTALAR LAS LIBRERIAS PYTHON NECESARIAS
################################################################################
#
# Ahora que el entorno virtual está activado, instalaremos las librerías.
#
# 1. opencv-python
#    Para qué: Capturar vídeo de la cámara y procesar imágenes
#    Tamaño: ~30 MB
#
# 2. ultralytics
#    Para qué: Acceder a los modelos YOLOv8 (la "inteligencia artificial")
#    Tamaño: ~50 MB (+ 25 MB el modelo best.pt que se descargará después)
#
# "pip install --upgrade pip" = Primero actualizar pip a la última versión
#     pip necesita estar actualizado para instalar correctamente
#
# El bucle "for i in 1 2 3" = Reintentar 3 veces si falla
#     A veces la descarga falla por problemas de red. Este bucle permite
#     3 intentos antes de rendirse.
#
################################################################################

echo "[4/4] Instalando librerias Python..."
echo ""
echo "  Esto puede tardar 3-5 minutos (depende de tu conexion)"
echo "  Librerías a descargar:"
echo "    1. opencv-python (captura y procesamiento de video)"
echo "    2. ultralytics (modelo IA YOLOv8)"
echo ""

# Primero, actualizar pip
pip install --upgrade pip

echo ""
echo "  Instalando... por favor espera..."
echo ""

# Bucle de reintentos: intenta 3 veces antes de fallar
for i in 1 2 3; do
    pip install opencv-python ultralytics && break || {
        # Si pip install falló...
        if [ $i -eq 3 ]; then
            # Si es el 3er intento, mostrar error y salir
            echo -e "${RED}Error: No se pudieron instalar las librerias despues de 3 intentos${NC}"
            echo ""
            echo "Posibles soluciones:"
            echo "  1. Comprueba tu conexión a Internet"
            echo "  2. Intenta de nuevo en unos minutos"
            echo "  3. Contacta con el profesor si persiste el error"
            exit 1
        fi
        # Si no es el último intento, esperar e intentar de nuevo
        echo -e "${YELLOW}Intento $i fallido, reintentando en 5 segundos...${NC}"
        sleep 5
    }
done

echo ""
echo "======================================================"
echo -e "${GREEN}Instalacion completada correctamente${NC}"
echo "======================================================"
echo ""

################################################################################
# INFORMACION FINAL Y PROXIMOS PASOS
################################################################################
#
# Mostrar instrucciones para usar SentinelVision
#
# El entorno virtual sigue activado (lo sabremos porque el prompt
# mostrará "(venv)" al inicio).
#
################################################################################

echo "Instalacion finalizada. El entorno virtual ya esta activado."
echo ""
echo "Proximos pasos:"
echo ""
echo "  1. Ejecutar SentinelVision:"
echo "     python3 safety_glasses_detector.py"
echo ""
echo "  2. Cuando termines, desactivar el entorno virtual:"
echo "     deactivate"
echo ""
echo "  3. Si cierras la terminal y quieres ejecutar de nuevo:"
echo "     source venv/bin/activate"
echo "     python3 safety_glasses_detector.py"
echo ""
echo "======================================================"
echo "Gracias por usar SentinelVision"
echo "IES Frei Martin Sarmiento - Pontevedra"
echo "======================================================"
echo ""

# El script termina aquí
# Si llegamos hasta aquí sin errores, todo está instalado correctamente
