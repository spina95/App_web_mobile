import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mobile_app/api/models/showtime.dart';
import '../export.dart';

class Api {
  Dio dio;
  final storage = FlutterSecureStorage();
  String SERVER_IP = "http://192.168.1.165:8000";

  Api(){
    BaseOptions options = new BaseOptions(
        baseUrl: SERVER_IP,
        connectTimeout: 5000,
        receiveTimeout: 3000,
    );
    dio = new Dio(options);
  }

  /// Return token or empty String
  Future<String> jwtOrEmpty() async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }

  /// Login with email and password
  Future login(String email, String password) async {
    try {
      Response response = await dio.post("/users/signin/",
      data: {
        'email': email,
        'password': password,
      });
      storage.write(key: "jwt", value: response.data['token']);
      currenUser = Profile.fromJson(response.data['user']);
      dio.options.headers["Authorization"] = "token " + response.data['token'];
    } on DioError catch(e) {  
      if(e.response != null) {
          throw "error 1";
      } else{
          print(e.request);
          print(e.message);
          throw "error 2";
      }
    }
  }

  /// Register a new user
  Future registerUser(String name, String surname, String date_of_birth, bool is_administrator, String email, String password1, String password2) async {
    try {
      Response response = await dio.post("/users/rest-auth/registration/",
      data: {
        'first_name': name,
        'last_name': surname,
        'date_of_birth': date_of_birth,
        'is_administrator': is_administrator,
        'email': email,
        'password1': password1,
        'password2': password2,
      });
      print(response.data.toString());
      print(response.data['token']);
      storage.write(key: "jwt", value: response.data['token']);
      dio.options.extra = {'Authorization': response.data['token']};
    } on DioError catch(e) {  
      if(e.response != null) {
          throw "error 1";
      } else{
          throw "error 2";
      }
    }
  }

  Future<Movie> moviesInfo(int id) async {
    try {
      Response response = await dio.get("/movie/info", queryParameters: {'movie_id': id});
      return Movie.fromJson(response.data);
    
    } on DioError catch(e) {  
      if(e.response != null) {
          throw "error 1";
      } else{
          throw "error 2";
      }
    }
  }

  Future<List<Movie>> moviesOnTheathers() async {
    try {
      Response response = await dio.get("/cinema/moviesincinema/");
      List ids = response.data.map((data) => data['movie_id']).toList();
      List<Response> list = await Future.wait(ids.map((itemId) => dio.get('/movie/info',
      queryParameters: {'movie_id': itemId},
      )));
      return list.map((response){
        // do processing here and return items
        return Movie.fromJson(response.data);
      }).toList();
    
    } on DioError catch(e) {  
      if(e.response != null) {
          throw "error 1";
      } else{
          throw "error 2";
      }
    }
  }

  Future<List<Movie>> upcomingMovies() async {
    try {
      Response response = await dio.get("/movie/upcoming");
      List<Movie> data = response.data.map<Movie>((m) => new Movie.fromJson(m)).toList();
      return data;
    } on DioError catch(e) {  
      if(e.response != null) {
          throw "error 1";
      } else{
          throw "error 2";
      }
    }
  }

  Future<List<Cast>> movieCast(int movie_id) async {
    try {
      Response response = await dio.get("/movie/cast", queryParameters: {'movie_id': movie_id});
      List<Cast> data = response.data.map<Cast>((m) => new Cast.fromJson(m)).toList();
      return data;
    } on DioError catch(e) {  
      if(e.response != null) {
          throw "error 1";
      } else{
          throw "error 2";
      }
    }
  }

  Future<List<Crew>> movieCrew(int movie_id) async {
    try {
      Response response = await dio.get("/movie/crew", queryParameters: {'movie_id': movie_id});
      List<Crew> data = response.data.map<Crew>((m) => new Crew.fromJson(m)).toList();
      return data;
    } on DioError catch(e) {  
      if(e.response != null) {
          throw "error 1";
      } else{
          throw "error 2";
      }
    }
  }

  Future<List<Video>> movieVideos(int movie_id) async {
    try {
      Response response = await dio.get("/movie/videos", queryParameters: {'movie_id': movie_id});
      List<Video> data = response.data.map<Video>((m) => new Video.fromJson(m)).toList();
      return data;
    } on DioError catch(e) {  
      if(e.response != null) {
          throw "error 1";
      } else{
          throw "error 2";
      }
    }
  }

  Future<List<Showtime>> showtimesInCinema(int cinema_id) async {
    try {
      Response response = await dio.get("/cinema/showtimes", queryParameters: {'cinema_id': cinema_id});
      List<Showtime> data = response.data.map<Showtime>((m) => new Showtime.fromJson(m)).toList();
      return data;
    } on DioError catch(e) {  
      if(e.response != null) {
          throw "error 1";
      } else{
          throw "error 2";
      }
    }
  }

  Future<List<Cinema>> getNearestCinemas() async {
    try {
      LocationData userLocation = await getUserLocation();
      Response response = await dio.get("/cinema/nearestCinemas", queryParameters: 
      {
        'latitude': userLocation.latitude,
        'longitude': userLocation.longitude
      });
      List<Cinema> data = response.data.map<Cinema>((m) => new Cinema.fromJson(m)).toList();
      return data;
    } on DioError catch(e) {  
      if(e.response != null) {
          throw "error 1";
      } else{
          throw "error 2";
      }
    } on Error catch(e){
      throw "error 3";
    }
  }

  Future book(List<Booking> bookings) async {
    try {
      var json = jsonEncode(bookings.map((e) => e.toJson()).toList());
      Response response = await dio.post("/cinema/booking", data: json);
      return;
    } on DioError catch(e) {  
      if(e.response != null) {
          throw "error 1";
      } else{
          throw "error 2";
      }
    } on Error catch(e){
      throw "error 3";
    }
  }

  Future<List<Booking>> getBookings(Showtime showtime, DateTime date) async {
    try {
      Response response = await dio.get("/cinema/booking", queryParameters: {"showtime_id": showtime.id, "date": conversions.dateToStringJson(date)});
      List<Booking> data = response.data.map<Booking>((m) => new Booking.fromJson(m)).toList();
      return data;
    } on DioError catch(e) {  
      if(e.response != null) {
          throw "error 1";
      } else{
          throw "error 2";
      }
    } on Error catch(e){
      throw "error 3";
    }
  }

  Future<List<Movie>> getUserMoviesWatched() async {
    try {
      var id = currenUser.id;
      Response response = await dio.get("/cinema/movieswatched", queryParameters: {"user_id": currenUser.id});
      List<Future<Movie>> futureMovies = List<Future<Movie>>();
      for(int i=0; i<response.data.length; i++){
        futureMovies.add(api.moviesInfo(response.data[i]));
      }
      var movies = await Future.wait(futureMovies);
      return movies;
    } on DioError catch(e) {  
      if(e.response != null) {
          throw "error 1";
      } else{
          throw "error 2";
      }
    } on Error catch(e){
      throw "error 3";
    }
  }

  Future<List<Ticket>> getTickets() async {
    try {
      var id = currenUser.id;
      Response response = await dio.get("/cinema/tickets", queryParameters: {"user_id": currenUser.id});
      List<Ticket> data = response.data.map<Ticket>((m) => new Ticket.fromJson(m)).toList();  
      return data;
    } on DioError catch(e) {  
      if(e.response != null) {
          throw "error 1";
      } else{
          throw "error 2";
      }
    } on Error catch(e){
      throw "error 3";
    }
  }
}