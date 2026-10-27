import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/domain/repositories/movies_repository.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/movie_moviedb.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_repository_provider.dart';
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

    expect(find.text('Película de prueba'), findsOneWidget);
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
}

class _FakeMoviesRepository extends MoviesRepository {
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
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
