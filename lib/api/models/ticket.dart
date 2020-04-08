import 'package:intl/intl.dart';

import '../../export.dart';

class Ticket {
  int id;
  int movie_id;
  DateTime datetime;
  int id_profile;
  int row;
  int column;

  Ticket(this.id, this.movie_id, this.datetime, this.id_profile, this.row, this.column);

  Ticket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    movie_id = json['movie_id'];
    DateTime date = conversions.stringJsonToDate(json['date']);
    DateTime time = conversions.stringJsonToTime(json['time']);
    datetime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    id_profile = json['id_profile'];
    row = json['row'];
    column = json['column'];
  }
}