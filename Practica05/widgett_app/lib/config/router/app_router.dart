import 'package:go_router/go_router.dart';
import 'package:widgett_app/presentation/screens/screens.dart';
import 'package:widgett_app/presentation/screens/cards/card_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/buttons',
      name: 'buttons',
      builder: (context, state) => const ButtonScreen(), // Asegúrate de tener esta pantalla creada
    ),
    GoRoute(
      path: '/cards',
      name: 'cards',
      builder: (context, state) => const CardScreen(), // Asegúrate de tener esta pantalla creada
    ),
  ],
);