import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia_app/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia_app/infrastructure/respositories/movie_respository_impl.dart';

class MoviesNotifier extends StateNotifier<List<Movie>> {
  final MovieRepositoryImpl movieRepository;

  MoviesNotifier({required this.movieRepository}) : super([]) {
    loadNextPage();
  }

  Future<void> loadNextPage() async {
    final movies = await movieRepository.getNowPlaying();
    state = [...state, ...movies];
  }
}
