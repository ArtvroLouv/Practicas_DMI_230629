class Movie {
  final bool adult;
  final String backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final DateTime releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;
  Movie({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    adult: json['adult'] as bool? ?? false,
    backdropPath: json['backdropPath'] as String? ?? '',
    genreIds: (json['genreIds'] as List? ?? const [])
        .whereType<num>()
        .map((id) => id.toInt())
        .toList(),
    id: (json['id'] as num?)?.toInt() ?? 0,
    originalLanguage: json['originalLanguage'] as String? ?? '',
    originalTitle: json['originalTitle'] as String? ?? '',
    overview: json['overview'] as String? ?? '',
    popularity: (json['popularity'] as num?)?.toDouble() ?? 0,
    posterPath: json['posterPath'] as String? ?? '',
    releaseDate:
        DateTime.tryParse(json['releaseDate'] as String? ?? '') ??
        DateTime(1970),
    title: json['title'] as String? ?? '',
    video: json['video'] as bool? ?? false,
    voteAverage: (json['voteAverage'] as num?)?.toDouble() ?? 0,
    voteCount: (json['voteCount'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'adult': adult,
    'backdropPath': backdropPath,
    'genreIds': genreIds,
    'id': id,
    'originalLanguage': originalLanguage,
    'originalTitle': originalTitle,
    'overview': overview,
    'popularity': popularity,
    'posterPath': posterPath,
    'releaseDate': releaseDate.toIso8601String(),
    'title': title,
    'video': video,
    'voteAverage': voteAverage,
    'voteCount': voteCount,
  };
}
