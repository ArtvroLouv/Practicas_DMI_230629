import 'package:flutter/foundation.dart';
import 'package:toktik/config/helpers/video_deduplicator.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';
import 'package:toktik/infrastructure/datasources/rapidapi_datasource_impl.dart';
import 'package:toktik/infrastructure/repositories/video_posts_repository_impl.dart';
import 'package:toktik/presentation/models/feed_section.dart';
import 'package:toktik/presentation/models/feed_state.dart';
import 'package:toktik/infrastructure/services/local_storage_service.dart';

/// Maneja los videos de las secciones del feed.
class FeedProvider extends ChangeNotifier {
  FeedProvider({VideoPostRepository? repository})
      : _repository = repository ??
            VideoPostsRepositoryImpl(videosDatasource: RapidApiDatasource());

  static const Duration _minRefreshDuration = Duration(milliseconds: 500);

  final VideoPostRepository _repository;

  final Map<FeedSection, FeedState> _feeds = {
    for (final section in FeedSection.values) section: const FeedState(),
  };

  bool _initialLoading = true;
  bool get initialLoading => _initialLoading;

  FeedState feed(FeedSection section) => _feeds[section]!;

  /// Carga inicial rápida: Carga 'For You' de inmediato y las demás en segundo plano.
  Future<void> loadAll() async {
    try {
      final forYouVideos = await _fetch(FeedSection.forYou);
      _feeds[FeedSection.forYou] = FeedState(videos: forYouVideos);
    } catch (e) {
      debugPrint('FeedProvider: Error cargando For You inicial: $e');
    } finally {
      _initialLoading = false;
      notifyListeners();
    }

    for (final section in [FeedSection.nearYou, FeedSection.discover, FeedSection.favorites]) {
      try {
        final videos = await _fetch(section);
        _feeds[section] = FeedState(videos: videos);
        notifyListeners();
      } catch (e) {
        debugPrint('FeedProvider: Error cargando $section en segundo plano: $e');
      }
    }
  }

  /// Pide videos nuevos para una sección y la reinicia desde el primer video.
  Future<void> refresh(FeedSection section) async {
    final current = feed(section);
    if (current.isRefreshing) return;

    _update(section, current.copyWith(isRefreshing: true));

    final (videos, _) = await (
      _fetch(section),
      Future<void>.delayed(_minRefreshDuration),
    ).wait;

    _update(section, FeedState(videos: videos, version: current.version + 1));
  }

  Future<List<VideoPost>> _fetch(FeedSection section) async {
    List<VideoPost> rawList;
    switch (section) {
      case FeedSection.forYou:
        rawList = await _repository.getTikTokVideos();
        break;
      case FeedSection.nearYou:
        rawList = await _repository.getInstagramReels();
        break;
      case FeedSection.discover:
        rawList = await _repository.getYouTubeShorts();
        break;
      case FeedSection.favorites:
        final favIds = LocalStorageService.getFavorites();
        final List<VideoPost> favs = [];
        for (final id in favIds) {
          final data = LocalStorageService.getVideoData(id);
          if (data != null) {
            favs.add(VideoPost.fromJson(data));
          }
        }
        rawList = favs;
        break;
    }

    return VideoDeduplicator.deduplicate(rawList);
  }

  void _update(FeedSection section, FeedState state) {
    _feeds[section] = state;
    notifyListeners();
  }
}
