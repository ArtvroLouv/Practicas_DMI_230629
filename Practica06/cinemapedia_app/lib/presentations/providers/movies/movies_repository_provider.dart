import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia_app/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia_app/infrastructure/respositories/movie_respository_impl.dart';

final movieRepositoryProvider = Provider((ref) {
  final movieDatasource = MoviedbDatasource();
  return MovieRepositoryImpl(datasource: movieDatasource);
});