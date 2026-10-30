import 'package:cinemapedia_app/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_slideshow_provider.dart';
import 'package:cinemapedia_app/presentation/providers/movies/initial_loading_provider.dart';
import 'package:cinemapedia_app/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const name = 'home-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(initialLoadingProvider);
    final nowPlayingState = ref.watch(nowPlayingMoviesProvider);
    final popularState = ref.watch(popularMoviesProvider);
    final upcomingState = ref.watch(upcomingMoviesProvider);
    final topRatedState = ref.watch(topRatedMoviesProvider);

    if (isLoading) {
      return const Scaffold(
        body: FullScreenLoader(),
        bottomNavigationBar: CustomBottomNavigation(),
      );
    }

    if (nowPlayingState.hasError ||
        popularState.hasError ||
        upcomingState.hasError ||
        topRatedState.hasError) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('No se pudieron cargar las películas.'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    ref.invalidate(nowPlayingMoviesProvider);
                    ref.invalidate(popularMoviesProvider);
                    ref.invalidate(upcomingMoviesProvider);
                    ref.invalidate(topRatedMoviesProvider);
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigation(),
      );
    }

    final slideshowMovies = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = nowPlayingState.value ?? const [];
    final popularMovies = popularState.value ?? const [];
    final upcomingMovies = upcomingState.value ?? const [];
    final topRatedMovies = topRatedState.value ?? const [];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            flexibleSpace: FlexibleSpaceBar(title: CustomAppbar()),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                MoviesSlideshow(movies: slideshowMovies),
                MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: 'En cines',
                  subTitle: 'Lunes 20',
                  loadNextPage: () => ref
                      .read(nowPlayingMoviesProvider.notifier)
                      .loadNextPage(),
                ),
                MovieHorizontalListview(
                  movies: upcomingMovies,
                  title: 'Próximamente',
                  subTitle: 'En este mes',
                  loadNextPage: () =>
                      ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
                ),
                MovieHorizontalListview(
                  movies: popularMovies,
                  title: 'Populares',
                  loadNextPage: () =>
                      ref.read(popularMoviesProvider.notifier).loadNextPage(),
                ),
                MovieHorizontalListview(
                  movies: topRatedMovies,
                  title: 'Mejor calificadas',
                  subTitle: 'Desde siempre',
                  loadNextPage: () =>
                      ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
