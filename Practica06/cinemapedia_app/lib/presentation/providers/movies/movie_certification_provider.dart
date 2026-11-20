import 'package:cinemapedia_app/domain/repositories/movies_repository.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieCertificationProvider =
    FutureProvider.family<String?, (int, String)>((ref, request) {
      final MoviesRepository repository = ref.watch(movieRepositoryProvider);
      return repository.getMovieCertification(
        movieId: request.$1,
        region: request.$2,
      );
    });
