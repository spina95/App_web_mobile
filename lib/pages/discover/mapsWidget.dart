import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_app/pages/cinema/cinemaPage.dart';
import '../../export.dart';

class MapsWidget extends StatefulWidget {

  List<Cinema> cinemas;

  MapsWidget(List<Cinema> cinemas){
    this.cinemas = cinemas;
  }

  @override
  _MapsWidgetState createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {

  String urlMap(index){
    var queryParameters = {
      'key': 'oTa9qk0e7EnG3GXezp7VzytY9WtwkaDx',
      'center': widget.cinemas[index].latitude.toString() + ',' + widget.cinemas[index].longitude.toString(),
      'size': '170,170',
      'margin': '100',
      'zoom': '14',
      'type': 'map',
      'format': 'jpg70',
      'locations': widget.cinemas[index].latitude.toString() + ',' + widget.cinemas[index].longitude.toString()
    };
    var uri = Uri.https('www.mapquestapi.com', 'staticmap/v5/map', queryParameters);
    return uri.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child:GridView.count(
        crossAxisCount: 2,
        scrollDirection: Axis.horizontal,
        crossAxisSpacing: 0,
        children: new List<Widget>.generate(widget.cinemas.length, (index) {
          return Column(
            children: <Widget>[
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: InkWell(
                  onTap: () { 
                    Navigator.push(
                      context, CupertinoPageRoute(builder: (context) => CinemaPage(cinema: widget.cinemas[index],)));
                  },
                  child: Image.network(
                    urlMap(index),
                    height: 120,
                    width: 120,
                    fit: BoxFit.fill,
                  )
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
              ),
              SizedBox(height: 4,),
              Text(widget.cinemas[index].name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),)
            ],
          );
        }),
      )
    );
  }
}