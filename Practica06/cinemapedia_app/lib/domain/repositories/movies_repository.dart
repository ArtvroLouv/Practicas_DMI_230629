import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/domain/entities/movie_details.dart';
import 'package:cinemapedia_app/domain/entities/movie_genre.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getNowPlaying({
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  });

  Future<List<Movie>> getPopular({
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  });

  Future<List<Movie>> getUpcoming({
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  });

  Future<List<Movie>> getTopRated({
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  });

  Future<List<Movie>> searchMovies({
    required String query,
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  });

  Future<List<MovieGenre>> getGenres({String language = 'es-MX'});

  Future<List<Movie>> getMoviesByGenre({
    required int genreId,
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  });

  Future<MovieDetails> getMovieDetails({
    required int movieId,
    String language = 'es-MX',
  });

  Future<String?> getMovieCertification({
    required int movieId,
    required String region,
  });
}
