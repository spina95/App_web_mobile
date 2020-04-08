import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_app/export.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class MovieInfo extends StatefulWidget {

  Movie movie;
  MovieInfo({Key key, this.movie}) : super(key: key);

  @override
  _MovieInfoState createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfo> {

  List<Video> videos;
  Movie movieDetailed;
  bool lastStatus = true;
  double availableWidth = 180;
  ScrollController _scrollController;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
        if(isShrink)
          availableWidth = 0;
        else 
          availableWidth = 180;
      });
    } 
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  _launchURL() async {
    String url = 'https://www.youtube.com/watch?v=';
    bool check = false;
    if (videos.length != null)
      for(int i=0; i<videos.length; i++){
        if(videos[i].type == 'Trailer' && check == false){
          url += videos[i].key;
          check = true;
        }
      }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget roundButton(String text, Color color, Function onPressed){
      return Container(
        width: double.infinity,
        height: 35,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: FlatButton(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: onPressed,
        )
      );
    }

    Widget trailerButton(){
      if (videos.length != null)
      for(int i=0; i<videos.length; i++){
        if(videos[i].type == 'Trailer')
          return roundButton("Watch trailer", Colors.blueAccent, _launchURL);
      }
      return SizedBox(height: 0,);
    }

    Widget movieInfo(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(children: <Widget>[
            Text(movieDetailed.runtime.toString(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            Text("RUNTIME", style: TextStyle(color: Colors.black38))
          ],),
          Column(children: <Widget>[
            Text(movieDetailed.release_date.year.toString(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            Text("RELEASE", style: TextStyle(color: Colors.black38))
          ],),
          Column(children: <Widget>[
            Text(movieDetailed.vote_average.toString(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            Text("VOTE", style: TextStyle(color: Colors.black38),)
          ],)
        ],
      );
    }

    Widget poster(){
      return Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(movieDetailed.poster_path,
              height: 180,
            ),
          ),
          SizedBox(width: 16,),
          Expanded( child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              movieInfo(),
              SizedBox(height: 16,),
              roundButton("Showtimes", ColorsApp.PRIMARY_COLOR, (){}),
              SizedBox(height: 16,),
              trailerButton(),
            ],
          )),
        ],
      ));
    }

    Widget plot(){
      return Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("PLOT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),),
          SizedBox(height: 8,),
          Text(movieDetailed.overview, style: TextStyle(fontSize: 16),)
        ],
      ));
    }

    Widget cast(List<Cast> cast){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text("CAST", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800), ),
          ),
          SizedBox(height: 16,),
          Container(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cast.length >= 10 ? 10 : cast.length,
              separatorBuilder: (context, index){ return SizedBox(width: 16,);},
              itemBuilder: (context, index){
                return Container(
                  height: 140,
                  width: 140,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(cast[index].profile_path != null ? cast[index].profile_path : 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fsplashtacular.com%2Fabout-us%2Fperson-icon-01%2F&psig=AOvVaw3ilZ5SgU2jpRbQBt7mMlfl&ust=1586015434312000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCNiqy4XOzOgCFQAAAAAdAAAAABAJ',
                          height: 100,
                          width: 100,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(cast[index].name, style: TextStyle(fontWeight: FontWeight.w800), overflow: TextOverflow.ellipsis,),
                      Text(cast[index].character, overflow: TextOverflow.ellipsis,)
                    ]
                  )
                );
              },
            )
          )
        ],
      );
    }
   
    Widget infoCell(String title, String value){
      return  Container(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: <Widget>[
            Text(title + ": ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
            Expanded(child:Text(value, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16,),))
          ],
        )
      );
    }
    
    Widget info(List<Crew> crew){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text("CREW", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800), ),
          ),
          SizedBox(height: 16,),
          Container(
            height: 150,
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                    indent: 16,
                  ),
              itemCount: 3,
              itemBuilder: (context, index) {
                switch (index){
                  case 0:
                    List<Crew> directors = crew.where((test) => test.job == 'Director').toList();
                    String string = directors.map((object) => object.name).join(', ');
                    return infoCell("Director", string);
                  case 1:
                    List<Crew> directors = crew.where((test) => test.job == 'Producer').toList();
                    String string = directors.map((object) => object.name).join(', ');
                    return infoCell("Producer", string);
                  case 2:
                    List<Crew> directors = crew.where((test) => test.job == 'Screenplay').toList();
                    String string = directors.map((object) => object.name).join(', ');
                    return infoCell("Writing", string);
                  default:
                    return Container();
                }
              }
            )
          )
        ]
      );
    }
    
    return Scaffold(
      body: NestedScrollView(
        controller:_scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              elevation: 0,
              pinned: true,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: isShrink ? ColorsApp.PRIMARY_COLOR : Colors.white,),
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: isShrink ? true : false,
                  title:  Container(
                    margin: EdgeInsets.only(left: isShrink ? 60 : 0),
                    width: MediaQuery.of(context).size.width - availableWidth,
                    child: Text(widget.movie.original_title,
                      maxLines: isShrink ? 1 : 2,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: isShrink ? Colors.black54 : Colors.white,
                        fontSize: 16.0,
                      ))
                    ),
                  background: Stack(
                    children: [
                      Image.network(
                        widget.movie.backdrop_path,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        margin: EdgeInsets.all(0),
                        color: Colors.black26,
                      )
                    ]
                  )
                ),
            ),
          ];
        },
        body: FutureBuilder(
          future: Future.wait([
            api.movieCast(widget.movie.movie_id),
            api.movieCrew(widget.movie.movie_id),
            api.moviesInfo(widget.movie.movie_id),
            api.movieVideos(widget.movie.movie_id)
          ]),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              movieDetailed = snapshot.data[2];
              videos = snapshot.data[3];
              return Container(
                child: ListView(
                  children: <Widget>[
                    poster(),
                    SizedBox(height: 24,),
                    plot(),
                    SizedBox(height: 24,),
                    cast(snapshot.data[0]),
                    SizedBox(height: 24,),
                    info(snapshot.data[1]),
                  ],
                ),
              );
            }
            if(snapshot.hasError){
              print("errore");
            } else {
              return Center(child: CustomProgressIndicator());
            }
          }
        )
      ),
    );
  }
}