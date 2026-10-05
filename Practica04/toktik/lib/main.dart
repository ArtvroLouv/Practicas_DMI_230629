import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/presentation/discover/discover_screen.dart';
import 'package:toktik/presentation/providers/discover_providers.dart';
import 'package:toktik/theme/app_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DiscoverProviders()),
      ],
      child: MaterialApp(
        title: 'TOKTIK',
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
        home: const DiscoverScreen(),
      ),
    );
  }
}