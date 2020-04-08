import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../export.dart';

Widget upcomingMovies(List<Movie> movies){
  return Container(
    height: 245,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      padding: EdgeInsets.only(left: 16, right: 16),
      separatorBuilder: (context, index){return SizedBox(width: 16,);},
      itemBuilder: (context, index){
        return Container(
          width: 150,
          child: InkWell(
            onTap: () { 
              Navigator.push(
                context, CupertinoPageRoute(builder: (context) => MovieInfo(movie: movies[index])));
            },
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(movies[index].poster_path, height: 190,),
                ),
                SizedBox(height: 8,),
                Text(movies[index].original_title, overflow: TextOverflow.clip, maxLines: 2, textAlign: TextAlign.center, style: TextStyle(fontSize: 16),)
              ],
            )
          )
        );
      }
    ),
  );
}