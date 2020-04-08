
import '../../export.dart';

class Movie {

  int movie_id;
  String original_title;
  String backdrop_path;
  String poster_path;
  DateTime release_date;
  double vote_average;
  String overview;
  int runtime;
  bool video;
  List<Genre> genres;

  Movie({this.movie_id, this.original_title, this.backdrop_path, this.poster_path, this.release_date, this.vote_average, this.overview, d});

  Movie.fromJson(Map<String, dynamic> json) {
    if(json['movie_id'] != null)
      movie_id = json['movie_id'];
    if(json['id'] != null)
      movie_id = json['id'];
    original_title = json['original_title'];
    backdrop_path = json['backdrop_path'];
    poster_path = json['poster_path'];
    release_date = conversions.stringJsonToDate(json['release_date']);
    vote_average = json['vote_average'];
    overview = json['overview'];
    if(json['runtime'] != null)
      runtime = json['runtime'];
    if(json['video'] != null)
      video = json['video'];
    if (json['genres'] != null){
      genres = new List<Genre>();
      json['genres'].forEach((v) {
        genres.add(new Genre.fromJson(v));
      });
    } else 
      genres = null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['movie_id'] = this.movie_id;
    data['original_title'] = this.original_title;
    data['backdrop_path'] = this.backdrop_path;
    data['poster_path'] = this.poster_path;
    data['release_date'] = conversions.dateToStringJson(this.release_date);
    data['vote_average'] = this.vote_average;
    data['overview'] = this.overview;
    data['genres'] = List<dynamic>.from(genres.map((x) => x.toJson()));
    return data;
  }
}

class Genre {
  int genre_id;
  String name;

  Genre.fromJson(Map<String, dynamic> json) {
    genre_id = json['id'] == null ? null : json['id'];
    name =  json['name'] == null ? null : json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['genre_id'] = this.genre_id;
    data['name'] = this.name;
    return data;
  }
}