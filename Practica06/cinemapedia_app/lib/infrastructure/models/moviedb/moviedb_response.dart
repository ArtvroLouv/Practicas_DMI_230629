import 'movie_moviedb.dart';

class MovieDbResponse {
  MovieDbResponse({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final Dates? dates;
  final int page;
  final List<MovieMovieDB> results;
  final int totalPages;
  final int totalResults;

  factory MovieDbResponse.fromJson(Map<String, dynamic> json) {
    final rawDates = json['dates'];
    final rawResults = json['results'];

    return MovieDbResponse(
      dates: rawDates is Map
          ? Dates.fromJson(Map<String, dynamic>.from(rawDates))
          : null,
      page: (json['page'] as num?)?.toInt() ?? 1,
      results: rawResults is List
          ? rawResults
                .whereType<Map>()
                .map(
                  (movie) =>
                      MovieMovieDB.fromJson(Map<String, dynamic>.from(movie)),
                )
                .toList()
          : <MovieMovieDB>[],
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
      totalResults: (json['total_results'] as num?)?.toInt() ?? 0,
    );
  }
}

class Dates {
  Dates({required this.maximum, required this.minimum});

  final DateTime maximum;
  final DateTime minimum;

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
    maximum:
        DateTime.tryParse(json['maximum'] as String? ?? '') ?? DateTime(1970),
    minimum:
        DateTime.tryParse(json['minimum'] as String? ?? '') ?? DateTime(1970),
  );
}
