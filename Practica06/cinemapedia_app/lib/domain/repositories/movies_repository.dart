import 'package:cinemapedia_app/domain/entities/movie.dart';

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

  Future<String?> getMovieCertification({
    required int movieId,
    required String region,
  });
}
