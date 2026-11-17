import 'package:cinemapedia_app/config/constants/app_strings.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key, required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_max),
          label: strings.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.label_outline),
          label: strings.categories,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite_outline),
          label: strings.favorites,
        ),
      ],
    );
  }
}
