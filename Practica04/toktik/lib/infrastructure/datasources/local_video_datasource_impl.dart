import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/models/local_video_model.dart';
import 'package:toktik/shared/data/local_video_post.dart';

/// Datasource local (videos locales / Drive). Se usa sin conexión a APIs externas.
class LocalVideoDatasource implements VideoPostDatasource {
  Future<List<VideoPost>> _loadLocalVideos() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<VideoPost> newVideos = videoPosts.map(
      (video) => LocalVideoModel.fromJson(video).toVideoPostEntity(),
    ).toList();

    return newVideos;
  }

  @override
  Future<List<VideoPost>> getTikTokVideos() => _loadLocalVideos();

  @override
  Future<List<VideoPost>> getInstagramReels() => _loadLocalVideos();

  @override
  Future<List<VideoPost>> getYouTubeShorts() => _loadLocalVideos();
}
