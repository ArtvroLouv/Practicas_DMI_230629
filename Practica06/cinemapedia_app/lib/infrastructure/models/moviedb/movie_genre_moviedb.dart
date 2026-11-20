import 'package:cinemapedia_app/domain/entities/movie_genre.dart';

class MovieGenreMovieDB {
  const MovieGenreMovieDB({required this.id, required this.name});

  final int id;
  final String name;

  factory MovieGenreMovieDB.fromJson(Map<String, dynamic> json) =>
      MovieGenreMovieDB(
        id: (json['id'] as num?)?.toInt() ?? 0,
        name: json['name'] as String? ?? '',
      );

  MovieGenre toEntity() => MovieGenre(id: id, name: name);
}
