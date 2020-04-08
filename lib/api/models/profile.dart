import '../../export.dart';

class Profile {
  int id;
  String first_name;
  String last_name;
  String email;
  DateTime date_of_birth;
  bool is_administrator; 

  Profile({this.first_name, this.last_name, this.email, this.date_of_birth, this.is_administrator});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    first_name = json['first_name'];
    last_name = json['last_name'];
    email = json['email'];
    date_of_birth = conversions.stringJsonToDate(json['date_of_birth']);
    is_administrator = json['is_administrator'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.first_name;
    data['last_name'] = this.last_name;
    data['email'] = this.email;
    data['date_of_birth'] = conversions.dateToStringJson(this.date_of_birth);
    data['is_administrator'] = this.is_administrator;
    return data;
  }
}

Profile currenUser;