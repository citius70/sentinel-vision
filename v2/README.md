# SentinelVision: Visor de Seguridad Inteligente (v1.2.0)

Este proyecto es una herramienta de **Visión Artificial** diseñada para entornos industriales o académicos. Su objetivo principal es la **prevención de riesgos laborales mediante la monitorización en tiempo real del uso de equipos de protección  individual (EPIs) oculares**, conocidas comunmente como **gafas de seguridad**. En próximas versiones se incorporará la detección falta de cascos  de seguridad, ode distracciones, como el uso de teléfonos móviles, en puestos de trabajo (torno, banco de trabajo, fresadora, etc.).

El sistema ha sido elaborado por los alumnos de **2º de Bachillerato** como parte de su formación en la materia de **Tecnologías de la Información y la Comunicación II (TIC II)**, bajo la supervisión del profesor **Alberto Durán Pérez**.

La elección del nombre **SentinelVision** se debe a ue se quería reflejar la dualidad de nuestro sistema: la capacidad técnica de la **Visión Artificial** (el cerebro que analiza los fotogramas) combinada con el rol de un **Centinela** (el guardián que previene riesgos de forma ininterrumpida).

---

## 1. Descripción técnica

* El software ha sido desarrollado utilizando la arquitectura de red neuronal artificial (*neuronal network*) de última generación **YOLOv8** de Ultralytics, optimizada para la detección de objetos en tiempo real con alta precisión. Este sistema es utilizado en múltiples aplicaciones como la conducción autónoma de vehículos, análisis de virus en imágenes médicas, o sistemas de seguridad y vigilancia. En este caso, se ha entrenado específicamente para detectar la presencia o ausencia de gafas de seguridad en el rostro de los operarios, lo que permite identificar situaciones de riesgo laboral de forma inmediata.
* La lógica del sistema está implementada en **Python**, utilizando la librería **OpenCV** para el procesamiento de flujo de video y la visualización gráfica de alertas.


---

## 2. Tecnologías utilizadas

El proyecto se fundamenta en un ecosistema de **código abierto**:

* **Python:** Lenguaje de programación principal para la lógica del sistema.
* **Ultralytics YOLOv8:** Arquitectura de red neuronal de última generación para la detección de objetos.
* **OpenCV (`cv2`):** Biblioteca esencial para el procesamiento de flujo de video y visualización gráfica.
* **Sistemas Operativos:** Optimizado para entornos Windows y Linux (Ubuntu/Debian).

---

## 3. Desafíos y objetivos alcanzados

### 3.1. Curva de Aprendizaje y Complejidad

El desarrollo de **SentinelVision** ha representado un reto de **dificultad media-alta** para el nivel de 2º de Bachillerato. Integrar conceptos de Inteligencia Artificial, gestión de redes neuronales artificiale y procesamiento de vídeo en tiempo real requiere una base técnica sólida y una capacidad de resolución de problemas avanzada.

### 3.2. El ecosistema Python como facilitador

A pesar de la complejidad teórica del proyecto, el **nivel de comprensión del equipo ha sido muy alto**. Esto ha sido posible gracias a la naturaleza del lenguaje **Python**, lenguaje de programación que ha sido trabajado a lo largo de curso. Asimismo, algunas de las más de 100.000 librerías importantes de Python han sido tratadas, entre ellas, OpenCV.

* **Abstracción y Legibilidad:** Python nos ha permitido centrarnos en la lógica de seguridad y la resolución de problemas en el taller de mecanizado, sin perdernos en una sintaxis excesivamente compleja.
* **Potencia de las Librerías (OpenCV):** El núcleo del proyecto se apoya en la potencia de **OpenCV**, una librería con miles de funciones que facilitan el tratamiento de imágenes. Entender cómo Python articula estas herramientas ha sido la clave para que un grupo de alumnos de Bachillerato pueda implementar tecnología que, hace pocos años, era exclusiva de centros de investigación o grandes empresas.

### 3.3. Integración de hardware y software

Uno de los mayores desafíos fue la transición del "código en el papel" a la "realidad del taller". Ajustar la detección para que funcionara con las condiciones lumínicas reales de las máquinas herramienta y gestionar los permisos de cámara en distintos sistemas operativos (Windows/Linux) fueron obstáculos que requirieron un proceso de **ensayo y error** fundamental para nuestra formación técnica.

### 3.4. El desafío de la automatización: Scripts de despliegue

Una de las mayores dificultades técnicas encontradas fue la elaboración de los archivos `instalador.bat` (Windows) y `instalador.sh` (Linux). Este proceso requiere conocimientos previos de Scripting de Sistemas y automatización de terminal, un área que no forma parte de los contenidos curriculares de 2º de Bachillerato.

* **Complejidad:** Gestionar variables de entorno, verificar versiones de Python mediante comandos de consola y automatizar la instalación de dependencias externas supuso un reto de lógica de programación fuera del estándar de la asignatura.

* **Aprendizaje:** A pesar de ser una competencia avanzada, con la guía del profesor, el equipo ha logrado interiorizar "lo mollar" (la esencia) de estos scripts: entender cómo el software interactúa directamente con el sistema operativo para configurarse de forma autónoma.

* **Resultado:** El esfuerzo invertido permite que SentinelVision sea ahora una herramienta accesible mediante un solo clic, eliminando la barrera técnica para el usuario final en los talleres de mecanizado.

---

## 4. Estructura del proyecto

Copiar y pegar los archivos del proyecto en una carpeta de tu elección (por ejemplo, `C:\SentinelVision` en Windows o `~/SentinelVision` en Linux) y asegúrate de mantener la siguiente estructura:


```text
├── safety_glasses_detector.py  # Programa principal de detección y lógica.
├── requirements.txt            # Dependencias necesarias para el entorno.
├── instalador.bat              # Automatización para despliegue en Windows.
├── instalador.sh               # Automatización para despliegue en Linux.
└── README.md                   # Documentación del proyecto.

```
---

## 5. Instalación paso a paso

### 5.1. Entorno Windows

1. **Verificación inicial:** Abre una terminal (CMD) y escribe `python --version`

   * Si no tienes Python instalado o es una versión anterior a la 3.12, descárgalo desde [python.org](https://www.python.org/downloads/).
   * **¡Importante!** Durante la instalación, asegúrate de marcar la casilla **"Add Python to PATH"**.


2. **Preparación:** Copia los archivos del proyecto en una carpeta de fácil acceso (por ejemplo, `C:\SentinelVision`).
3. **Instalación:** Navega a la carpeta del proyecto y haz doble clic en **`instalador.bat`**.
4. **Configuración:** El script verificará tu versión, instalará las librerías necesarias (`opencv-python` y `ultralytics`) y preparará el entorno automáticamente.
5. **Ejecución:** Al finalizar la instalación, pulsa la tecla **'s'** para lanzar **SentinelVision**.


### 5.2. Entorno Linux (Ubuntu/Debian)

1. **Abrir la terminal:** Navega hasta la carpeta raíz del proyecto.
2. **Permisos:** Otorga permisos de ejecución al script mediante:
```bash
chmod +x instalador.sh

```


3. **Ejecución:** Inicia la instalación con:
```bash
./instalador.sh

```


4. **Configuración de Hardware:** Si el sistema devuelve un error de acceso a la cámara (`/dev/video*`), asegúrate de que tu usuario tenga permisos de acceso añadiéndolo al grupo `video`:
```bash
sudo usermod -aG video $USER

```


*Nota: Es necesario cerrar sesión y volver a entrar (o reiniciar) para que los cambios en los permisos se apliquen correctamente.*

---


## 6. Funcionamiento técnico

El sistema funciona mediante **inferencia en tiempo real**, es decir, **analiza cada fotograma capturado por la webcam** utilizando un modelo de detección previamente entrenado como es YOLO version 8 (YOLOv8). Esto lo hace más rápido y eficiente que otros modelos que se basan en la comparación continua con enormes bases de datos.  El proceso se puede desglosar en las siguientes etapas:

1. **Captura:** La webcam adquiere fotogramas del entorno laboral, que son procesados en tiempo real. Unos 25-30 fotogramas por segundo (FPS) es un rendimiento típico para este tipo de aplicaciones, aunque puede variar según el hardware y la complejidad del modelo, pudiendo alcanzar hasta 60 FPS en sistemas más potentes.
2. **Procesamiento:** El modelo YOLOv8 analiza los fotogramas basándose en "pesos" matemáticos pre-entrenados.
3. **Filtrado:** Se aplica un umbral de confianza (confidence threshold) del 50%. Este parámetro es crítico para la fiabilidad del sistema: garantiza que solo se reporten las detecciones donde la red neuronal tiene una certeza superior al 50%, lo que reduce drásticamente la aparición de "falsos positivos" (alertas erróneas sobre objetos que no son el objetivo de seguridad), por ejemplo, en entornos con poca iluminación o con objetos similares a las gafas de seguridad.
Aumentar este umbral, por ejemplo, al 80%, significaría endurecer los criterios de detección, lo que podría resultar en una reducción de las alertas falsas pero también en un aumento de las "falsas negativas" (situaciones donde el sistema no detecta un riesgo real). Por lo tanto, es importante encontrar un equilibrio adecuado para cada entorno específico.
4. **Visualización:** Se dibuja un recuadro dinámico (BBox) en las caras detectadas con colores según el estado:
   * **Verde:** Seguridad confirmada = Operario con gafas de seguridad.
   * **Rojo:** Incumplimiento de norma / Peligro = Operario sin gafas de seguridad.
5. **Alertas:** En caso de detección de riesgo, se muestra un mensaje de alerta en la parte superior del video, indicando el tipo de riesgo y el nivel de confianza (por ejemplo, "Alerta: Sin gafas de seguridad (85% seguro)").
   * En próximas versiones se añadirá la capacidad de hacer sonar una alarma si transcurridos unos segundos el operario sigue sin usar las gafas de seguridad, para aumentar la efectividad de la herramienta en entornos industriales.


---

### 7. Personalización de Modelos

Aunque **SentinelVision** ha sido diseñado con una arquitectura modular que permite escalar a otros elementos de seguridad, en esta versión (**v1.2.0**) el sistema está configurado y optimizado específicamente para la detección de **gafas de seguridad**.

| Objeto a detectar      | Modelo configurado                  | Estado en Sentinel v1.2.0 |
| ---------------------- | ----------------------------------- | ------------------------- |
| **Gafas de seguridad** | `keremberke/yolov8n-safety-glasses` | **Activo**                |
| **Cascos de obra**     | `keremberke/yolov8n-hard-hat`       | *en versiones futuras*    |
| **Teléfonos móviles**  | `yolov8n.pt`                        | *en vesiones futuras*     |

> Nota: La estructura del código permite añadir los modelos de cascos y móviles simplemente sustituyendo la ruta del modelo y activando la lógica de filtrado correspondiente.

Incluso el programa podrá mejorarse en su detección "entrenándolo" con fotografías reales de los alummos/operarios que utilicen el puesto de trabajo, con y sin los modelos/marcas de las gafas de seguridad propias del taller. Esto aumentará la precisión y reducirá los falsos positivos, adaptando el sistema a las condiciones específicas del entorno laboral.

---

## 8. Conclusión

**SentinelVision** representa un avance significativo en la aplicación de la visión artificial para la seguridad laboral, ofreciendo una herramienta accesible y efectiva para la monitorización del uso de gafas de seguridad. Su diseño modular y escalable garantiza que futuras versiones puedan incorporar detección de otros EPIs y riesgos, consolidando su posición como una solución integral para la prevención de accidentes en entornos industriales y académicos.


---

## 9. Autores y Créditos

Este proyecto ha sido desarrollado por los alumnos de **2º de Bachillerato B y C** de la asignatura de **Tecnologías de la Información y de la Comunicación" II** como parte del programa de formación técnica en Inteligencia Artificial y Visión Artificia
* **Equipo de Desarrollo:** [Inserta aquí vuestros nombres/iniciales]
* **Supervisión y Tutoría:** Profesor **Alberto Durán Pérez**
* **Institución:** IES Frei Martín Sarmiento - Pontevedra


---

## 10. Validación en entorno real

**SentinelVision** no es solo un proyecto teórico; ha sido validado en condiciones de trabajo reales dentro del centro educativo.

* **Ubicación:** Talleres del **Ciclo Formativo de Grado Medio y Superior de Mecanizado**.
* **Colaboración técnica:** El sistema ha sido testado en entornos con maquinaria en funcionamiento, gracias a la estrecha colaboración con el profesor del Departamenton de Mecanizado **Héctor**, quien facilitó la integración y las pruebas de detección en los puestos de trabajo.
* **Aprobación:** El despliegue de las pruebas y la validación del sistema en el entorno de taller ha contado con la supervisión y aprobación del **Jefe de Departamento, Paco Alján**, asegurando el cumplimiento de las normativas de seguridad del taller.

---
 # 11. Licencia

El código base de **SentinelVision** utiliza bibliotecas de código abierto bajo licencia **MIT** y **AGPL-3.0**. Además se ahan empleado modelos pre-entrenados de *keremberke* por facilitar el acceso a herramientas de visión artificial de vanguardia.

---
