import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/helpers/dynamic_icon_helper.dart';
import 'package:toktik/config/theme/app_theme.dart';
import 'package:toktik/infrastructure/services/local_storage_service.dart';
import 'package:toktik/presentation/providers/feed_provider.dart';
import 'package:toktik/presentation/providers/playback_settings.dart';
import 'package:toktik/presentation/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Bloqueo estricto de orientación a solo vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await LocalStorageService.init();
  
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Dotenv load error / warning: $e");
  }

  DynamicIconHelper.syncWithCurrentSeason();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          // Quitamos el '..loadAll()' de aquí para evitar el choque al iniciar
          create: (_) => FeedProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PlaybackSettings(),
        ),
      ],
      child: MaterialApp(
        title: 'TokTik',
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
        home: const SplashScreen(),
      ),
    );
  }
}