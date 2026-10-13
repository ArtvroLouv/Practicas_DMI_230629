import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';

class VideoPostsRepositoryImpl implements VideoPostRepository {
  final VideoPostDatasource videosDatasource;

  VideoPostsRepositoryImpl({required this.videosDatasource});

  @override
  Future<List<VideoPost>> getTikTokVideos() {
    return videosDatasource.getTikTokVideos();
  }

  @override
  Future<List<VideoPost>> getYouTubeShorts() {
    return videosDatasource.getYouTubeShorts();
  }

  @override
  Future<List<VideoPost>> getInstagramReels() {
    return videosDatasource.getInstagramReels();
  }
}
