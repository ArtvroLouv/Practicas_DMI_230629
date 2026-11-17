# Cinemapedia

Aplicación Flutter para explorar películas de TMDB: estrenos en cartelera,
próximamente, populares y mejor calificadas. Incluye selector de Estados Unidos,
México y Alemania; al cambiar de país también cambia el idioma, la región de
TMDB y la clasificación de edad que se muestra en el carrusel.

## Configuración

1. Copia `.env.template` a `.env`.
2. Asigna tu clave de TMDB a `THE_MOVIEDB_KEY` en `.env`.
3. Ejecuta `flutter pub get` y luego `flutter run`.

El icono de Cinemapedia está en `assets/images/cinemapedia_logo.png`.

El archivo `.env` está excluido de Git para no publicar claves. Debes crearlo
antes de compilar y configurar `THE_MOVIEDB_KEY`.

## Verificación

Ejecuta `flutter analyze` y `flutter test` desde esta carpeta.
