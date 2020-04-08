import '../../export.dart';

class Showtime {
  int id;
  int id_room;
  int movie_id;
  DateTime start_date;
  DateTime end_date;
  DateTime time;
  int room;

  Showtime.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    id_room = json['id_room'];
    movie_id = json['movie_id'];
    start_date = conversions.stringJsonToDate(json['start_date']);
    end_date = conversions.stringJsonToDate(json['end_date']);
    time = conversions.stringJsonToTime(json['time']);
    room = json['room'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_room'] = this.id_room;
    data['movie_id'] = this.movie_id;
    data['start_date'] = this.start_date;
    data['end_date'] = this.end_date;
    data['time'] = this.time;
    data['room'] = this.room;
    return data;
  }
}