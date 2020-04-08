import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter/cupertino.dart';
import '../../export.dart';

Widget movieCarousel(Movie movie, Color color){
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Container(
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.network(movie.poster_path),
          SizedBox(width: 8,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(movie.original_title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                SizedBox(height: 12,),
                Text(
                  movie.vote_average.toString(),
                  textAlign: TextAlign.center, 
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )
              ],
            ),
          ),
          SizedBox(width: 8,),
        ],
      )
    ),
  );
}

class CarouselWithIndicator extends StatefulWidget {

  List<Movie> movies;

  CarouselWithIndicator(List<Movie> movies){
    this.movies = movies;
  }

  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  String genresToString(Movie movie){
    String out = "";
    for (var i=0; i<movie.genres.length; i++){
      if(i == movie.genres.length - 1)
        out += movie.genres[i].name;
      else 
        out += movie.genres[i].name + " • ";
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
          ),
          CarouselSlider.builder(
            autoPlay: true,
            height: 225,
            enableInfiniteScroll: false,
            viewportFraction: 1.0,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            itemCount: widget.movies.length,
            itemBuilder: (BuildContext context, int itemIndex) =>
              Container(
                  width: MediaQuery.of(context).size.width,
                  child:InkWell(
                  onTap: () { 
                    Navigator.push(
                      context, CupertinoPageRoute(builder: (context) => MovieInfo(movie: widget.movies[itemIndex])));
                  },
                  child: Container(
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Image.network(widget.movies[itemIndex].backdrop_path, fit: BoxFit.fill,),
                        Container(margin: EdgeInsets.only(top: 2, bottom: 2), color: Colors.black45,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 8,),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(widget.movies[itemIndex].poster_path, height: 200, ),
                            ),
                            SizedBox(width: 8,),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center, 
                                children: [
                                  Text(widget.movies[itemIndex].original_title, 
                                    textAlign: TextAlign.center,
                                    maxLines: 3, 
                                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 8,),
                                  Text(genresToString(widget.movies[itemIndex]),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  )
                                ]
                              )
                            ),
                            SizedBox(width: 8,),
                          ],
                        )
                      ]
                    ),
                  )
                )
              )
          ),
          Positioned(
            bottom: 0,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.movies.length, 
                (index){
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index ? Color.fromRGBO(0, 0, 0, 0.9) : Color.fromRGBO(0, 0, 0, 0.4)
                  ),
                );
              }),
            )
          )
        ]
    );
  }
}