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
}
