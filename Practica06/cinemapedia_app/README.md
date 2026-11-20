# Cinemapedia

Aplicación Flutter para explorar películas de TMDB. Incluye estrenos en
cartelera, próximas, populares y mejor calificadas; búsqueda, detalles de
películas, exploración por género y favoritos guardados localmente. El selector
de Estados Unidos, México y Alemania actualiza el idioma y la región de TMDB,
así como la clasificación de edad del carrusel.

## Configuración

1. Copia `.env.template` a `.env`.
2. Reemplaza `your_tmdb_api_key_here` por una clave válida de TMDB en
   `THE_MOVIEDB_KEY` dentro de `.env`. El valor de ejemplo no permite cargar
   películas.
3. Ejecuta `flutter pub get` y luego `flutter run`.

La búsqueda y las consultas de películas necesitan una clave válida de TMDB.
Los favoritos se guardan en el dispositivo y no requieren conexión para
consultarse después de cargarlos.

El icono de Cinemapedia está en `assets/images/cinemapedia_logo.png`.

El archivo `.env` está excluido de Git para no publicar claves. Debes crearlo
antes de compilar y configurar `THE_MOVIEDB_KEY`.

## Verificación

Ejecuta `flutter analyze` y `flutter test` desde esta carpeta.
