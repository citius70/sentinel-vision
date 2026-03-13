"""
=============================================================
  DETECTOR DE GAFAS DE SEGURIDAD EN PUESTOS DE TRABAJO
  Nivel: 2º Bachillerato
  Tecnologías: Python + OpenCV + YOLOv8
  
  VERSIÓN CORREGIDA v1.2.1
  - Solución de compatibilidad con ultralytics moderno
  - Descarga automática de modelos de Hugging Face
=============================================================
"""

# Importamos la biblioteca OpenCV.
# Se utiliza para trabajar con imágenes y vídeo (leer imágenes, mostrar vídeo, procesar frames, etc.)
import cv2

# Importamos la clase YOLO desde la biblioteca ultralytics.
# Esta clase permite cargar y utilizar modelos YOLO (You Only Look Once)
# para tareas de visión artificial como detección de objetos, segmentación o seguimiento.
from ultralytics import YOLO

# Importamos urllib para descargar modelos desde Hugging Face
import urllib.request
import os
from pathlib import Path

# ─────────────────────────────────────────────
#  1. DESCARGAMOS Y CARGAMOS EL MODELO
#     Este modelo ha sido entrenado para detectar
#     distintos equipos de protección individual (EPI)
#     en imágenes o vídeo.
#
#     Entre los objetos que puede reconocer están:
#       - goggles → gafas de seguridad
#       - helmet → casco
#       - glove → guantes
#       - mask → mascarilla
#       - shoes → calzado de seguridad
#
#     El modelo se descarga automáticamente desde
#     Hugging Face la primera vez que se ejecuta.
# ─────────────────────────────────────────────

def descargar_modelo(nombre_modelo, url_base):
    """
    Descarga un modelo YOLO desde Hugging Face si no existe localmente.
    
    Args:
        nombre_modelo: Nombre del archivo del modelo (ej: "best.pt")
        url_base: URL base del repositorio en Hugging Face
    
    Returns:
        Ruta al archivo del modelo
    """
    
    # Crear carpeta para modelos si no existe
    modelo_dir = Path.home() / ".sentinel_vision" / "modelos"
    modelo_dir.mkdir(parents=True, exist_ok=True)
    
    ruta_modelo = modelo_dir / nombre_modelo
    
    # Si el modelo ya existe, no lo descargamos de nuevo
    if ruta_modelo.exists():
        print(f"✓ Modelo encontrado localmente: {ruta_modelo}")
        return str(ruta_modelo)
    
    # Si no existe, lo descargamos
    print(f"📥 Descargando modelo desde Hugging Face...")
    print(f"   URL: {url_base}/{nombre_modelo}")
    
    try:
        urllib.request.urlretrieve(
            f"{url_base}/{nombre_modelo}",
            ruta_modelo
        )
        print(f"✓ Modelo descargado correctamente")
        return str(ruta_modelo)
    except Exception as e:
        print(f"✗ Error al descargar el modelo: {e}")
        print(f"  Verifica tu conexión a Internet e intenta de nuevo.")
        raise


print("=" * 60)
print("  DETECTOR DE GAFAS DE SEGURIDAD - INICIALIZANDO")
print("=" * 60)

# URL del modelo en Hugging Face (repositorio de keremberke)
url_modelo = "https://huggingface.co/keremberke/yolov8n-protective-equipment-detection/resolve/main"
nombre_archivo = "best.pt"

# Descargamos y obtenemos la ruta del modelo
try:
    ruta_modelo = descargar_modelo(nombre_archivo, url_modelo)
except Exception as e:
    print("\n✗ No se pudo descargar el modelo automáticamente.")
    print("  Soluciones alternativas:")
    print("  1. Comprueba tu conexión a Internet")
    print("  2. Intenta nuevamente en unos momentos")
    print("  3. Si el problema persiste, descarga manualmente desde:")
    print(f"     {url_modelo}/{nombre_archivo}")
    exit(1)

# Cargamos el modelo con YOLO
try:
    print("\n📦 Cargando el modelo YOLO...")
    modelo = YOLO(ruta_modelo)
    print("✓ Modelo cargado correctamente")
except Exception as e:
    print(f"\n✗ Error al cargar el modelo: {e}")
    exit(1)

# ─────────────────────────────────────────────
# 2. INICIALIZAMOS LA CÁMARA
#    Intentamos abrir primero la cámara principal del ordenador(0).
#    Si no está disponible, probamos con la segunda conectada a él (webcam) (1).
# ─────────────────────────────────────────────
print("\n📷 Inicializando cámara...")

camara = cv2.VideoCapture(0)  # cámara principal

if not camara.isOpened():
    print("   Cámara principal no encontrada, intentando con la segunda cámara...")
    camara.release()
    camara = cv2.VideoCapture(1)

if not camara.isOpened():
    print("✗ Error: No se pudo abrir ni la cámara principal ni la segunda.")
    print("  Soluciones:")
    print("  1. Verifica que la cámara esté conectada")
    print("  2. Cierra otras aplicaciones que usen la cámara")
    print("  3. Reinicia el programa")
    exit(1)
else:
    print("✓ Cámara iniciada correctamente")
    print("\n" + "=" * 60)
    print("  DETECCIÓN ACTIVA - Pulsa Q para salir")
    print("=" * 60 + "\n")

# ─────────────────────────────────────────────
# 3. BUCLE PRINCIPAL
#    Se ejecuta continuamente, fotograma a fotograma,
#    hasta que el usuario pulse la tecla Q para salir.
# ─────────────────────────────────────────────
contador_frames = 0
errores_captura = 0

while True:

    # 3a. Leemos un fotograma de la cámara gracias a la librería OpenCV
    #     ret = True si la captura fue correcta
    #     frame = la imagen capturada por la cámara
    #           Qué contiene frame: Es un array de 3 dimensiones: (alto, ancho, canales)
    #               alto = número de filas de píxeles
    #               ancho = número de columnas de píxeles
    #               canales = 3 (para imágenes en color BGR)
    #     Por ejemplo, si tu cámara captura video a 640×480 píxeles, el shape sería: 480 x 640 x 3
    ret, frame = camara.read()

    # Si no se pudo leer el fotograma, registramos el error
    if not ret:
        errores_captura += 1
        if errores_captura > 10:
            print("✗ Error: No se puede leer la cámara después de varios intentos.")
            break
        continue

    errores_captura = 0  # Resetamos contador de errores si captura es exitosa
    contador_frames += 1

    # 3b. Pasamos el fotograma al modelo de detección
    #     El modelo analiza la imagen y devuelve información sobre los objetos detectados.
    #     
    #     resultados es una lista de objetos, donde cada objeto contiene:
    #       - boxes: lista de cajas delimitadoras (rectángulos) de los objetos detectados
    #       - conf: confianza de cada detección (0.0 = inseguro, 1.0 = seguro)
    #       - cls: clase detectada (por ejemplo: 'con-gafas' o 'sin-gafas')
    #       - names: diccionario con los nombres de todas las clases que el modelo puede detectar
    #   verbose=False: Evita que la consola se llene de mensajes en cada fotograma
    try:
        resultados = modelo.predict(source=frame, verbose=False, conf=0.50)
    except Exception as e:
        print(f"⚠ Error durante la predicción: {e}")
        continue

    # Variables para almacenar información de detecciones
    num_detecciones = 0
    personas_sin_gafas = 0

    # 3c. Recorremos cada objeto detectado (gafas, casco...) en el frame
    #     resultado.boxes contiene todas las cajas delimitadoras (rectángulos)
    #     de los objetos detectados por el modelo en esta imagen.
    for resultado in resultados:
        for caja in resultado.boxes:

            # 3c-i. Confianza de la detección
            #      Indica cuán seguro está el modelo de que este objeto pertenece
            #      a la clase detectada. Va de 0.0 (muy inseguro) a 1.0 (muy seguro).
            confianza = float(caja.conf[0])

            # 3c-ii. Filtramos detecciones poco confiables (ya hecho en conf=0.50 arriba)
            if confianza < 0.50:
                continue

            # 3c-iii. Nombre de la clase detectada
            #        Por ejemplo: "person", "safety-glasses", etc.
            #        resultado.names[int(caja.cls[0])] traduce el índice de clase
            #        que da el modelo a un nombre legible.
            clase = resultado.names[int(caja.cls[0])].lower()

            # 3c-iv. Coordenadas del rectángulo que rodea al objeto detectado
            #        xyxy[0] devuelve [x1, y1, x2, y2] en píxeles
            #        x1, y1 = esquina superior izquierda
            #        x2, y2 = esquina inferior derecha
            x1, y1, x2, y2 = map(int, caja.xyxy[0])

            num_detecciones += 1

            # 3d. Determinamos el color y el mensaje según la clase detectada
            #     Verde → lleva gafas de seguridad / elementos de protección
            #     Rojo   → no lleva gafas de seguridad / falta EPI
            if "safety" in clase or "goggles" in clase or "helmet" in clase or "glove" in clase:
                color   = (0, 200, 80)           # Verde ✔
                mensaje = f"CON EPI: {clase.replace('-', ' ').title()} ({confianza:.0%})"
            elif "no-safety" in clase or "no-goggles" in clase or "no-helmet" in clase:
                color   = (0, 60, 220)           # Rojo ✘
                mensaje = f"SIN {clase.replace('no-', '').replace('-', ' ').upper()} ({confianza:.0%})"
                personas_sin_gafas += 1
            else:
                color   = (200, 200, 0)         # Cian (neutral)
                mensaje = f"{clase.replace('-', ' ').title()} ({confianza:.0%})"

            # 3e. Dibujamos el rectángulo sobre la persona detectada
            #     cv2.rectangle(imagen, esquina_sup_izq, esquina_inf_der, color, grosor)
            cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)

            # 3f. Escribimos el mensaje encima del rectángulo
            #     cv2.putText(imagen, texto, posición, tipo_fuente, tamaño, color, grosor)
            #     Se coloca justo encima del rectángulo para no tapar la cara
            cv2.putText(frame, mensaje, (x1, y1 - 10),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.6, color, 2)

    # 3g. Mostrar estadísticas en la esquina superior izquierda
    info_text = f"Frames: {contador_frames} | Detecciones: {num_detecciones}"
    if personas_sin_gafas > 0:
        info_text += f" | ⚠ SIN GAFAS: {personas_sin_gafas}"
    
    cv2.putText(frame, info_text, (10, 30),
                cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 1)
    
    # 3h. Mostramos el fotograma procesado en una ventana
    #     - cv2.imshow(nombre_ventana, imagen) abre o actualiza una ventana con la imagen pasada
    #     - Cada iteración del bucle reemplaza la imagen anterior por el último frame procesado
    cv2.imshow("SentinelVision - Detector de Gafas de Seguridad", frame)

    # 3i. Comprobamos si el usuario ha pulsado la tecla Q para salir
    #     - cv2.waitKey(1) espera 1 milisegundo y devuelve el código de la tecla pulsada
    #     - & 0xFF se usa para asegurar compatibilidad entre diferentes sistemas operativos
    #     - ord('q') convierte la letra 'q' en su código ASCII
    if cv2.waitKey(1) & 0xFF == ord('q'):
        print("\n🛑 Saliendo del programa...")
        break

# ─────────────────────────────────────────────
# 4. LIBERAMOS LOS RECURSOS AL TERMINAR
#    Siempre debemos cerrar correctamente la cámara y las ventanas de OpenCV
#    para evitar que queden bloqueadas y permitir que otras aplicaciones
#    puedan usar la cámara posteriormente.
#    
#    - camara.release() → libera la cámara y deja de capturar video
#    - cv2.destroyAllWindows() → cierra todas las ventanas abiertas por OpenCV
#    - print(...) → informa al usuario que el programa terminó correctamente
# ─────────────────────────────────────────────
camara.release()
cv2.destroyAllWindows()
print(f"✓ Programa finalizado. Se procesaron {contador_frames} frames.")
