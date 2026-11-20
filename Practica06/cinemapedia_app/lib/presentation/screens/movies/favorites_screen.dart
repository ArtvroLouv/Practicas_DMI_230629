import 'package:cinemapedia_app/config/constants/app_strings.dart';
import 'package:cinemapedia_app/presentation/providers/country_provider.dart';
import 'package:cinemapedia_app/presentation/providers/favorites_provider.dart';
import 'package:cinemapedia_app/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  static const name = 'favorites-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings(ref.watch(selectedCountryProvider));
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(strings.favorites)),
      body: favorites.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(strings.loadError),
              TextButton(
                onPressed: () => ref.invalidate(favoritesProvider),
                child: Text(strings.retry),
              ),
            ],
          ),
        ),
        data: (movies) => movies.isEmpty
            ? Center(child: Text(strings.favoritesEmpty))
            : MovieGrid(movies: movies),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        strings: strings,
        selectedIndex: 2,
      ),
    );
  }
}
