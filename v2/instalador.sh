#!/bin/bash

echo "Instalando dependencias en Linux..."

# 1. Actualizar repositorios e instalar Python3 y pip
sudo apt update
sudo apt install -y python3 python3-pip python3-venv

# 2. Crear un entorno virtual (muy recomendado en Linux)
python3 -m venv venv
source venv/bin/activate

# 3. Instalar librerías
pip install opencv-python ultralytics

echo "Instalación completada. Ejecuta con: python3 safety_glasses_detector.py"