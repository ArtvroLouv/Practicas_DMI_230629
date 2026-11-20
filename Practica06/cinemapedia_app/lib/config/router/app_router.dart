import 'package:go_router/go_router.dart';
import 'package:cinemapedia_app/presentation/screens/movies/categories_screen.dart';
import 'package:cinemapedia_app/presentation/screens/movies/favorites_screen.dart';
import 'package:cinemapedia_app/presentation/screens/movies/home_screen.dart';
import 'package:cinemapedia_app/presentation/screens/movies/movie_details_screen.dart';
import 'package:cinemapedia_app/presentation/screens/movies/search_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/search',
      name: SearchScreen.name,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/categories',
      name: CategoriesScreen.name,
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: '/favorites',
      name: FavoritesScreen.name,
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/movie/:id',
      name: MovieDetailsScreen.name,
      builder: (context, state) =>
          MovieDetailsScreen(movieId: int.parse(state.pathParameters['id']!)),
    ),
  ],
);
