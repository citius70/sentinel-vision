"""
=============================================================
  DETECTOR DE GAFAS DE SEGURIDAD EN PUESTOS DE TRABAJO
  Nivel: 2º Bachillerato
  Tecnologías: Python + OpenCV + YOLOv8
=============================================================
"""

# Importamos la biblioteca OpenCV.
# Se utiliza para trabajar con imágenes y vídeo (leer imágenes, mostrar vídeo, procesar frames, etc.)
import cv2

# Importamos la clase YOLO desde la biblioteca ultralytics.
# Esta clase permite cargar y utilizar modelos YOLO (You Only Look Once)
# para tareas de visión artificial como detección de objetos, segmentación o seguimiento.
from ultralytics import YOLO

# ─────────────────────────────────────────────
#  1. CARGAMOS EL MODELO DE INTELIGENCIA ARTIFICIAL
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
#       - no_goggles, no_helmet, etc. → indica que la
#         persona no lleva ese elemento de protección.
#
#     El modelo se descarga automáticamente desde
#     Ultralytics Hub la primera vez que se ejecuta.
# ─────────────────────────────────────────────
modelo = YOLO.from_pretrained("keremberke/yolov8n-protective-equipment-detection")

# ─────────────────────────────────────────────
# 2. INICIALIZAMOS LA CÁMARA
#    Intentamos abrir primero la cámara principal del ordenador(0).
#    Si no está disponible, probamos con la segunda conectada a él (webcam) (1).
# ─────────────────────────────────────────────
camara = cv2.VideoCapture(0)  # cámara principal

if not camara.isOpened():
    print("Cámara principal no encontrada, intentando con la segunda cámara...")
    camara.release()
    camara = cv2.VideoCapture(1)

if not camara.isOpened():
    raise RuntimeError("No se pudo abrir ni la cámara principal ni la segunda.")
else:
    print("Cámara iniciada. Pulsa Q para salir.")

# ─────────────────────────────────────────────
# 3. BUCLE PRINCIPAL
#    Se ejecuta continuamente, fotograma a fotograma,
#    hasta que el usuario pulse la tecla Q para salir.
# ─────────────────────────────────────────────
while True:

    # 3a. Leemos un fotograma de la cámara gracias a la librería OpenCV
    #     ret = True si la captura fue correcta
    #     frame = la imagen capturada por la cámara
    #           Qué contiene frame: Es un array de 3 dimensiones: (alto, ancho, canales)
    #               alto = número de filas de píxeles
    #               ancho = número de columnas de píxeles
    #               canales = 3 (para imágenes en color BGR) | 2 (para cámaras en blanco y negro)
    #     Por ejemplo, si tu cámara captura video a 640×480 píxeles, el shape sería: 480 x 640 x 3
    ret, frame = camara.read()

    # Si no se pudo leer el fotograma, avisa y sale del bucle while.
    if not ret:
        print("Error: no se puede leer la cámara.")
        break

    # 3b. Pasamos el fotograma al modelo de detección
    #     El modelo analiza la imagen y devuelve información sobre los objetos detectados.
    #     
    #     resultados es una lista de objetos, donde cada objeto contiene:
    #       - boxes: lista de cajas delimitadoras (rectángulos) de los objetos detectados
    #       - conf: confianza de cada detección (0.0 = inseguro, 1.0 = seguro)
    #       - cls: clase detectada (por ejemplo: 'con-gafas' o 'sin-gafas')
    #       - names: diccionario con los nombres de todas las clases que el modelo puede detectar
    #   verbose=False: Evita que la consola se llene de mensajes en cada fotograma, especialmente si estás procesando video en tiempo real.
    resultados = modelo.predict(source=frame, verbose=False)

    # 3c. Recorremos cada objeto detectado (gafas, casco...) en el frame
    #     resultado.boxes contiene todas las cajas delimitadoras (rectángulos)
    #     de los objetos detectados por el modelo en esta imagen.
    for resultado in resultados:
        for caja in resultado.boxes:

            # 3c-i. Confianza de la detección
            #      Indica cuán seguro está el modelo de que este objeto pertenece
            #      a la clase detectada. Va de 0.0 (muy inseguro) a 1.0 (muy seguro).
            confianza = float(caja.conf[0])

            # 3c-ii. Filtramos detecciones poco confiables
            #       Si la confianza es menor al 50%, ignoramos esta detección.
            if confianza < 0.50:
                continue  # pasa a la siguiente caja

            # 3c-iii. Nombre de la clase detectada
            #        Por ejemplo: "con-gafas" o "sin-gafas"
            #        resultado.names[int(caja.cls[0])] traduce el índice de clase
            #        que da el modelo a un nombre legible.
            clase = resultado.names[int(caja.cls[0])].lower()

            # 3c-iv. Coordenadas del rectángulo que rodea al objeto detectado
            #        xyxy[0] devuelve [x1, y1, x2, y2] en píxeles
            #        x1, y1 = esquina superior izquierda
            #        x2, y2 = esquina inferior derecha
            x1, y1, x2, y2 = map(int, caja.xyxy[0])

            # 3d. Determinamos el color y el mensaje según la clase detectada
            #     Verde → lleva gafas de seguridad
            #     Rojo   → no lleva gafas de seguridad
            if "safety" in clase or "glasses" in clase:
                color   = (0, 200, 80)           # Verde ✔
                mensaje = f"CON gafas ({confianza:.0%})"
            else:
                color   = (0, 60, 220)           # Rojo ✘
                mensaje = f"SIN gafas ({confianza:.0%})"

            # 3e. Dibujamos el rectángulo sobre la persona detectada
            #     cv2.rectangle(imagen, esquina_sup_izq, esquina_inf_der, color, grosor)
            cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)

            # 3f. Escribimos el mensaje encima del rectángulo
            #     cv2.putText(imagen, texto, posición, tipo_fuente, tamaño, color, grosor)
            #     Se coloca justo encima del rectángulo para no tapar la cara
            cv2.putText(frame, mensaje, (x1, y1 - 10),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.7, color, 2)

    # 3g. Mostramos el fotograma procesado en una ventana
    #     - cv2.imshow(nombre_ventana, imagen) abre o actualiza una ventana con la imagen pasada
    #     - Cada iteración del bucle reemplaza la imagen anterior por el último frame procesado
    cv2.imshow("Detector de Gafas de Seguridad", frame)

    # 3h. Comprobamos si el usuario ha pulsado la tecla Q para salir
    #     - cv2.waitKey(1) espera 1 milisegundo y devuelve el código de la tecla pulsada
    #     - & 0xFF se usa para asegurar compatibilidad entre diferentes sistemas operativos
    #     - ord('q') convierte la letra 'q' en su código ASCII
    if cv2.waitKey(1) & 0xFF == ord('q'):
        print("Saliendo del bucle...")
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
print("Programa finalizado.")