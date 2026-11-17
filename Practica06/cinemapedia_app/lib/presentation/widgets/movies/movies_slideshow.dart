import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia_app/config/constants/app_strings.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movie_certification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoviesSlideshow extends StatelessWidget {
  const MoviesSlideshow({
    super.key,
    required this.movies,
    required this.region,
    required this.strings,
  });

  final List<Movie> movies;
  final String region;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 210,
      width: double.infinity,
      child: Swiper(
        itemCount: movies.length,
        viewportFraction: 0.8,
        scale: 0.9,
        autoplay: movies.length > 1,
        pagination: SwiperPagination(
          margin: EdgeInsets.zero,
          builder: DotSwiperPaginationBuilder(
            activeColor: colors.primary,
            color: colors.secondary,
          ),
        ),
        itemBuilder: (context, index) =>
            _Slide(movie: movies[index], region: region, strings: strings),
      ),
    );
  }
}

class _Slide extends ConsumerWidget {
  const _Slide({
    required this.movie,
    required this.region,
    required this.strings,
  });

  final Movie movie;
  final String region;
  final AppStrings strings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final certification = ref.watch(
      movieCertificationProvider((movie.id, region)),
    );
    final title = movie.originalTitle.isEmpty
        ? movie.title
        : movie.originalTitle;

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            movie.backdropPath.isEmpty
                ? const ColoredBox(
                    color: Color(0xFF26242B),
                    child: Center(child: Icon(Icons.movie_outlined, size: 44)),
                  )
                : Image.network(
                    movie.backdropPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const ColoredBox(
                          color: Color(0xFF26242B),
                          child: Center(
                            child: Icon(Icons.broken_image_outlined, size: 44),
                          ),
                        ),
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                        ? FadeIn(child: child)
                        : const ColoredBox(color: Color(0xFF26242B)),
                  ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xE6000000)],
                  stops: [0.35, 1],
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xD91A1720),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 7),
                          Row(
                            children: [
                              ...List.generate(
                                5,
                                (index) => Icon(
                                  index < (movie.voteAverage / 2).round()
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: const Color(0xFFFFC46B),
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                movie.voteAverage.toStringAsFixed(1),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          strings.rating,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          constraints: const BoxConstraints(minWidth: 34),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white70),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Tooltip(
                            message: certification.hasError
                                ? strings.ratingError
                                : strings.rating,
                            child: Text(
                              certification.when(
                                data: (value) => value ?? strings.noRating,
                                error: (error, stackTrace) => '!',
                                loading: () => '…',
                              ),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
