import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/presentation/models/feed_section.dart';
import 'package:toktik/presentation/providers/feed_provider.dart';
import 'package:toktik/presentation/screens/discover/discover_screen.dart';
import 'package:toktik/presentation/screens/for_you/for_you_screen.dart';
import 'package:toktik/presentation/screens/near_you/near_you_screen.dart';
import 'package:toktik/presentation/screens/favorites/favorites_screen.dart';
import 'package:toktik/presentation/widgets/navigation/modern_top_nav_bar.dart';
import 'package:toktik/presentation/widgets/shared/app_loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  final PageController _pageController = PageController();
  bool _isAnimatingFromTap = false;

  @override
  void initState() {
    super.initState();
    // 🚀 ESTO ES LO QUE FALTABA: Dispara la carga de datos de la API al entrar al Home
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedProvider>().loadAll();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTap(int index) {
    if (index == _selectedTab) {
      context.read<FeedProvider>().refresh(FeedSection.values[index]);
      return;
    }

    setState(() => _selectedTab = index);

    final section = FeedSection.values[index];
    if (index == 3) {
      context.read<FeedProvider>().refresh(FeedSection.favorites);
    } else {
      if (context.read<FeedProvider>().feed(section).videos.isEmpty) {
        context.read<FeedProvider>().refresh(section);
      }
    }

    _isAnimatingFromTap = true;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    ).then((_) {
      _isAnimatingFromTap = false;
    });
  }

  void _onPageChanged(int index) {
    if (_isAnimatingFromTap) return;
    if (index != _selectedTab) {
      setState(() => _selectedTab = index);
      final section = FeedSection.values[index];
      if (index == 3) {
        context.read<FeedProvider>().refresh(FeedSection.favorites);
      } else {
        if (context.read<FeedProvider>().feed(section).videos.isEmpty) {
          context.read<FeedProvider>().refresh(section);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FeedProvider>();

    if (provider.initialLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF08090C),
        body: Center(
          child: AppLoadingIndicator(
            message: 'Iniciando TokTik...',
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Desplazamiento horizontal entre secciones
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              ForYouScreen(
                isActive: _selectedTab == 0 && !provider.feed(FeedSection.forYou).isRefreshing,
              ),
              NearYouScreen(
                isActive: _selectedTab == 1 && !provider.feed(FeedSection.nearYou).isRefreshing,
              ),
              DiscoverScreen(
                isActive: _selectedTab == 2 && !provider.feed(FeedSection.discover).isRefreshing,
              ),
              FavoritesScreen(
                isActive: _selectedTab == 3 && !provider.feed(FeedSection.favorites).isRefreshing,
              ),
            ],
          ),

          // 2. Indicador de recarga de la sección actual
          if (provider.feed(FeedSection.values[_selectedTab]).isRefreshing)
            Container(
              color: Colors.black.withValues(alpha: 0.7),
              child: const Center(
                child: AppLoadingIndicator(
                  message: 'Actualizando contenido...',
                ),
              ),
            ),

          // 3. Barra de navegación superior moderna
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ModernTopNavBar(
                labels: FeedSection.values.map((s) => s.label).toList(),
                controller: _pageController,
                selectedIndex: _selectedTab,
                onTabSelected: _onTabTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}