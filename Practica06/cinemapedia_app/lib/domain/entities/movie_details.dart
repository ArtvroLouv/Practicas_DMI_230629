import 'movie.dart';

class MovieDetails {
  const MovieDetails({
    required this.movie,
    required this.tagline,
    required this.runtime,
    required this.genres,
  });

  final Movie movie;
  final String tagline;
  final int? runtime;
  final List<String> genres;
}
