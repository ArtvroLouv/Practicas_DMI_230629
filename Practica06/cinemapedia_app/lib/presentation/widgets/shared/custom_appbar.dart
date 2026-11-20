import 'package:cinemapedia_app/config/constants/app_strings.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    required this.strings,
    required this.onMenuPressed,
    required this.onSearchPressed,
  });

  final AppStrings strings;
  final VoidCallback onMenuPressed;
  final VoidCallback onSearchPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          children: [
            IconButton(
              onPressed: onMenuPressed,
              tooltip: strings.menu,
              icon: const Icon(Icons.menu_rounded),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/cinemapedia_logo.png',
                width: 36,
                height: 36,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              strings.appTitle,
              style: titleStyle?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: onSearchPressed,
              tooltip: strings.searchMovies,
              icon: const Icon(Icons.search_rounded),
            ),
            Text(
              strings.country.flag,
              style: const TextStyle(fontSize: 22),
              semanticsLabel: strings.country.selectionLabel,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
