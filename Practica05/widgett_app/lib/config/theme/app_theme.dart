import 'package:flutter/material.dart';

// Lista de colores predefinidos para que el usuario pueda elegir
const colorList = <Color>[
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.purple,
  Colors.orange,
  Colors.pink,
];

class AppTheme {
  final int selectedColor;
  final bool isDarkMode;

  AppTheme({
    this.selectedColor = 0, 
    this.isDarkMode = false,
  }) : assert(
          selectedColor >= 0 && selectedColor < colorList.length,
          'Selected color must be between 0 and ${colorList.length - 1}',
        );

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        colorSchemeSeed: colorList[selectedColor],
        appBarTheme: const AppBarTheme(
          centerTitle: false, // Alinea el título de la barra a la izquierda por defecto
        ),
      );

  // Método para cambiar el tema fácilmente (patrón para gestores de estado o StatefulWidget)
  AppTheme copyWith({
    int? selectedColor,
    bool? isDarkMode,
  }) =>
      AppTheme(
        selectedColor: selectedColor ?? this.selectedColor,
        isDarkMode: isDarkMode ?? this.isDarkMode,
      );
}