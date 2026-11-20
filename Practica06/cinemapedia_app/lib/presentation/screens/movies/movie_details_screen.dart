import 'package:cinemapedia_app/config/constants/app_strings.dart';
import 'package:cinemapedia_app/domain/entities/movie_details.dart';
import 'package:cinemapedia_app/presentation/providers/country_provider.dart';
import 'package:cinemapedia_app/presentation/providers/favorites_provider.dart';
import 'package:cinemapedia_app/presentation/providers/movies/explore_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieDetailsScreen extends ConsumerWidget {
  const MovieDetailsScreen({super.key, required this.movieId});

  static const name = 'movie-details-screen';

  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings(ref.watch(selectedCountryProvider));
    final details = ref.watch(movieDetailsProvider(movieId));
    final favoriteState = ref.watch(favoritesProvider);
    final favorites = favoriteState.asData?.value ?? const [];
    final isFavorite = favorites.any((movie) => movie.id == movieId);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: isFavorite ? strings.removeFavorite : strings.addFavorite,
            onPressed:
                favoriteState.isLoading || details.isLoading || details.hasError
                ? null
                : () => _toggleFavorite(context, ref, strings, movieId),
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
            ),
          ),
        ],
      ),
      body: details.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(strings.detailsError),
              TextButton(
                onPressed: () => ref.invalidate(movieDetailsProvider(movieId)),
                child: Text(strings.retry),
              ),
            ],
          ),
        ),
        data: (movieDetails) =>
            _MovieDetailsBody(details: movieDetails, strings: strings),
      ),
    );
  }
}

Future<void> _toggleFavorite(
  BuildContext context,
  WidgetRef ref,
  AppStrings strings,
  int movieId,
) async {
  late MovieDetails details;
  try {
    details = await ref.read(movieDetailsProvider(movieId).future);
  } catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(strings.detailsError)));
    return;
  }
  if (!context.mounted) return;

  try {
    await ref.read(favoritesProvider.notifier).toggle(details.movie);
  } catch (error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(strings.favoriteSaveError)));
  }
}

class _MovieDetailsBody extends StatelessWidget {
  const _MovieDetailsBody({required this.details, required this.strings});

  final MovieDetails details;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final movie = details.movie;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 250,
                width: double.infinity,
                child:
                    movie.backdropPath.isEmpty ||
                        movie.backdropPath == 'no-poster'
                    ? const ColoredBox(
                        color: Colors.black12,
                        child: Center(
                          child: Icon(Icons.movie_outlined, size: 48),
                        ),
                      )
                    : Image.network(
                        movie.backdropPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const ColoredBox(
                              color: Colors.black12,
                              child: Center(
                                child: Icon(Icons.broken_image_outlined),
                              ),
                            ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (details.tagline.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        details.tagline,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _MetaItem(
                          icon: Icons.star_rounded,
                          label: movie.voteAverage.toStringAsFixed(1),
                        ),
                        _MetaItem(
                          icon: Icons.calendar_month_outlined,
                          label: movie.releaseDate.year == 1970
                              ? ''
                              : movie.releaseDate.year.toString(),
                        ),
                        if (details.runtime != null)
                          _MetaItem(
                            icon: Icons.schedule_rounded,
                            label: '${details.runtime} ${strings.runtime}',
                          ),
                      ],
                    ),
                    if (details.genres.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: details.genres
                            .map((genre) => Chip(label: Text(genre)))
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Text(
                      strings.overview,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview.isEmpty
                          ? strings.noOverview
                          : movie.overview,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
