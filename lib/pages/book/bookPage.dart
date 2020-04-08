import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../export.dart';

class Seat {
  int row;
  int column;

  Seat({this.row, this.column});
}

class BookPage extends StatefulWidget {

  List<Showtime> showtimes;
  Cinema cinema;

  BookPage({Key key, this.showtimes, this.cinema}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {

  Showtime showtimeSelected;
  List<Booking> seatsOccupied;
  List<Seat> seatsReserved = List<Seat>();
  DateTime datetimeselected;
  DateTime prevDatetimeSelected;

  Future fetchData() async{
    if(prevDatetimeSelected != datetimeselected){
      prevDatetimeSelected = datetimeselected;
      return await api.getBookings(showtimeSelected, datetimeselected);
    } else {
      return seatsOccupied;
    }
  }

  void selectDatetime(){
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(widget.showtimes, datetimeselected)
    ).then((value){
      setState(() {
        datetimeselected = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    showtimeSelected = widget.showtimes[0];
    datetimeselected = DateTime(
      widget.showtimes[0].start_date.year, 
      widget.showtimes[0].start_date.month, 
      widget.showtimes[0].start_date.day, 
      widget.showtimes[0].time.hour, 
      widget.showtimes[0].time.minute
    );
    prevDatetimeSelected = DateTime.now();
  }

  bool seatReserved(int row, int col){
    for(Seat el in seatsReserved){
      if(el.row == row && el.column == col)
        return true;
    }
    return false;
  }

  bool seatOccupied(int row, int col){
    for(Booking el in seatsOccupied){
      if(el.row == row && el.column == col)
        return true;
    }
    return false;
  }

  void book() async {
    if(seatsReserved.length != 0){
      List<Booking> bookings = List<Booking>();
      for(Seat el in seatsReserved){
        Booking book = Booking(showtimeSelected.id, currenUser.id, datetimeselected, el.row, el.column);
        bookings.add(book);
      }
      api.book(bookings).then((response){
            Widget okButton = FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.push(
                      context, CupertinoPageRoute(builder: (context) => HomePage()));
              },
            );
            AlertDialog alert = AlertDialog(
              title: Text("Your reservation is confirmed"),
              actions: [
                okButton,
              ],
            );
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
          }
      );
    }
  }

  Widget columnText(String value, String text, void function()){
    return InkWell(
      onTap: function,
      child: Column(
        children: <Widget>[
          Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),),
          Text(text, style: TextStyle(fontSize: 16),)
        ],
      )
    );
  }

  int rows = 10;
  int columns = 14;

  Widget seats(){
    double seatSize = 25;
    return Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              CustomPaint(painter: CurvePainter(), child: Container( height: 70, width: 300,),),
              Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 220,
              child: Center(child: ListView.separated(
                itemCount: rows,
                separatorBuilder: (context, index){return SizedBox(height: 16,);},
                itemBuilder: (context, index){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(columns, 
                    (column){
                      return Container(
                        height: seatSize,
                        width: seatSize,
                        padding: EdgeInsets.all(3),
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              if(seatReserved(index, column) == true){
                                for(int i=0; i<seatsReserved.length; i++){
                                  if(seatsReserved[i].row == index && seatsReserved[i].column == column)
                                    seatsReserved.removeAt(i);
                                }
                              } else if(!seatOccupied(index, column)) {
                                seatsReserved.add(Seat(row: index, column: column));
                              }

                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: seatReserved(index, column) ? Colors.blueAccent : 
                                seatOccupied(index, column) ? Colors.white : Colors.transparent,
                              border: seatReserved(index, column) ? Border.all(color: Colors.transparent) : Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(4)
                            ),
                          ),
                        )
                      );
                    }),
                  );
                }
              )
            )
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         elevation: 0,
         backgroundColor: ColorsApp.PRIMARY_COLOR,
       ),
       body: SlidingUpPanel(
         minHeight: 100,
         maxHeight: 200,
         boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 1, color: Colors.black38)],
         borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
         panel: Padding(
           padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: <Widget>[
               Padding(
                 padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     columnText(DateFormat('d MMM').format(datetimeselected), "Date", selectDatetime),
                     columnText(DateFormat('H:mm').format(datetimeselected), "Time", selectDatetime),
                     columnText(seatsReserved.length.toString(), "Seats", null)
                   ],
                 )
               ),
               Padding(
                 padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     columnText((seatsReserved.length * widget.cinema.ticket_price).toString() + "€", "Price", null),
                     Container(
                       height: 100,
                       width: MediaQuery.of(context).size.width/2,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.only(topLeft: Radius.circular(24)),
                         color: ColorsApp.PRIMARY_COLOR,
                        ),
                        child: FlatButton(
                          child: Text("Confirm", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),),
                          onPressed: book,
                        ),
                      )
                    ],
                 )
               )
             ],
           ),
         ),
         body: FutureBuilder(
           future: fetchData(),
           builder: (context, snapshot){
             if(snapshot.hasData){
               seatsOccupied = snapshot.data;
               return Stack(
                children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: ColorsApp.PRIMARY_COLOR,
                    ),
                    seats()
                ],
              );
             } else if(snapshot.hasError){
               return Text("Error");
             }
             else {
               return CustomProgressIndicator();
             }
           },
         )
                      
       ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;

    var startPoint = Offset(0, size.height / 2);
    var controlPoint1 = Offset(size.width / 4, size.height / 3);
    var controlPoint2 = Offset(3 * size.width / 4, size.height / 3);
    var endPoint = Offset(size.width, size.height / 2);

    var path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy,
        endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}