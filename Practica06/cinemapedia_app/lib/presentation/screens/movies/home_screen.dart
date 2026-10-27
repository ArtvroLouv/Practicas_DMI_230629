import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_providers.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeView();
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  ConsumerState<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  Widget build(BuildContext context) {
    final moviesState = ref.watch(nowPlayingMoviesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cinemapedia')),
      body: moviesState.when(
        data: (movies) => NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.extentAfter < 300) {
              ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
            }
            return false;
          },
          child: movies.isEmpty
              ? const Center(child: Text('No hay películas disponibles.'))
              : ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return ListTile(
                      leading: movie.posterPath.isEmpty
                          ? const SizedBox(
                              width: 56,
                              height: 84,
                              child: Icon(Icons.movie_outlined),
                            )
                          : Image.network(
                              movie.posterPath,
                              width: 56,
                              height: 84,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox(
                                    width: 56,
                                    height: 84,
                                    child: Icon(Icons.broken_image_outlined),
                                  ),
                            ),
                      title: Text(movie.title),
                      subtitle: Text(movie.originalTitle),
                    );
                  },
                ),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('No se pudieron cargar las películas.'),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => ref.invalidate(nowPlayingMoviesProvider),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
