# REPORTE TÉCNICO Y DOCUMENTACIÓN DE PRÁCTICA
## Implementación, Compilación y Despliegue de Aplicación Móvil en Entorno Cloud (Appetize.io)

---

### 1. Datos Generales y Especificaciones del Proyecto
* **Proyecto:** Demo E-Commerce / Streetwear Store (`demo_appetize`)
* **Framework:** Flutter (Material Design 3 / Dark Theme)
* **Plataforma de Despliegue:** Appetize.io (Emulación Android Virtual en Cloud)
* **Comando de Compilación Release:** `flutter build apk --release`
* **Directorio del Ejecutable:** `build/app/outputs/flutter-apk/app-release.apk`

---

### 2. Descripción y Objetivos de la Práctica
El desarrollo consistió en la estructuración, compilación y validación de una aplicación móvil interactiva basada en Flutter, orientada a demostrar los procesos de distribución, pruebas funcionales y emulación en la nube sin requerir instalación física en dispositivos Android. La arquitectura implementada incluye navegación entre vistas, gestión de estados reactivos, pasarela de selección de atributos y un módulo de carrito de compras funcional.

---

### 3. Enlace de Acceso en Appetize.io
La aplicación se encuentra publicada y disponible para evaluación técnica en el siguiente entorno virtual:

* **URL de Ejecución Remota:** [Probar Aplicación en Appetize.io](https://appetize.io/app/b_3e37utmtlqojln32dxh5bi3zwe) *(Configurado para acceso público independiente y revisión docente)*.

---

### 4. Arquitectura y Flujo Técnico

1. **Estructura de Datos y Modelos:** Definición de clases robustas para entidades de productos e ítems de carrito con tipado estricto.
2. **Interfaz de Usuario (UI/UX):** Implementación de un esquema de diseño moderno en modo oscuro con gradientes visuales, tarjetas de elevación controlada y componentes interactivos de selección (`ChoiceChip`).
3. **Control de Estado Global:** Uso de navegación basada en retornos tipados (`Navigator.pop` con objetos de tipo `ItemCarrito`) para asegurar la sincronización exacta del contador de la bolsa y el panel desplegable de resumen (`showModalBottomSheet`).
4. **Compilación Optimizada:** Ejecución del empaquetado de liberación mediante la herramienta CLI de Flutter:
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --release