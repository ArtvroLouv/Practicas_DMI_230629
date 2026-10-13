# TokTik - Next-Gen Vertical Video Feed

**TokTik** es una aplicación móvil de desarrollo vertical inspirada en plataformas modernas de video corto, construida con **Flutter**. Este proyecto implementa arquitectura limpia, gestión de estado con Provider, consumo de APIs mediante Dio, reproducción multimedia avanzada con `audioplayers` y `video_player`, y un **sistema de branding estacional dinámico** que adapta automáticamente la identidad visual, los colores y los sonidos de la aplicación según la temporada del año.

---

## Links

[Arquitectura](https://artvrolouv.github.io/Practicas_DMI_230629/Practica04/toktik/arquitectura_toktik_pro_final.html)

[App en Appetize](https://appetize.io/app/b_i2wyf57f6nvg6gmyqnkw3ckdyy)

---

## Características Principales

* **Sistema de Branding Estacional (Dynamic Theming):** Cambia automáticamente los recursos visuales (iconos, logos, paleta de colores neón y audios del Splash Screen) basándose en fechas festivas y conmemorativas:
  * *Aniversario* (Octubre)
  * *Halloween / Día de Muertos* (Octubre - Noviembre)
  * *Navidad* (Diciembre - Enero)
  * *San Valentín* (Febrero)
  * *Tema Normal* (Resto del año)
* **Pantalla de Carga Interactiva (Splash Screen):** Animaciones fluidas, indicadores de progreso dinámicos y efectos de audio adaptados a cada temporada.
* **Feed Vertical Multisección:** Navegación superior optimizada entre distintas categorías (*Para ti*, *Cerca de ti*, *Descubrir* y *Favoritos*).
* **Multimedia Integrada:** Reproducción fluida de video vertical y efectos de audio inmersivos con manejo robusto de errores y ciclos de vida.
* **Inicialización Segura:** Gestión de variables de entorno mediante `flutter_dotenv` y control estricto de orientación y estados de carga.

---

## Capturas de Pantalla de la Aplicación

| 1. Splash Screen Estacional | 2. Feed "Para ti" | 3. Sección "Cerca de ti" |
| :---: | :---: | :---: |
| ![Splash Screen](/capturas/1.jpg) | ![Feed Para ti](/capturas/2.jpg) | ![Cerca de ti](/capturas/3.jpg) |
| *Pantalla de carga con animación y branding dinámico* | *Vista principal de videos verticales* | *Exploración de contenido local* |

| 4. Explorar / Descubrir | 5. Favoritos |
| :---: | :---: |
| ![Descubrir](/capturas/4.jpg) | ![Favoritos](/capturas/5.jpg) |
| *Sección de descubrimientos multimedia* | *Gestión de videos guardados* |


---

## Tecnologías y Paquetes Utilizados

* **Framework:** [Flutter](https://flutter.dev) (Dart SDK ^3.10.4)
* **Gestión de Estado:** `provider`
* **Multimedia:** `video_player`, `audioplayers`
* **Redes y Datos:** `dio`, `flutter_dotenv`, `shared_preferences`
* **Interfaz y Animaciones:** `google_fonts`, `animate_do`, `intl`
* **Herramientas de desarrollo:** `flutter_launcher_icons`

