import 'package:cinemapedia_app/config/constants/app_strings.dart';
import 'package:cinemapedia_app/presentation/providers/country_provider.dart';
import 'package:cinemapedia_app/presentation/providers/movies/explore_providers.dart';
import 'package:cinemapedia_app/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  static const name = 'categories-screen';

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  int? _selectedGenreId;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(ref.watch(selectedCountryProvider));
    final genres = ref.watch(movieGenresProvider);

    return Scaffold(
      appBar: AppBar(title: Text(strings.categories)),
      body: genres.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _LoadError(
          message: strings.loadError,
          retryLabel: strings.retry,
          onRetry: () => ref.invalidate(movieGenresProvider),
        ),
        data: (items) {
          if (items.isEmpty) return Center(child: Text(strings.selectGenre));
          final selectedGenreId = _selectedGenreId ?? items.first.id;
          return Column(
            children: [
              SizedBox(
                height: 66,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final genre = items[index];
                    return ChoiceChip(
                      label: Text(genre.name),
                      selected: genre.id == selectedGenreId,
                      onSelected: (_) =>
                          setState(() => _selectedGenreId = genre.id),
                    );
                  },
                ),
              ),
              Expanded(
                child: ref
                    .watch(moviesByGenreProvider(selectedGenreId))
                    .when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stackTrace) => _LoadError(
                        message: strings.loadError,
                        retryLabel: strings.retry,
                        onRetry: () => ref.invalidate(
                          moviesByGenreProvider(selectedGenreId),
                        ),
                      ),
                      data: (movies) => movies.isEmpty
                          ? Center(child: Text(strings.noMovies))
                          : MovieGrid(movies: movies),
                    ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigation(
        strings: strings,
        selectedIndex: 1,
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          TextButton(onPressed: onRetry, child: Text(retryLabel)),
        ],
      ),
    );
  }
}
