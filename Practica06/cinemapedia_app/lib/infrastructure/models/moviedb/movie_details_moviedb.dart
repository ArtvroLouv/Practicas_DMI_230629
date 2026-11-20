import 'package:cinemapedia_app/domain/entities/movie_details.dart';
import 'package:cinemapedia_app/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieDetailsMovieDB {
  const MovieDetailsMovieDB({
    required this.movie,
    required this.tagline,
    required this.runtime,
    required this.genres,
  });

  final MovieMovieDB movie;
  final String tagline;
  final int? runtime;
  final List<String> genres;

  factory MovieDetailsMovieDB.fromJson(Map<String, dynamic> json) {
    final rawGenres = json['genres'];
    final genres = rawGenres is List
        ? rawGenres
              .whereType<Map>()
              .map((genre) => genre['name'])
              .whereType<String>()
              .toList()
        : <String>[];
    final rawRuntime = json['runtime'];

    return MovieDetailsMovieDB(
      movie: MovieMovieDB.fromJson({
        ...json,
        'genre_ids': rawGenres is List
            ? rawGenres.whereType<Map>().map((genre) => genre['id']).toList()
            : const [],
      }),
      tagline: json['tagline'] as String? ?? '',
      runtime: rawRuntime is num ? rawRuntime.toInt() : null,
      genres: genres,
    );
  }

  MovieDetails toEntity() => MovieDetails(
    movie: MovieMapper.movieDBToEntity(movie),
    tagline: tagline,
    runtime: runtime,
    genres: genres,
  );
}
