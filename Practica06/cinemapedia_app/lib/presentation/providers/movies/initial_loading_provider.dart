import 'package:cinemapedia_app/presentation/providers/movies/movies_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final nowPlaying = ref.watch(nowPlayingMoviesProvider);
  final popular = ref.watch(popularMoviesProvider);
  final upcoming = ref.watch(upcomingMoviesProvider);
  final topRated = ref.watch(topRatedMoviesProvider);

  return nowPlaying.isLoading ||
      popular.isLoading ||
      upcoming.isLoading ||
      topRated.isLoading;
});
