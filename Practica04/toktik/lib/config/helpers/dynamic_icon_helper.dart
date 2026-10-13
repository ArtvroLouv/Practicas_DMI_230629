import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:toktik/config/helpers/logo_helper.dart';

/// Gestiona la actualización dinámica del icono de la aplicación en el launcher de Android
/// según la temporada activa.
class DynamicIconHelper {
  static const MethodChannel _channel = MethodChannel('com.example.toktik/dynamic_icon');

  /// Sincroniza el icono del launcher de Android con la temporada actual de la app.
  static Future<bool> syncWithCurrentSeason([DateTime? date]) async {
    if (kIsWeb) return false;

    try {
      final theme = LogoHelper.getCurrentSeasonTheme(date);
      final seasonName = theme.season.name;

      final result = await _channel.invokeMethod<bool>('setSeasonalIcon', {
        'season': seasonName,
      });

      debugPrint('DynamicIconHelper: Icono del launcher sincronizado a temporada "$seasonName" (Éxito: $result)');
      return result ?? false;
    } catch (e) {
      debugPrint('DynamicIconHelper: No se pudo cambiar el icono dinámico: $e');
      return false;
    }
  }
}
