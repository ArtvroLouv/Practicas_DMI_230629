import 'package:cinemapedia_app/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/domain/entities/movie_details.dart';
import 'package:cinemapedia_app/domain/entities/movie_genre.dart';
import 'package:cinemapedia_app/domain/repositories/movies_repository.dart';

class MovieRepositoryImpl extends MoviesRepository {
  final MoviesDatasource datasource;

  MovieRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getNowPlaying({
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  }) {
    return datasource.getNowPlaying(
      page: page,
      region: region,
      language: language,
    );
  }

  @override
  Future<List<Movie>> getPopular({
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  }) {
    return datasource.getPopular(
      page: page,
      region: region,
      language: language,
    );
  }

  @override
  Future<List<Movie>> getUpcoming({
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  }) {
    return datasource.getUpcoming(
      page: page,
      region: region,
      language: language,
    );
  }

  @override
  Future<List<Movie>> getTopRated({
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  }) {
    return datasource.getTopRated(
      page: page,
      region: region,
      language: language,
    );
  }

  @override
  Future<List<Movie>> searchMovies({
    required String query,
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  }) {
    return datasource.searchMovies(
      query: query,
      page: page,
      region: region,
      language: language,
    );
  }

  @override
  Future<List<MovieGenre>> getGenres({String language = 'es-MX'}) {
    return datasource.getGenres(language: language);
  }

  @override
  Future<List<Movie>> getMoviesByGenre({
    required int genreId,
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  }) {
    return datasource.getMoviesByGenre(
      genreId: genreId,
      page: page,
      region: region,
      language: language,
    );
  }

  @override
  Future<MovieDetails> getMovieDetails({
    required int movieId,
    String language = 'es-MX',
  }) {
    return datasource.getMovieDetails(movieId: movieId, language: language);
  }

  @override
  Future<String?> getMovieCertification({
    required int movieId,
    required String region,
  }) {
    return datasource.getMovieCertification(movieId: movieId, region: region);
  }
}
