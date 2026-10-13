import 'package:flutter/foundation.dart';
import 'package:toktik/domain/entities/video_post.dart';

/// Estado inmutable de una sección del feed.
@immutable
class FeedState {
  const FeedState({
    this.videos = const [],
    this.version = 0,
    this.isRefreshing = false,
  });

  final List<VideoPost> videos;

  /// Aumenta en cada refresh para forzar reconstrucción completa
  final int version;

  final bool isRefreshing;

  FeedState copyWith({
    List<VideoPost>? videos,
    int? version,
    bool? isRefreshing,
  }) {
    return FeedState(
      videos: videos ?? this.videos,
      version: version ?? this.version,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}
