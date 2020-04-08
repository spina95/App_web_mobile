import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/export.dart';

class CustomDialog extends StatefulWidget {

  List<Showtime> showtimes;
  DateTime datetimeselected;

  CustomDialog(this.showtimes, this.datetimeselected);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {

  @override
  void initState() {
    super.initState();
    widget.datetimeselected = DateTime(
      widget.datetimeselected.year,
      widget.datetimeselected.month,
      widget.datetimeselected.day,
      widget.showtimes[0].time.hour,
      widget.showtimes[0].time.minute
    );
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
      ),      
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 310,
        width: MediaQuery.of(context).size.width - 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Container(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  itemCount: widget.showtimes[0].end_date.difference(widget.showtimes[0].start_date).inDays,
                  separatorBuilder: (context, index){return SizedBox(width: 8,);},
                  itemBuilder: (context, index){
                    DateTime day = widget.showtimes[0].start_date.add(Duration(days: index));
                    return InkWell(
                      onTap: (){
                        setState(() {
                          widget.datetimeselected = DateTime(widget.datetimeselected.year, 
                          day.month, 
                          day.day,
                          widget.datetimeselected.hour,
                          widget.datetimeselected.minute);
                        });
                      },
                      child: Container(
                        height: 100,
                        width: 80,
                        decoration: BoxDecoration(
                          color: (widget.datetimeselected.day.compareTo(day.day) == 0 && widget.datetimeselected.month.compareTo(day.month) == 0) ? ColorsApp.PRIMARY_COLOR : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: (widget.datetimeselected.day.compareTo(day.day) == 0 && widget.datetimeselected.month.compareTo(day.month) == 0) ? ColorsApp.PRIMARY_COLOR
                           : Colors.blueAccent, 
                           width: 3)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(DateFormat("d").format(day), style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: (widget.datetimeselected.day.compareTo(day.day) == 0 && widget.datetimeselected.month.compareTo(day.month) == 0) ? Colors.white : Colors.black),),
                            Text(DateFormat("MMM").format(day), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: (widget.datetimeselected.day.compareTo(day.day) == 0 && widget.datetimeselected.month.compareTo(day.month) == 0) ? Colors.white : Colors.black),),
                          ],
                        ),
                      )
                    );
                  }
                ),
              )
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: Container(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  itemCount: widget.showtimes.length,
                  separatorBuilder: (context, index){return SizedBox(width: 8,);},
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                        setState(() {
                          widget.datetimeselected = DateTime(widget.datetimeselected.year,
                          widget.datetimeselected.month,
                          widget.datetimeselected.day,
                          widget.showtimes[index].time.hour,
                          widget.showtimes[index].time.minute);
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: (widget.datetimeselected.minute.compareTo(widget.showtimes[index].time.minute) == 0 && widget.datetimeselected.hour.compareTo(widget.showtimes[index].time.hour) == 0) ? ColorsApp.PRIMARY_COLOR : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: (widget.datetimeselected.minute.compareTo(widget.showtimes[index].time.minute) == 0 && widget.datetimeselected.hour.compareTo(widget.showtimes[index].time.hour) == 0) ? ColorsApp.PRIMARY_COLOR
                           : Colors.blueAccent, width: 3)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(DateFormat("HH:mm").format(widget.showtimes[index].time), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: (widget.datetimeselected.minute.compareTo(widget.showtimes[index].time.minute) == 0 && widget.datetimeselected.hour.compareTo(widget.showtimes[index].time.hour) == 0) ? Colors.white : Colors.black),),
                          ],
                        ),
                      )
                    );
                  }
                ),
              )
            ),
            FlatButton(
              child: Text("Confirm", style: TextStyle(color: Colors.blueAccent, fontSize: 18),), 
              onPressed: (){ Navigator.of(context).pop(widget.datetimeselected);},
            )
          ],
        ),
      ),
    );
  }
}