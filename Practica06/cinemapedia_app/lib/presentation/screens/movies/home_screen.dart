import 'package:cinemapedia_app/config/constants/app_country.dart';
import 'package:cinemapedia_app/config/constants/app_strings.dart';
import 'package:cinemapedia_app/presentation/providers/country_provider.dart';
import 'package:cinemapedia_app/config/helpers/movie_load_error_message.dart';
import 'package:cinemapedia_app/presentation/providers/movies/initial_loading_provider.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_slideshow_provider.dart';
import 'package:cinemapedia_app/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const name = 'home-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final country = ref.watch(selectedCountryProvider);
    final strings = AppStrings(country);
    final isLoading = ref.watch(initialLoadingProvider);
    final nowPlayingState = ref.watch(nowPlayingMoviesProvider);
    final popularState = ref.watch(popularMoviesProvider);
    final upcomingState = ref.watch(upcomingMoviesProvider);
    final topRatedState = ref.watch(topRatedMoviesProvider);
    final hasError =
        nowPlayingState.hasError ||
        popularState.hasError ||
        upcomingState.hasError ||
        topRatedState.hasError;
    final loadError =
        nowPlayingState.error ??
        popularState.error ??
        upcomingState.error ??
        topRatedState.error;

    return Scaffold(
      drawer: _CountryDrawer(country: country, strings: strings),
      bottomNavigationBar: CustomBottomNavigation(
        strings: strings,
        selectedIndex: 0,
      ),
      body: Builder(
        builder: (scaffoldContext) => CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              toolbarHeight: 64,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: CustomAppbar(
                strings: strings,
                onMenuPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
                onSearchPressed: () => context.push('/search'),
              ),
            ),
            if (isLoading)
              SliverFillRemaining(
                hasScrollBody: false,
                child: FullScreenLoader(strings: strings),
              )
            else if (hasError)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(movieLoadErrorMessage(loadError, strings)),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () {
                            ref.invalidate(nowPlayingMoviesProvider);
                            ref.invalidate(popularMoviesProvider);
                            ref.invalidate(upcomingMoviesProvider);
                            ref.invalidate(topRatedMoviesProvider);
                          },
                          child: Text(strings.retry),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    MoviesSlideshow(
                      movies: ref.watch(moviesSlideshowProvider),
                      region: country.regionCode,
                      strings: strings,
                    ),
                    MovieHorizontalListview(
                      movies: nowPlayingState.value ?? const [],
                      title: strings.cinema,
                      subTitle: strings.nowPlayingDate,
                      loadNextPage: () => ref
                          .read(nowPlayingMoviesProvider.notifier)
                          .loadNextPage(),
                    ),
                    MovieHorizontalListview(
                      movies: upcomingState.value ?? const [],
                      title: strings.upcoming,
                      subTitle: strings.thisMonth,
                      loadNextPage: () => ref
                          .read(upcomingMoviesProvider.notifier)
                          .loadNextPage(),
                    ),
                    MovieHorizontalListview(
                      movies: popularState.value ?? const [],
                      title: strings.popular,
                      loadNextPage: () => ref
                          .read(popularMoviesProvider.notifier)
                          .loadNextPage(),
                    ),
                    MovieHorizontalListview(
                      movies: topRatedState.value ?? const [],
                      title: strings.topRated,
                      subTitle: strings.allTime,
                      loadNextPage: () => ref
                          .read(topRatedMoviesProvider.notifier)
                          .loadNextPage(),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CountryDrawer extends ConsumerWidget {
  const _CountryDrawer({required this.country, required this.strings});

  final AppCountry country;
  final AppStrings strings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/images/cinemapedia_logo.png',
                      width: 68,
                      height: 68,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      strings.appTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 8),
              child: Text(
                strings.settings,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 16, 4),
              child: Text(
                strings.countryAndLanguage,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            for (final option in AppCountry.values)
              ListTile(
                selected: option == country,
                leading: Text(
                  option.flag,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(option.displayName),
                subtitle: Text('(${option.languageName})'),
                trailing: option == country
                    ? Icon(Icons.check_circle, color: colors.primary)
                    : null,
                onTap: () {
                  ref.read(selectedCountryProvider.notifier).select(option);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}
