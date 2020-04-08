import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_app/api/models/showtime.dart';
import 'package:intl/intl.dart';
import '../../export.dart';

class ShowtimeAndTimes{
  Cinema cinema;
  List<Showtime> showtimes = List<Showtime>();
  Movie movie;
}

String timesToString(List<Showtime> showtimes){
  showtimes.sort((a, b) => a.time.compareTo(b.time));
  DateFormat formattedDate = DateFormat('HH:mm');
  return showtimes.map((object) => formattedDate.format(object.time)).join(' | ');
}

Widget showtimesWidget(List<Showtime> showtimes, List<Movie> movies, Cinema cinema){

  List<ShowtimeAndTimes> showtimesList = List<ShowtimeAndTimes>();
  List<Movie> moviesList = List<Movie>();
  for(Showtime el in showtimes){
    bool check = false;
    Movie m;
    for(Movie movie in movies){
      if(movie.movie_id == el.movie_id)
        m = movie;
    }
    for(ShowtimeAndTimes el2 in showtimesList){
      if(el.room == el.room && el2.movie.movie_id == el.movie_id){
        el2.showtimes.add(el);
        el2.movie = m;
        check = true;
      }
    }
    if(check == false){
      ShowtimeAndTimes sh = ShowtimeAndTimes();
      sh.cinema = cinema;
      sh.showtimes.add(el);
      sh.movie = m;
      showtimesList.add(sh);
    }
  }

  return Container(
    height: 182 * movies.length.toDouble(),
    child: ListView.separated(
      itemCount: showtimesList.length,
      separatorBuilder: (context, index){return Divider(color: Colors.black45);},
      itemBuilder: (context, index){
        Movie movie;
        for(Movie el in movies){
          if(el.movie_id == showtimesList[index].showtimes[0].movie_id)
            movie = el;
        }
        return Container(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: InkWell(
            child: Row(
              children: <Widget>[
                Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () { 
                      Navigator.push(
                        context, CupertinoPageRoute(builder: (context) => MovieInfo(movie:showtimesList[index].movie)));
                    },
                    child: Image.network(
                      showtimesList[index].movie.poster_path,
                      height: 130,
                    ),
                  )
                ),
                SizedBox(width: 8,),
                Expanded(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(showtimesList[index].movie.original_title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Room " + showtimesList[index].showtimes[0].room.toString(), style: TextStyle(fontSize: 16),),
                        Text(timesToString(showtimesList[index].showtimes), style: TextStyle(fontSize: 16),)
                      ]
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      height: 35,
                      decoration: BoxDecoration(
                        color: ColorsApp.PRIMARY_COLOR,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: FlatButton(
                        child: Text(
                          "Book",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        onPressed: () { 
                          Navigator.push(
                            context, CupertinoPageRoute(builder: (context) => BookPage(showtimes: showtimesList[index].showtimes, cinema: showtimesList[index].cinema)));
                        },
                      )
                    )
                  ],
                ))
              ],
            )
          ),
        );
      },
    ),
  );
}