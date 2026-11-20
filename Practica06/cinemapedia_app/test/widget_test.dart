import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/domain/entities/movie_details.dart';
import 'package:cinemapedia_app/domain/entities/movie_genre.dart';
import 'package:cinemapedia_app/domain/repositories/movies_repository.dart';
import 'package:cinemapedia_app/config/constants/app_country.dart';
import 'package:cinemapedia_app/config/constants/app_strings.dart';
import 'package:cinemapedia_app/config/helpers/movie_load_error_message.dart';
import 'package:cinemapedia_app/config/router/app_router.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/movie_moviedb.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movie_certification_provider.dart';
import 'package:cinemapedia_app/presentation/providers/movies/explore_providers.dart';
import 'package:cinemapedia_app/presentation/providers/favorites_provider.dart';
import 'package:cinemapedia_app/presentation/screens/movies/home_screen.dart';
import 'package:cinemapedia_app/presentation/screens/movies/search_screen.dart';
import 'package:cinemapedia_app/presentation/screens/movies/categories_screen.dart';
import 'package:cinemapedia_app/presentation/screens/movies/favorites_screen.dart';
import 'package:cinemapedia_app/presentation/providers/country_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows now-playing movies', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          movieRepositoryProvider.overrideWith(
            (ref) => _FakeMoviesRepository(),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('En cines'), findsOneWidget);
    expect(find.text('Populares'), findsOneWidget);
    expect(find.text('Próximamente'), findsOneWidget);
    expect(find.text('Mejor calificadas'), findsOneWidget);
    expect(find.text('Película de prueba'), findsNWidgets(4));
    expect(find.byTooltip('Abrir menú'), findsOneWidget);
  });

  testWidgets('country menu changes the language of the home interface', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          movieRepositoryProvider.overrideWith(
            (ref) => _FakeMoviesRepository(),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Abrir menú'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deutschland'));
    await tester.pumpAndSettle();

    expect(find.text('Im Kino'), findsOneWidget);
    expect(find.text('Beliebt'), findsOneWidget);
    expect(find.text('Kategorien'), findsOneWidget);
  });

  testWidgets('search and bottom navigation open their screens', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          movieRepositoryProvider.overrideWith(
            (ref) => _FakeMoviesRepository(),
          ),
        ],
        child: MaterialApp.router(routerConfig: appRouter),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Buscar películas'));
    await tester.pumpAndSettle();
    expect(find.byType(SearchScreen), findsOneWidget);

    await tester.tap(find.text('Categorías').last);
    await tester.pumpAndSettle();
    expect(find.byType(CategoriesScreen), findsOneWidget);

    await tester.tap(find.text('Favoritos').last);
    await tester.pumpAndSettle();
    expect(find.byType(FavoritesScreen), findsOneWidget);
  });

  test(
    'each movie list requests its corresponding repository endpoint',
    () async {
      final repository = _FakeMoviesRepository();
      final container = ProviderContainer(
        overrides: [movieRepositoryProvider.overrideWith((ref) => repository)],
      );
      addTearDown(container.dispose);

      await container.read(nowPlayingMoviesProvider.future);
      await container.read(popularMoviesProvider.future);
      await container.read(upcomingMoviesProvider.future);
      await container.read(topRatedMoviesProvider.future);

      expect(repository.requestedLists, {
        'nowPlaying',
        'popular',
        'upcoming',
        'topRated',
      });
      expect(repository.requestedRegions, {'MX'});
      expect(repository.requestedLanguages, {'es-MX'});

      container.read(selectedCountryProvider.notifier).select(AppCountry.usa);
      await container.read(nowPlayingMoviesProvider.future);
      expect(repository.requestedRegions, contains('US'));
      expect(repository.requestedLanguages, contains('en-US'));
    },
  );

  test('movie certification uses the selected country', () async {
    final container = ProviderContainer(
      overrides: [
        movieRepositoryProvider.overrideWith((ref) => _FakeMoviesRepository()),
      ],
    );
    addTearDown(container.dispose);

    expect(
      await container.read(movieCertificationProvider((1, 'US')).future),
      'PG-13',
    );
    expect(
      await container.read(movieCertificationProvider((1, 'MX')).future),
      'B15',
    );
    expect(
      await container.read(movieCertificationProvider((1, 'DE')).future),
      '12',
    );
  });

  test(
    'explore providers use the selected locale and repository methods',
    () async {
      final repository = _FakeMoviesRepository();
      final container = ProviderContainer(
        overrides: [movieRepositoryProvider.overrideWith((ref) => repository)],
      );
      addTearDown(container.dispose);

      await container.read(searchMoviesProvider('Dune').future);
      await container.read(movieGenresProvider.future);
      await container.read(moviesByGenreProvider(28).future);
      await container.read(movieDetailsProvider(42).future);

      expect(repository.requestedSearchQueries, {'Dune'});
      expect(repository.requestedGenreIds, {28});
      expect(repository.requestedDetailIds, {42});
      expect(repository.requestedLanguages, contains('es-MX'));
    },
  );

  test('favorites are saved and restored from local storage', () async {
    SharedPreferences.setMockInitialValues({});
    final firstContainer = ProviderContainer();
    addTearDown(firstContainer.dispose);
    await firstContainer.read(favoritesProvider.future);
    await firstContainer
        .read(favoritesProvider.notifier)
        .toggle(_FakeMoviesRepository()._movies().single);

    expect((await firstContainer.read(favoritesProvider.future)).single.id, 1);
    await firstContainer
        .read(favoritesProvider.notifier)
        .toggle(_FakeMoviesRepository()._movies().single);
    expect(await firstContainer.read(favoritesProvider.future), isEmpty);

    final secondContainer = ProviderContainer();
    addTearDown(secondContainer.dispose);
    expect(await secondContainer.read(favoritesProvider.future), isEmpty);
  });

  test('movie model accepts absent optional values from TMDB', () {
    final movie = MovieMovieDB.fromJson({
      'id': 42,
      'genre_ids': [28],
    });

    expect(movie.id, 42);
    expect(movie.genreIds, [28]);
    expect(movie.posterPath, isEmpty);
    expect(movie.title, isEmpty);
  });

  test('TMDB loading errors explain missing or rejected API keys', () {
    final strings = AppStrings(AppCountry.mexico);
    final requestOptions = RequestOptions(path: '/movie/now_playing');
    final invalidKeyError = DioException(
      requestOptions: requestOptions,
      response: Response(requestOptions: requestOptions, statusCode: 401),
    );

    expect(
      movieLoadErrorMessage(
        StateError('Configura THE_MOVIEDB_KEY en el archivo .env.'),
        strings,
      ),
      strings.tmdbKeyMissing,
    );
    expect(
      movieLoadErrorMessage(invalidKeyError, strings),
      strings.tmdbKeyInvalid,
    );
  });
}

class _FakeMoviesRepository extends MoviesRepository {
  final requestedLists = <String>{};
  final requestedRegions = <String>{};
  final requestedLanguages = <String>{};
  final requestedSearchQueries = <String>{};
  final requestedGenreIds = <int>{};
  final requestedDetailIds = <int>{};

  @override
  Future<List<Movie>> getNowPlaying({
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  }) async {
    requestedLists.add('nowPlaying');
    _recordLocale(region, language);
    return _movies();
  }

  @override
  Future<List<Movie>> getPopular({
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  }) async {
    requestedLists.add('popular');
    _recordLocale(region, language);
    return _movies();
  }

  @override
  Future<List<Movie>> getUpcoming({
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  }) async {
    requestedLists.add('upcoming');
    _recordLocale(region, language);
    return _movies();
  }

  @override
  Future<List<Movie>> getTopRated({
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  }) async {
    requestedLists.add('topRated');
    _recordLocale(region, language);
    return _movies();
  }

  @override
  Future<List<Movie>> searchMovies({
    required String query,
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  }) async {
    requestedSearchQueries.add(query);
    _recordLocale(region, language);
    return _movies();
  }

  @override
  Future<List<MovieGenre>> getGenres({String language = 'es-MX'}) async {
    requestedLanguages.add(language);
    return const [MovieGenre(id: 28, name: 'Action')];
  }

  @override
  Future<List<Movie>> getMoviesByGenre({
    required int genreId,
    int page = 1,
    String region = 'MX',
    String language = 'es-MX',
  }) async {
    requestedGenreIds.add(genreId);
    _recordLocale(region, language);
    return _movies();
  }

  @override
  Future<MovieDetails> getMovieDetails({
    required int movieId,
    String language = 'es-MX',
  }) async {
    requestedDetailIds.add(movieId);
    requestedLanguages.add(language);
    return MovieDetails(
      movie: _movies().single,
      tagline: '',
      runtime: null,
      genres: const [],
    );
  }

  @override
  Future<String?> getMovieCertification({
    required int movieId,
    required String region,
  }) async {
    return switch (region) {
      'US' => 'PG-13',
      'MX' => 'B15',
      'DE' => '12',
      _ => null,
    };
  }

  void _recordLocale(String region, String language) {
    requestedRegions.add(region);
    requestedLanguages.add(language);
  }

  List<Movie> _movies() {
    return [
      Movie(
        adult: false,
        backdropPath: '',
        genreIds: const [],
        id: 1,
        originalLanguage: 'es',
        originalTitle: 'Título original',
        overview: '',
        popularity: 0,
        posterPath: '',
        releaseDate: DateTime(2026),
        title: 'Película de prueba',
        video: false,
        voteAverage: 0,
        voteCount: 0,
      ),
    ];
  }
}
