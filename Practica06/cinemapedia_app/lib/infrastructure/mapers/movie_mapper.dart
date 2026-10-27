
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/moviedb_response.dart';

class MovieMapper {

    static MovieDBToEntity(MovieMovieDB moviedb ) =>Movie(
    adult: moviedb.adult,
    backdropPath: (moviedb.backdropPath != null && moviedb.backdropPath.isNotEmpty) ? 'https://image.tmdb.org/t/p/w500${moviedb.backdropPath}' : 'https://i.stack.imgur.com/GNhxO.png'  ,
    genreIds: moviedb.genreIds?.map((e) => int.parse(e.toString())).toList() ?? [],    
    id: moviedb.id, 
    originalLanguage: moviedb.originalLanguage, 
    originalTitle: moviedb.originalTitle, 
    overview: moviedb.overview, 
    popularity: moviedb.popularity, 
    posterPath: (moviedb.posterPath != null && moviedb.posterPath.isNotEmpty) ? 'https://image.tmdb.org/t/p/w500${moviedb.posterPath}'ç : 'https://i.stack.imgur.com/GNhxO.png'  ,
    releaseDate: moviedb.releaseDate, 
    title: moviedb.title, 
    video: moviedb.video, 
    voteAverage: moviedb.voteAverage, 
    voteCount: moviedb.voteCount);

}