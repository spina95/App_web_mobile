import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import '../../export.dart';

class DiscoverPage extends StatefulWidget {
  DiscoverPage({Key key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

Widget title(String text){
  return Container(
    height: 38,
    width: double.infinity,
    margin: EdgeInsets.only(left: 12),
    child: Text(text, style: TextStyle(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.w900),),
  );
}

class _DiscoverPageState extends State<DiscoverPage> {

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  void initState() { 
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  _fetchData() {
    return this._memoizer.runOnce(() async {
      return Future.wait([
        api.moviesOnTheathers(),
        api.upcomingMovies(),
        api.getNearestCinemas(),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text("Discover", style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w800)),
      ),
      body: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView(
              children: <Widget>[
                SizedBox(height: 0,),
                CarouselWithIndicator(snapshot.data[0]),
                SizedBox(height: 16,),
                title("Near you"),
                MapsWidget(snapshot.data[2]),
                SizedBox(height: 32),
                title("Upcoming"),
                upcomingMovies(snapshot.data[1])
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