import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {
  static const _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  static Movie movieDBToEntity(MovieMovieDB movie) => Movie(
    adult: movie.adult,
    backdropPath: _imageUrl(movie.backdropPath),
    genreIds: movie.genreIds,
    id: movie.id,
    originalLanguage: movie.originalLanguage,
    originalTitle: movie.originalTitle,
    overview: movie.overview,
    popularity: movie.popularity,
    posterPath: _imageUrl(movie.posterPath),
    releaseDate: movie.releaseDate,
    title: movie.title,
    video: movie.video,
    voteAverage: movie.voteAverage,
    voteCount: movie.voteCount,
  );

  static String _imageUrl(String path) =>
      path.isEmpty ? 'no-poster' : '$_imageBaseUrl$path';
}
