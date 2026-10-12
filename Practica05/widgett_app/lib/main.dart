import 'package:flutter/material.dart';
import 'package:widgett_app/config/router/app_router.dart';
import 'package:widgett_app/config/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Instancia de tu clase AppTheme (puedes cambiar selectedColor o isDarkMode aquí)
    final appTheme = AppTheme(selectedColor: 0, isDarkMode: false);

    return MaterialApp.router(
      title: 'Flutter Widgets App',
      routerConfig: appRouter, // Conecta tu configuración de GoRouter
      debugShowCheckedModeBanner: false,
      theme: appTheme.getTheme(), // Aplica el tema globalmente
    );
  }
}