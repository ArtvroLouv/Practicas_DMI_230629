import 'package:flutter_test/flutter_test.dart';
import 'package:toktik/domain/entities/video_post.dart';

void main() {
  test('VideoPost entity creation test', () {
    final video = VideoPost(
      id: 'test_1',
      caption: 'Test video',
      videoUrl: 'https://example.com/video.mp4',
    );

    expect(video.id, 'test_1');
    expect(video.caption, 'Test video');
    expect(video.likes, 0);
    expect(video.isLiked, false);
  });
}
