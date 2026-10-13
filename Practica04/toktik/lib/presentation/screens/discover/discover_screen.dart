import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/presentation/models/feed_section.dart';
import 'package:toktik/presentation/providers/feed_provider.dart';
import 'package:toktik/presentation/widgets/shared/video_scrollable_view.dart';

class DiscoverScreen extends StatelessWidget {
  final bool isActive;

  const DiscoverScreen({super.key, this.isActive = true});

  @override
  Widget build(BuildContext context) {
    final feedState = context.watch<FeedProvider>().feed(FeedSection.discover);

    return VideoScrollableView(
      key: ValueKey('discover_${feedState.version}'),
      videos: feedState.videos,
      isActive: isActive,
      onRefresh: () => context.read<FeedProvider>().refresh(FeedSection.discover),
    );
  }
}
