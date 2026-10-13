import 'package:flutter/material.dart';

/// Temporadas disponibles para la app
enum Season { normal, anniversary, halloween, christmas, valentine }

/// Configuración visual de cada temporada (logo + colores + sonido del splash)
class SeasonTheme {
  final Season season;
  final String logoPath;

  /// Sonido del splash (ruta relativa a la carpeta assets/)
  final String soundPath;

  /// Colores del gradiente animado del splash (tomados del logo)
  final List<Color> gradientColors;

  /// Color del brillo (glow) alrededor del logo
  final Color glowColor;

  /// Escala para recortar el margen blanco de los .jpg
  final double cropScale;

  const SeasonTheme({
    required this.season,
    required this.logoPath,
    required this.soundPath,
    required this.gradientColors,
    required this.glowColor,
    this.cropScale = 1.0,
  });
}

class LogoHelper {
  // ==================== 5 TEMAS / SPLASH SCREENS ====================

  /// 1. Logo original
  static const SeasonTheme _normal = SeasonTheme(
    season: Season.normal,
    logoPath: 'assets/images/logo.jpg',
    soundPath: 'assets/sounds/logo_sound.mp3',
    gradientColors: [
      Color(0xFF0B0B2B),
      Color(0xFF28114B),
      Color(0xFF9333EA),
      Color(0xFF06B6D4),
    ],
    glowColor: Color(0xFF9333EA),
  );

  /// 2. Aniversario
  static const SeasonTheme _anniversary = SeasonTheme(
    season: Season.anniversary,
    logoPath: 'assets/images/aniversary_logo.jpg',
    soundPath: 'assets/sounds/aniversario.mp3',
    gradientColors: [
      Color(0xFF140F35),
      Color(0xFF6D28D9),
      Color(0xFFEC4899),
      Color(0xFFF59E0B),
      Color(0xFF06B6D4),
    ],
    glowColor: Color(0xFFEC4899),
    cropScale: 1.32,
  );

  /// 3. Halloween
  static const SeasonTheme _halloween = SeasonTheme(
    season: Season.halloween,
    logoPath: 'assets/images/halloween_logo.jpg',
    soundPath: 'assets/sounds/halloween.mp3',
    gradientColors: [
      Color(0xFF0F051D),
      Color(0xFF4C1D95),
      Color(0xFFEA580C),
      Color(0xFF7C3AED),
      Color(0xFF22C55E),
    ],
    glowColor: Color(0xFFEA580C),
    cropScale: 1.32,
  );

  /// 4. Navidad
  static const SeasonTheme _christmas = SeasonTheme(
    season: Season.christmas,
    logoPath: 'assets/images/chrismas_logo.jpg',
    soundPath: 'assets/sounds/navidad.mp3',
    gradientColors: [
      Color(0xFF08182B),
      Color(0xFF991B1B),
      Color(0xFF065F46),
      Color(0xFF1E40AF),
      Color(0xFF10B981),
    ],
    glowColor: Color(0xFF10B981),
    cropScale: 1.32,
  );

  /// 5. San Valentín
  static const SeasonTheme _valentine = SeasonTheme(
    season: Season.valentine,
    logoPath: 'assets/images/valentines_logo.jpg',
    soundPath: 'assets/sounds/valentin.mp3',
    gradientColors: [
      Color(0xFF240730),
      Color(0xFF831843),
      Color(0xFFF43F5E),
      Color(0xFFFDA4AF),
      Color(0xFF701A75),
    ],
    glowColor: Color(0xFFF43F5E),
    cropScale: 1.32,
  );

  /// Devuelve el tema completo según la fecha actual
  static SeasonTheme getCurrentSeasonTheme([DateTime? date]) {
    final now = date ?? DateTime.now();
    final month = now.month;
    final day = now.day;

    // 1. Del 01 al 10 de Octubre: Aniversario
    if (month == 10 && day >= 1 && day <= 10) {
      return _anniversary;
    }

    // 2. Del 20 de Octubre al 20 de Noviembre: Halloween
    if ((month == 10 && day >= 20) || (month == 11 && day <= 20)) {
      return _halloween;
    }

    // 3. Del 10 de Diciembre al 10 de Enero: Navidad
    if ((month == 12 && day >= 10) || (month == 1 && day <= 10)) {
      return _christmas;
    }

    // 4. Del 02 al 22 de Febrero: San Valentín
    if (month == 2 && day >= 2 && day <= 22) {
      return _valentine;
    }

    // Por defecto, tema normal
    return _normal;
  }

  static String getCurrentLogoPath() => getCurrentSeasonTheme().logoPath;
}
