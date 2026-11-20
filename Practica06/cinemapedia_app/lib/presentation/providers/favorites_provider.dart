import 'dart:convert';

import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoritesProvider = AsyncNotifierProvider<FavoritesNotifier, List<Movie>>(
  FavoritesNotifier.new,
);

class FavoritesNotifier extends AsyncNotifier<List<Movie>> {
  static const _storageKey = 'cinemapedia.favorite_movies';

  @override
  Future<List<Movie>> build() async {
    final preferences = await SharedPreferences.getInstance();
    final savedMovies = preferences.getString(_storageKey);
    if (savedMovies == null || savedMovies.isEmpty) return [];

    final decoded = jsonDecode(savedMovies);
    if (decoded is! List || decoded.any((movie) => movie is! Map)) {
      throw const FormatException(
        'Los favoritos guardados tienen un formato inválido.',
      );
    }

    return decoded
        .map((movie) => Movie.fromJson(Map<String, dynamic>.from(movie as Map)))
        .toList();
  }

  Future<void> toggle(Movie movie) async {
    final currentMovies = state.value;
    if (currentMovies == null) {
      throw StateError('Los favoritos todavía se están cargando.');
    }

    final isFavorite = currentMovies.any((item) => item.id == movie.id);
    final updatedMovies = isFavorite
        ? currentMovies.where((item) => item.id != movie.id).toList()
        : [movie, ...currentMovies];
    final preferences = await SharedPreferences.getInstance();
    final stored = jsonEncode(
      updatedMovies.map((item) => item.toJson()).toList(),
    );
    final saved = await preferences.setString(_storageKey, stored);
    if (!saved) {
      throw StateError('No se pudieron guardar los favoritos.');
    }
    state = AsyncData(updatedMovies);
  }
}
