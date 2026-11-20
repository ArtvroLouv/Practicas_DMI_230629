import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/domain/entities/movie_details.dart';
import 'package:cinemapedia_app/domain/entities/movie_genre.dart';
import 'package:cinemapedia_app/presentation/providers/country_provider.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchMoviesProvider = FutureProvider.family<List<Movie>, String>((
  ref,
  query,
) {
  final country = ref.watch(selectedCountryProvider);
  return ref
      .watch(movieRepositoryProvider)
      .searchMovies(
        query: query,
        region: country.regionCode,
        language: '${country.languageCode}-${country.regionCode}',
      );
});

final movieGenresProvider = FutureProvider<List<MovieGenre>>((ref) {
  final country = ref.watch(selectedCountryProvider);
  return ref
      .watch(movieRepositoryProvider)
      .getGenres(language: '${country.languageCode}-${country.regionCode}');
});

final moviesByGenreProvider = FutureProvider.family<List<Movie>, int>((
  ref,
  genreId,
) {
  final country = ref.watch(selectedCountryProvider);
  return ref
      .watch(movieRepositoryProvider)
      .getMoviesByGenre(
        genreId: genreId,
        region: country.regionCode,
        language: '${country.languageCode}-${country.regionCode}',
      );
});

final movieDetailsProvider = FutureProvider.family<MovieDetails, int>((
  ref,
  movieId,
) {
  final country = ref.watch(selectedCountryProvider);
  return ref
      .watch(movieRepositoryProvider)
      .getMovieDetails(
        movieId: movieId,
        language: '${country.languageCode}-${country.regionCode}',
      );
});
