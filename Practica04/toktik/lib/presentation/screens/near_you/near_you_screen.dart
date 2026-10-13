import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/presentation/models/feed_section.dart';
import 'package:toktik/presentation/providers/feed_provider.dart';
import 'package:toktik/presentation/widgets/shared/video_scrollable_view.dart';

class NearYouScreen extends StatelessWidget {
  final bool isActive;

  const NearYouScreen({super.key, this.isActive = true});

  @override
  Widget build(BuildContext context) {
    final feedState = context.watch<FeedProvider>().feed(FeedSection.nearYou);

    return VideoScrollableView(
      key: ValueKey('near_you_${feedState.version}'),
      videos: feedState.videos,
      isActive: isActive,
      onRefresh: () => context.read<FeedProvider>().refresh(FeedSection.nearYou),
    );
  }
}
