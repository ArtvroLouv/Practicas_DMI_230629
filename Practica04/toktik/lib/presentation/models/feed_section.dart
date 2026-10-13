/// Secciones del feed principal, en el orden en que aparecen en la barra superior.
enum FeedSection {
  forYou('Para ti'),
  nearYou('Cerca de ti'),
  discover('Descubrir'),
  favorites('Favoritos');

  const FeedSection(this.label);

  /// Texto que se muestra en la barra superior.
  final String label;
}
