import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get rapidApiKey {
    try {
      // Verificamos si dotenv ya está inicializado de forma segura
      if (dotenv.isInitialized) {
        return dotenv.env['RAPID_API_KEY'] ?? '';
      }
      return '';
    } catch (_) {
      return '';
    }
  }
}