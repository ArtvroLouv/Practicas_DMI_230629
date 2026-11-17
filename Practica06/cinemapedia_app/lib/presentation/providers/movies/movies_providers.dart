import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/domain/repositories/movies_repository.dart';
import 'package:cinemapedia_app/config/constants/app_country.dart';
import 'package:cinemapedia_app/presentation/providers/country_provider.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider =
    AsyncNotifierProvider<NowPlayingMoviesNotifier, List<Movie>>(
      NowPlayingMoviesNotifier.new,
    );
final popularMoviesProvider =
    AsyncNotifierProvider<PopularMoviesNotifier, List<Movie>>(
      PopularMoviesNotifier.new,
    );
final upcomingMoviesProvider =
    AsyncNotifierProvider<UpcomingMoviesNotifier, List<Movie>>(
      UpcomingMoviesNotifier.new,
    );
final topRatedMoviesProvider =
    AsyncNotifierProvider<TopRatedMoviesNotifier, List<Movie>>(
      TopRatedMoviesNotifier.new,
    );

abstract class MoviesNotifier extends AsyncNotifier<List<Movie>> {
  int _currentPage = 0;
  bool _isLoadingNextPage = false;
  bool _hasMorePages = true;

  Future<List<Movie>> fetchMovies(
    MoviesRepository repository, {
    required int page,
    required AppCountry country,
  });

  @override
  Future<List<Movie>> build() async {
    final country = ref.watch(selectedCountryProvider);
    _currentPage = 1;
    _hasMorePages = true;
    return fetchMovies(
      ref.watch(movieRepositoryProvider),
      page: _currentPage,
      country: country,
    );
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
    final nextPage = _currentPage + 1;

    try {
      final nextMovies = await fetchMovies(
        ref.read(movieRepositoryProvider),
        page: nextPage,
        country: ref.read(selectedCountryProvider),
      );
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

class NowPlayingMoviesNotifier extends MoviesNotifier {
  @override
  Future<List<Movie>> fetchMovies(
    MoviesRepository repository, {
    required int page,
    required AppCountry country,
  }) {
    return repository.getNowPlaying(
      page: page,
      region: country.regionCode,
      language: '${country.languageCode}-${country.regionCode}',
    );
  }
}

class PopularMoviesNotifier extends MoviesNotifier {
  @override
  Future<List<Movie>> fetchMovies(
    MoviesRepository repository, {
    required int page,
    required AppCountry country,
  }) {
    return repository.getPopular(
      page: page,
      region: country.regionCode,
      language: '${country.languageCode}-${country.regionCode}',
    );
  }
}

class UpcomingMoviesNotifier extends MoviesNotifier {
  @override
  Future<List<Movie>> fetchMovies(
    MoviesRepository repository, {
    required int page,
    required AppCountry country,
  }) {
    return repository.getUpcoming(
      page: page,
      region: country.regionCode,
      language: '${country.languageCode}-${country.regionCode}',
    );
  }
}

class TopRatedMoviesNotifier extends MoviesNotifier {
  @override
  Future<List<Movie>> fetchMovies(
    MoviesRepository repository, {
    required int page,
    required AppCountry country,
  }) {
    return repository.getTopRated(
      page: page,
      region: country.regionCode,
      language: '${country.languageCode}-${country.regionCode}',
    );
  }
}
