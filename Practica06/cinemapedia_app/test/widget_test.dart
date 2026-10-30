import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/domain/repositories/movies_repository.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/movie_moviedb.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia_app/presentation/screens/movies/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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
    },
  );

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
}

class _FakeMoviesRepository extends MoviesRepository {
  final requestedLists = <String>{};

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    requestedLists.add('nowPlaying');
    return _movies();
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    requestedLists.add('popular');
    return _movies();
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    requestedLists.add('upcoming');
    return _movies();
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    requestedLists.add('topRated');
    return _movies();
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
