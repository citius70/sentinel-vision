@echo off
chcp 65001 >nul
echo =====================================================
echo      INSTALADOR - Detector de Gafas de Seguridad
echo =====================================================
echo.

:: ─────────────────────────────────────────────
:: 1. COMPROBAR SI PYTHON 3.12+ ESTÁ INSTALADO
:: ─────────────────────────────────────────────
echo [1/4] Comprobando si tienes Python 3.12 o superior...

python -c "import sys; exit(0 if sys.version_info >= (3, 12) else 1)" >nul 2>&1

if %errorlevel% neq 0 (
    echo    ! Python 3.12+ no detectado o versión antigua.
    echo    ! Descargando e instalando Python 3.12.0...
    
    curl -o python_installer.exe https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe
    python_installer.exe /quiet InstallAllUsers=1 PrependPath=1
    del python_installer.exe
    
    echo    Python 3.12 instalado correctamente.
) else (
    echo    Python 3.12+ detectado correctamente.
    python --version
)

:: ─────────────────────────────────────────────
:: 2. COMPROBAR SI PIP ESTÁ DISPONIBLE
:: ─────────────────────────────────────────────
echo [2/4] Comprobando pip...
pip --version >nul 2>&1

if %errorlevel% neq 0 (
    echo   pip NO encontrado. Instalando...
    python -m ensurepip --upgrade
    echo   pip instalado correctamente.
) else (
    echo   pip encontrado:
    pip --version
)
echo.

:: ─────────────────────────────────────────────
:: 3. INSTALAR LIBRERÍAS NECESARIAS
:: ─────────────────────────────────────────────
echo [3/4] Instalando librerias necesarias...
echo   - opencv-python
echo   - ultralytics (última versión compatible)
echo   - ultralyticsplus (última versión compatible)
echo.

:: Instalamos opencv-python
pip install --user opencv-python

:: Instalamos ultralytics y ultralyticsplus para que from_pretrained funcione
pip install --user --upgrade ultralytics
pip install --user --upgrade ultralyticsplus

if %errorlevel% neq 0 (
    echo.
    echo   ERROR: No se pudieron instalar las librerias.
    echo   Comprueba tu conexion a Internet e intentalo de nuevo.
    pause
    exit /b 1
)

echo.
echo =====================================================
echo   Todas las librerias estan listas.
echo =====================================================
echo.

:: ─────────────────────────────────────────────
:: 4. PREGUNTAR SI EJECUTAR EL PROGRAMA
:: ─────────────────────────────────────────────
set /p respuesta="   Deseas ejecutar el programa ahora? (s/n): "

if /i "%respuesta%"=="s" (
    echo.
    echo   Iniciando el detector de gafas de seguridad...
    echo   Pulsa Q en la ventana de la camara para salir.
    echo.
    python safety_glasses_detector.py
) else (
    echo.
    echo   Puedes ejecutarlo mas tarde con:
    echo   python safety_glasses_detector.py
)

echo.
pause