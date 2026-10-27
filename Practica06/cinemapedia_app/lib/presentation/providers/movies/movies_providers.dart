import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider =
    AsyncNotifierProvider<MoviesNotifier, List<Movie>>(MoviesNotifier.new);

class MoviesNotifier extends AsyncNotifier<List<Movie>> {
  int _currentPage = 0;
  bool _isLoadingNextPage = false;
  bool _hasMorePages = true;

  @override
  Future<List<Movie>> build() async {
    _currentPage = 1;
    _hasMorePages = true;
    return ref.watch(movieRepositoryProvider).getNowPlaying(page: _currentPage);
  }

  Future<void> loadNextPage() async {
    if (_isLoadingNextPage ||
        !_hasMorePages ||
        state.isLoading ||
        state.hasError) {
      return;
    }

    final currentMovies = state.value;
    if (currentMovies == null) return;

    _isLoadingNextPage = true;
    state = const AsyncLoading<List<Movie>>();
    final nextPage = _currentPage + 1;

    try {
      final nextMovies = await ref
          .read(movieRepositoryProvider)
          .getNowPlaying(page: nextPage);
      _currentPage = nextPage;
      _hasMorePages = nextMovies.isNotEmpty;
      state = AsyncData([...currentMovies, ...nextMovies]);
    } catch (error, stackTrace) {
      state = AsyncError<List<Movie>>(error, stackTrace);
    } finally {
      _isLoadingNextPage = false;
    }
  }
}
