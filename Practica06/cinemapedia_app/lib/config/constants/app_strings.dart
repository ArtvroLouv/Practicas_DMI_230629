import 'app_country.dart';

class AppStrings {
  const AppStrings(this.country);

  final AppCountry country;

  String get appTitle => 'Cinemapedia';

  String get cinema => switch (country) {
    AppCountry.usa => 'Now playing',
    AppCountry.mexico => 'En cines',
    AppCountry.germany => 'Im Kino',
  };

  String get upcoming => switch (country) {
    AppCountry.usa => 'Coming soon',
    AppCountry.mexico => 'Próximamente',
    AppCountry.germany => 'Demnächst',
  };

  String get popular => switch (country) {
    AppCountry.usa => 'Popular',
    AppCountry.mexico => 'Populares',
    AppCountry.germany => 'Beliebt',
  };

  String get topRated => switch (country) {
    AppCountry.usa => 'Top rated',
    AppCountry.mexico => 'Mejor calificadas',
    AppCountry.germany => 'Bestbewertet',
  };

  String get thisMonth => switch (country) {
    AppCountry.usa => 'This month',
    AppCountry.mexico => 'En este mes',
    AppCountry.germany => 'Diesen Monat',
  };

  String get nowPlayingDate => switch (country) {
    AppCountry.usa => 'In theaters now',
    AppCountry.mexico => 'En cartelera',
    AppCountry.germany => 'Jetzt im Kino',
  };

  String get allTime => switch (country) {
    AppCountry.usa => 'All time',
    AppCountry.mexico => 'Desde siempre',
    AppCountry.germany => 'Allzeit',
  };

  String get settings => switch (country) {
    AppCountry.usa => 'Settings',
    AppCountry.mexico => 'Configuración',
    AppCountry.germany => 'Einstellungen',
  };

  String get countryAndLanguage => switch (country) {
    AppCountry.usa => 'Country and language',
    AppCountry.mexico => 'País e idioma',
    AppCountry.germany => 'Land und Sprache',
  };

  String get menu => switch (country) {
    AppCountry.usa => 'Open menu',
    AppCountry.mexico => 'Abrir menú',
    AppCountry.germany => 'Menü öffnen',
  };

  String get noMovies => switch (country) {
    AppCountry.usa => 'No movies available.',
    AppCountry.mexico => 'No hay películas disponibles.',
    AppCountry.germany => 'Keine Filme verfügbar.',
  };

  String get rating => switch (country) {
    AppCountry.usa => 'Rating',
    AppCountry.mexico => 'Clasificación',
    AppCountry.germany => 'Freigabe',
  };

  String get noRating => switch (country) {
    AppCountry.usa => 'Not rated',
    AppCountry.mexico => 'Sin clasificar',
    AppCountry.germany => 'Keine Angabe',
  };

  String get ratingError => switch (country) {
    AppCountry.usa => 'Could not load this rating.',
    AppCountry.mexico => 'No se pudo cargar la clasificación.',
    AppCountry.germany => 'Freigabe konnte nicht geladen werden.',
  };

  String get loadError => switch (country) {
    AppCountry.usa => 'Could not load movies.',
    AppCountry.mexico => 'No se pudieron cargar las películas.',
    AppCountry.germany => 'Filme konnten nicht geladen werden.',
  };

  String get tmdbKeyMissing => switch (country) {
    AppCountry.usa =>
      'Add a valid TMDB key to THE_MOVIEDB_KEY in the .env file, then restart the app.',
    AppCountry.mexico =>
      'Agrega una clave válida de TMDB en THE_MOVIEDB_KEY dentro de .env y reinicia la app.',
    AppCountry.germany =>
      'Füge einen gültigen TMDB-Schlüssel in THE_MOVIEDB_KEY in der .env-Datei ein und starte die App neu.',
  };

  String get tmdbKeyInvalid => switch (country) {
    AppCountry.usa =>
      'TMDB rejected the key. Check THE_MOVIEDB_KEY in .env and restart the app.',
    AppCountry.mexico =>
      'TMDB rechazó la clave. Revisa THE_MOVIEDB_KEY en .env y reinicia la app.',
    AppCountry.germany =>
      'TMDB hat den Schlüssel abgelehnt. Prüfe THE_MOVIEDB_KEY in .env und starte die App neu.',
  };

  String get connectionError => switch (country) {
    AppCountry.usa =>
      'Could not connect to TMDB. Check your internet connection and retry.',
    AppCountry.mexico =>
      'No se pudo conectar con TMDB. Revisa tu conexión a internet e inténtalo de nuevo.',
    AppCountry.germany =>
      'Keine Verbindung zu TMDB. Prüfe deine Internetverbindung und versuche es erneut.',
  };

  String get retry => switch (country) {
    AppCountry.usa => 'Retry',
    AppCountry.mexico => 'Reintentar',
    AppCountry.germany => 'Erneut versuchen',
  };

  String get home => switch (country) {
    AppCountry.usa => 'Home',
    AppCountry.mexico => 'Inicio',
    AppCountry.germany => 'Start',
  };

  String get categories => switch (country) {
    AppCountry.usa => 'Categories',
    AppCountry.mexico => 'Categorías',
    AppCountry.germany => 'Kategorien',
  };

  String get favorites => switch (country) {
    AppCountry.usa => 'Favorites',
    AppCountry.mexico => 'Favoritos',
    AppCountry.germany => 'Favoriten',
  };

  String get search => switch (country) {
    AppCountry.usa => 'Search',
    AppCountry.mexico => 'Buscar',
    AppCountry.germany => 'Suchen',
  };

  String get waiting => switch (country) {
    AppCountry.usa => 'Please wait',
    AppCountry.mexico => 'Espera un momento',
    AppCountry.germany => 'Bitte warten',
  };

  String get loading => switch (country) {
    AppCountry.usa => 'Loading movies...',
    AppCountry.mexico => 'Cargando películas...',
    AppCountry.germany => 'Filme werden geladen...',
  };

  String get searchMovies => switch (country) {
    AppCountry.usa => 'Search movies',
    AppCountry.mexico => 'Buscar películas',
    AppCountry.germany => 'Filme suchen',
  };

  String get searchHint => switch (country) {
    AppCountry.usa => 'Movie title',
    AppCountry.mexico => 'Nombre de la película',
    AppCountry.germany => 'Filmtitel',
  };

  String get noSearchResults => switch (country) {
    AppCountry.usa => 'No movies match your search.',
    AppCountry.mexico => 'No hay películas con esa búsqueda.',
    AppCountry.germany => 'Keine Filme gefunden.',
  };

  String get genresTitle => switch (country) {
    AppCountry.usa => 'Genres',
    AppCountry.mexico => 'Géneros',
    AppCountry.germany => 'Genres',
  };

  String get selectGenre => switch (country) {
    AppCountry.usa => 'Choose a genre to explore.',
    AppCountry.mexico => 'Elige un género para explorar.',
    AppCountry.germany => 'Wähle ein Genre zum Entdecken.',
  };

  String get overview => switch (country) {
    AppCountry.usa => 'Overview',
    AppCountry.mexico => 'Sinopsis',
    AppCountry.germany => 'Handlung',
  };

  String get noOverview => switch (country) {
    AppCountry.usa => 'No overview is available.',
    AppCountry.mexico => 'Sin sinopsis disponible.',
    AppCountry.germany => 'Keine Handlung verfügbar.',
  };

  String get favoriteSaveError => switch (country) {
    AppCountry.usa => 'Could not update your favorites.',
    AppCountry.mexico => 'No se pudieron actualizar tus favoritos.',
    AppCountry.germany => 'Favoriten konnten nicht aktualisiert werden.',
  };

  String get runtime => switch (country) {
    AppCountry.usa => 'min',
    AppCountry.mexico => 'min',
    AppCountry.germany => 'Min.',
  };

  String get addFavorite => switch (country) {
    AppCountry.usa => 'Add to favorites',
    AppCountry.mexico => 'Agregar a favoritos',
    AppCountry.germany => 'Zu Favoriten hinzufügen',
  };

  String get removeFavorite => switch (country) {
    AppCountry.usa => 'Remove from favorites',
    AppCountry.mexico => 'Quitar de favoritos',
    AppCountry.germany => 'Aus Favoriten entfernen',
  };

  String get favoritesEmpty => switch (country) {
    AppCountry.usa => 'Your favorite movies will appear here.',
    AppCountry.mexico => 'Tus películas favoritas aparecerán aquí.',
    AppCountry.germany => 'Deine Lieblingsfilme erscheinen hier.',
  };

  String get detailsError => switch (country) {
    AppCountry.usa => 'Could not load movie details.',
    AppCountry.mexico => 'No se pudieron cargar los detalles.',
    AppCountry.germany => 'Filmdetails konnten nicht geladen werden.',
  };
}
