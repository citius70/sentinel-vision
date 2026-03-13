REM ============================================================================
REM  SENTINELVERSION - INSTALADOR PARA WINDOWS
REM  Detector de Gafas de Seguridad en Puestos de Trabajo
REM  Versión: 1.2.1
REM  Explicado para alumnos de 2º Bachillerato
REM ============================================================================
REM
REM ¿QUE ES ESTE ARCHIVO?
REM ─────────────────────
REM Este es un script (archivo de ordenes) que automatiza la instalación
REM de todas las herramientas necesarias para ejecutar SentinelVision.
REM
REM En lugar de escribir comandos manualmente uno a uno, este archivo
REM los ejecuta automáticamente. ¡Es como un asistente de instalación!
REM
REM ¿QUE HACE?
REM ──────────
REM 1. Comprueba que tengas Python instalado (y con la versión correcta)
REM 2. Comprueba que tengas pip (gestor de paquetes de Python)
REM 3. Descarga e instala las librerías necesarias (opencv, ultralytics)
REM 4. Te pregunta si quieres ejecutar el programa
REM
REM ============================================================================

@echo off
REM "@echo off" = No mostrar cada comando que se ejecuta (más limpio)
REM "REM" = Comentario en batch (no se ejecuta, es solo anotación)

REM Configurar codificación a UTF-8 para caracteres españoles
chcp 65001 >nul

REM Mostrar banner de inicio
echo.
echo =====================================================
echo      INSTALADOR - SentinelVision v1.2.1
echo      Detector de Gafas de Seguridad
echo      IES Frei Martin Sarmiento - Pontevedra
echo =====================================================
echo.
echo Este instalador descargara e instalara todas las
echo librerias necesarias para ejecutar SentinelVision.
echo.
pause

REM ============================================================================
REM PASO 1: COMPROBAR SI PYTHON ESTA INSTALADO
REM ============================================================================
REM
REM ¿Por qué necesitamos Python?
REM     Python es el lenguaje de programación en el que está escrito
REM     SentinelVision. Sin Python, el programa no puede ejecutarse.
REM
REM ¿Por qué Python 3.12+?
REM     Algunas librerías modernas (como ultralytics) requieren características
REM     que solo están en versiones recientes de Python. Versiones antiguas
REM     causarían errores de compatibilidad.
REM
REM ¿QUE HACE ESTE CODIGO?
REM     - python -c "import sys; exit(0 if sys.version_info >= (3, 12) else 1)"
REM       Esto ejecuta Python y comprueba su versión.
REM     - Si la versión es 3.12 o superior, devuelve 0 (éxito)
REM     - Si es más antigua, devuelve 1 (fallo)
REM     - El valor se guarda en %errorlevel% (variable especial de Windows)
REM     - if %errorlevel% neq 0 = Si el resultado NO fue exitoso...
REM
REM ============================================================================

echo [1/4] Comprobando si tienes Python 3.12 o superior...
echo.

REM Ejecutamos el comando de comprobación
REM ">nul 2>&1" = No mostrar mensajes de salida (más limpio)
python -c "import sys; exit(0 if sys.version_info >= (3, 12) else 1)" >nul 2>&1

REM Comprobamos el resultado
REM %errorlevel% contiene: 0 (éxito) o 1 (fallo)
REM "neq" = not equal (no igual) en inglés
if %errorlevel% neq 0 (
    REM Si Python 3.12+ no está instalado...
    echo    ! Python 3.12+ no detectado.
    echo    ! Descargando Python 3.12.0 desde python.org...
    echo.
    
    REM Descargar el instalador de Python
    REM "curl" = comando para descargar archivos de Internet
    REM "-o python_installer.exe" = guardar como "python_installer.exe"
    curl -o python_installer.exe https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe
    
    echo    Ejecutando instalador...
    REM "/quiet" = Instalación silenciosa (sin hacer preguntas)
    REM "InstallAllUsers=1" = Instalar para todos los usuarios
    REM "PrependPath=1" = Añadir Python al PATH (importante para que funcione desde terminal)
    python_installer.exe /quiet InstallAllUsers=1 PrependPath=1
    
    REM Borrar el instalador (ya no lo necesitamos)
    del python_installer.exe
    
    echo    Python 3.12 instalado correctamente.
) else (
    REM Si Python 3.12+ ya está instalado...
    echo    Excelente! Python 3.12+ ya está instalado.
    echo    Versión detectada:
    python --version
)

echo.
echo ============================================================================
echo.

REM ============================================================================
REM PASO 2: COMPROBAR SI PIP ESTA DISPONIBLE
REM ============================================================================
REM
REM ¿Qué es pip?
REM     pip = "Pip Installs Packages" (Pip instala paquetes)
REM     Es el gestor de paquetes de Python. Sirve para descargar e instalar
REM     librerías externas (como opencv, ultralytics, etc.)
REM
REM Analogía:
REM     - Python = El motor de un coche
REM     - pip = La gasolinera que suministra el combustible
REM     - Las librerías = El combustible que hace funcionar el coche
REM
REM ============================================================================

echo [2/4] Comprobando pip (gestor de librerias de Python)...
echo.

REM Comprobar si pip está disponible
pip --version >nul 2>&1

if %errorlevel% neq 0 (
    REM Si pip no está disponible...
    echo    ! pip no encontrado. Instalando...
    REM "ensurepip" = Módulo de Python que instala pip automáticamente
    python -m ensurepip --upgrade
    echo    pip instalado y actualizado.
) else (
    REM Si pip ya está instalado...
    echo    Excelente! pip ya está disponible.
    echo    Versión detectada:
    pip --version
)

echo.
echo ============================================================================
echo.

REM ============================================================================
REM PASO 3: INSTALAR LAS LIBRERIAS NECESARIAS
REM ============================================================================
REM
REM ¿Qué librerías necesitamos?
REM
REM 1. opencv-python
REM    - Sirve para: Capturar video de la cámara y procesar imágenes
REM    - ¿Por qué la necesitamos?
REM      Para mostrar el vídeo en tiempo real en pantalla y dibujar
REM      los rectángulos alrededor de las caras detectadas
REM
REM 2. ultralytics
REM    - Sirve para: Usar modelos YOLOv8 (el "cerebro" de IA)
REM    - ¿Por qué la necesitamos?
REM      Para analizar cada fotograma y detectar si hay gafas o no
REM
REM ¿Qué significa "pip install"?
REM     - "pip install" = Descargar e instalar
REM     - "--user" = Instalar solo para el usuario actual (no para todo el sistema)
REM     - "--upgrade" = Si ya existe, actualizar a la versión más reciente
REM
REM ============================================================================

echo [3/4] Instalando las librerias necesarias...
echo.
echo   Esto puede tardar 2-5 minutos (depende de tu conexion a Internet)
echo.
echo   Librerias a instalar:
echo     1. opencv-python (para procesar video y camaras)
echo     2. ultralytics (para el modelo de IA YOLO)
echo.
echo   Por favor, espera...
echo.

REM Instalar opencv-python
REM Esta librería es esencial para capturar y procesar vídeo
echo   [Instalando opencv-python...]
pip install --user opencv-python

REM Instalar ultralytics
REM Esta librería proporciona acceso a los modelos YOLO v8
echo   [Instalando ultralytics...]
pip install --user --upgrade ultralytics

REM Comprobar si la instalación fue exitosa
if %errorlevel% neq 0 (
    REM Si hubo un error durante la instalación...
    echo.
    echo   ERROR: No se pudieron instalar las librerias.
    echo.
    echo   Posibles causas:
    echo     1. Sin conexión a Internet
    echo     2. Conexión muy lenta o inestable
    echo     3. Problema con los servidores de descarga
    echo.
    echo   Soluciones:
    echo     - Comprueba tu conexión a Internet
    echo     - Intenta de nuevo en unos minutos
    echo     - Si persiste el error, contacta con el profesor
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================================================
echo.

REM ============================================================================
REM RESUMEN: TODAS LAS INSTALACIONES COMPLETADAS
REM ============================================================================

echo   Excelente! Todas las instalaciones se completaron correctamente.
echo.
echo   Resumen de lo instalado:
echo     ✓ Python 3.12+
echo     ✓ pip (gestor de paquetes)
echo     ✓ opencv-python (procesar vídeo)
echo     ✓ ultralytics (modelo IA YOLO v8)
echo.
echo   Tu ordenador ya está listo para ejecutar SentinelVision.
echo.

REM ============================================================================
REM PASO 4: PREGUNTAR SI EJECUTAR EL PROGRAMA
REM ============================================================================
REM
REM Ahora le preguntamos al usuario si quiere ejecutar el programa.
REM
REM "set /p" = Esperar a que el usuario escriba algo
REM "respuesta=" = Guardar lo que escriba en la variable %respuesta%
REM "/i" = Comparar sin importar mayúsculas/minúsculas
REM
REM ============================================================================

set /p respuesta="   Deseas ejecutar SentinelVision ahora? (s/n): "

if /i "%respuesta%"=="s" (
    REM Si el usuario escribe "s" o "S"...
    echo.
    echo   Iniciando SentinelVision...
    echo   Espera a que se cargue el modelo de IA (puede tardar 10-30 segundos)
    echo   Pulsa Q en la ventana de la camara para salir.
    echo.
    REM Ejecutar el programa principal
    python safety_glasses_detector.py
) else (
    REM Si el usuario escribe cualquier otra cosa...
    echo.
    echo   Puedes ejecutar SentinelVision mas tarde escribiendo en la terminal:
    echo.
    echo   python safety_glasses_detector.py
    echo.
)

echo.
echo ============================================================================
echo   Gracias por usar SentinelVision
echo   IES Frei Martin Sarmiento - Pontevedra
echo ============================================================================
echo.

REM Pausa final para que el usuario vea el mensaje antes de cerrar
pause
