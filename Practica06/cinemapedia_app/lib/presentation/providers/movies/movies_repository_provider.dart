import 'package:cinemapedia_app/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia_app/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia_app/domain/repositories/movies_repository.dart';

final movieRepositoryProvider = Provider<MoviesRepository>((ref) {
  return MovieRepositoryImpl(MoviedbDatasource());
});
