import 'package:flutter/material.dart';
import 'package:toktik/config/helpers/video_deduplicator.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/presentation/widgets/video/fullscreen_player.dart';

class VideoScrollableView extends StatefulWidget {
  final List<VideoPost> videos;

  /// Indica si la sección que contiene esta lista está visible.
  final bool isActive;
  final Future<void> Function()? onRefresh;

  const VideoScrollableView({
    super.key,
    required this.videos,
    this.isActive = true,
    this.onRefresh,
  });

  @override
  State<VideoScrollableView> createState() => _VideoScrollableViewState();
}

class _VideoScrollableViewState extends State<VideoScrollableView>
    with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final uniqueVideos = VideoDeduplicator.deduplicate(widget.videos);

    Widget pageView = PageView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: uniqueVideos.length,
      onPageChanged: (index) => setState(() => _currentIndex = index),
      itemBuilder: (context, index) {
        final VideoPost videoPost = uniqueVideos[index];

        if (!widget.isActive) {
          return VideoPlaceholder(coverUrl: videoPost.coverUrl);
        }

        return SizedBox.expand(
          child: FullScreenPlayer(
            key: ValueKey('$index-${videoPost.videoUrl}'),
            videoPost: videoPost,
            isActive: index == _currentIndex,
          ),
        );
      },
    );

    if (widget.onRefresh != null) {
      return RefreshIndicator(
        onRefresh: widget.onRefresh!,
        strokeWidth: 2.5,
        color: const Color(0xFF00F2FE),
        backgroundColor: const Color(0xFF131522),
        child: pageView,
      );
    }

    return pageView;
  }
}
