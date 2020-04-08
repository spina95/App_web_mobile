import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import '../../export.dart';

class CinemaPage extends StatefulWidget {

  Cinema cinema;

  CinemaPage({this.cinema});

  @override
  _CinemaPageState createState() => _CinemaPageState();
}

class _CinemaPageState extends State<CinemaPage> {

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  Future _fetchData() async {
    List<Showtime> showtimes = await api.showtimesInCinema(widget.cinema.id);
    List<int> movieids = List<int>();
    List<Future<Movie>> futureMovies = List<Future<Movie>>();
    for(int i=0; i<showtimes.length; i++){
      bool check = false;
      for (int el in movieids){
        if(el == showtimes[i].id)
          check = true;
      }
      if(check == false){
        movieids.add(showtimes[i].movie_id);
        futureMovies.add(api.moviesInfo(showtimes[i].movie_id));
      }
    }
    var movies = await Future.wait(futureMovies);
    return [showtimes, movies];
  }
  
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        iconTheme: IconThemeData(color: ColorsApp.PRIMARY_COLOR),
        title: Text(widget.cinema.name, style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w800)),
      ),
      body: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView(
              children: <Widget>[
                showtimesWidget(snapshot.data[0], snapshot.data[1], widget.cinema),
              ],
            );
          }
          if(snapshot.hasError){
            print("errore");
          } else {
            return Center(child: CustomProgressIndicator());
          }
        },
      )
    );
  }
}
