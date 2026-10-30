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
              queryParameters: {
                'api_key': Environment.theMovieDbKey,
                'language': 'es-MX',
              },
            ),
          );

  final Dio _dio;

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    return _getMovies('/movie/now_playing', page: page);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    return _getMovies('/movie/popular', page: page);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    return _getMovies('/movie/upcoming', page: page);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    return _getMovies('/movie/top_rated', page: page);
  }

  Future<List<Movie>> _getMovies(String endpoint, {required int page}) async {
    if (page < 1) {
      throw ArgumentError.value(page, 'page', 'Debe ser mayor que cero.');
    }

    final response = await _dio.get<Map<String, dynamic>>(
      endpoint,
      queryParameters: {'page': page},
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('TMDB devolvió una respuesta vacía.');
    }

    final movieDbResponse = MovieDbResponse.fromJson(data);
    return movieDbResponse.results.map(MovieMapper.movieDBToEntity).toList();
  }
}
