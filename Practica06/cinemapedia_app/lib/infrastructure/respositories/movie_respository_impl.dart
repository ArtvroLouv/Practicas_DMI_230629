import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/domain/repositories/movie_repository.dart';
import 'package:cinemapedia_app/infrastructure/datasources/moviedb_datasource.dart';


class MovieRepositoryImpl extends MovieRepository {
  final MovieDatasource datasource;

  MovieRepositoryImpl({this.datasource});

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    try {
      final movies = await datasource.getNowPlaying(page: page);
      return movies;
    } catch (e) {
      throw Exception('Error al obtener las películas en cartelera: $e');
    }
  }


}