import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get theMovieDbKey {
    final apiKey = dotenv.env['THE_MOVIEDB_KEY']?.trim();
    if (apiKey == null || apiKey.isEmpty) {
      throw StateError(
        'Configura THE_MOVIEDB_KEY en el archivo .env para consultar TMDB.',
      );
    }

    return apiKey;
  }
}
