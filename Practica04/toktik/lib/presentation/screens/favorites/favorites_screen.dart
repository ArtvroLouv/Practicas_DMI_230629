import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/presentation/models/feed_section.dart';
import 'package:toktik/presentation/providers/feed_provider.dart';
import 'package:toktik/presentation/widgets/shared/video_scrollable_view.dart';

class FavoritesScreen extends StatelessWidget {
  final bool isActive;

  const FavoritesScreen({super.key, this.isActive = true});

  @override
  Widget build(BuildContext context) {
    final feedState = context.watch<FeedProvider>().feed(FeedSection.favorites);

    if (feedState.videos.isEmpty && !feedState.isRefreshing) {
      return Container(
        color: const Color(0xFF08090C),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF141622),
                  border: Border.all(
                    color: const Color(0xFFFF2A6D).withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF2A6D).withValues(alpha: 0.2),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Color(0xFFFF2A6D),
                  size: 44,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Tu lista de favoritos está vacía',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Toca dos veces en cualquier video para guardarlo aquí',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return VideoScrollableView(
      key: ValueKey('favorites_${feedState.version}'),
      videos: feedState.videos,
      isActive: isActive,
      onRefresh: () => context.read<FeedProvider>().refresh(FeedSection.favorites),
    );
  }
}
