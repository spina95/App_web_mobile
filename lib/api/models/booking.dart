import 'package:mobile_app/export.dart';

class Booking {
  int id_showtime;
  int id_profile;
  DateTime date;
  int row;
  int column;

  Booking(this.id_showtime, this.id_profile, this.date, this.row, this.column);

  Booking.fromJson(Map<String, dynamic> json) {
    id_showtime = json['id_showtime'];
    id_profile = json['id_profile'];
    date = json['datetime'];
    row = json['row'];
    column = json['column'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_showtime'] = this.id_showtime;
    data['id_profile'] = this.id_profile;
    data['date'] = conversions.dateToStringJson(this.date);
    data['row'] = this.row;
    data['column'] = this.column;
    return data;
  }
}