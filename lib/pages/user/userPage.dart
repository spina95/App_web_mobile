import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../export.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  Future _fetchData() async {
    //TODO: Unire ticket per lo stesso showtime e scaricare i dati del film
    List<Movie> moviesWatched = await api.getUserMoviesWatched();
    List<Ticket> tickets = await api.getTickets();
    List<int> movieids = List<int>();
    List<Future<Movie>> futureMovies = List<Future<Movie>>();
    for(int i=0; i<tickets.length; i++){
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

  Widget title(String text){
    return Container(
      height: 38,
      width: double.infinity,
      margin: EdgeInsets.only(left: 12),
      child: Text(text, style: TextStyle(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.w900),),
    );
  }

  Widget tickets(List<Ticket> tickets, List<Movie> movies){
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width,
      child: CarouselSlider.builder(
        autoPlay: false,
        height: 180,
        enableInfiniteScroll: false,
        viewportFraction: 0.9,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index){
          return InkWell(
            onTap: (){},
            child: Card(
              margin: EdgeInsets.all(8),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 7,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                height: 150,
                child: Row(
                  children: <Widget>[
                    Image.network(movies[index].poster_path)
                  ],
                ),
              )
            ),
          );
        }
      )
    );
  }

  Widget moviesWatched(List<Movie> movies){
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        itemCount: movies.length,
        separatorBuilder: (context, index) => SizedBox(width: 16,),
        itemBuilder: (context, index){
          return InkWell(
            onTap: () { 
              Navigator.push(
                context, CupertinoPageRoute(builder: (context) => MovieInfo(movie: movies[index])));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(movies[index].poster_path, height: 150,)
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text("Profile", style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w800)),
      ),
      body: FutureBuilder(
        future: Future.wait([
          api.getUserMoviesWatched(),
          api.getTickets()
        ]),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView(
              children: <Widget>[
                title("Tickets"),
                tickets(snapshot.data[1], snapshot.data[0]),
                SizedBox(height: 24,),
                title("Watched"),
                moviesWatched(snapshot.data[0])
              ],
            );
          }
          if(snapshot.hasError){

          }else {
            return Center(child: CustomProgressIndicator());
          }
        },
      )
    );
  }
}