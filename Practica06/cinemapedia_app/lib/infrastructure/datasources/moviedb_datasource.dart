
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:dio/dio.dart';
import 'package:cinemapedia_app/config/constants/environment.dart';

class MoviedbDatasource {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX',
      },
    ),
  );

  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    try {
      final response = await dio.get(
        '/movie/now_playing',
        queryParameters: {
          'page': page,
        },
      );

      final List<dynamic> results = response.data['results'];

      // Aquí falta convertir los resultados JSON a objetos Movie.
      return [];
    } catch (e) {
      print('Error al obtener películas en cartelera: $e');
      return [];
    }
  }
}