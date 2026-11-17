import 'package:dio/dio.dart';

import 'package:cinemapedia_app/config/constants/environment.dart';
import 'package:cinemapedia_app/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/moviedb_response.dart';

class MoviedbDatasource extends MoviesDatasource {
  MoviedbDatasource({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://api.themoviedb.org/3',
              queryParameters: {'api_key': Environment.theMovieDbKey},
            ),
          );

  final Dio _dio;
  final Map<(int, String), Future<String?>> _certificationCache = {};

  @override
  Future<List<Movie>> getNowPlaying({
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  }) {
    return _getMovies(
      '/movie/now_playing',
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
    return _getMovies(
      '/movie/popular',
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
    return _getMovies(
      '/movie/upcoming',
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
    return _getMovies(
      '/movie/top_rated',
      page: page,
      region: region,
      language: language,
    );
  }

  Future<List<Movie>> _getMovies(
    String endpoint, {
    required int page,
    required String region,
    required String language,
  }) async {
    if (page < 1) {
      throw ArgumentError.value(page, 'page', 'Debe ser mayor que cero.');
    }

    final response = await _dio.get<Map<String, dynamic>>(
      endpoint,
      queryParameters: {'page': page, 'region': region, 'language': language},
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('TMDB devolvió una respuesta vacía.');
    }

    final movieDbResponse = MovieDbResponse.fromJson(data);
    return movieDbResponse.results.map(MovieMapper.movieDBToEntity).toList();
  }

  @override
  Future<String?> getMovieCertification({
    required int movieId,
    required String region,
  }) {
    final key = (movieId, region);
    return _certificationCache.putIfAbsent(key, () async {
      try {
        return await _fetchCertification(movieId: movieId, region: region);
      } catch (_) {
        _certificationCache.remove(key);
        rethrow;
      }
    });
  }

  Future<String?> _fetchCertification({
    required int movieId,
    required String region,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/movie/$movieId/release_dates',
    );
    final countries = response.data?['results'];
    if (countries is! List) return null;

    for (final country in countries.whereType<Map>()) {
      if (country['iso_3166_1'] != region) continue;

      final releases = country['release_dates'];
      if (releases is! List) return null;

      for (final release in releases.whereType<Map>()) {
        final certification = release['certification'];
        if (certification is String && certification.trim().isNotEmpty) {
          return certification.trim();
        }
      }
      return null;
    }

    return null;
  }
}
