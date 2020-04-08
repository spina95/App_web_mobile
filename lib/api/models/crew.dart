class Crew {
  String department;
  String job;
  String name;
  String profile_path;

  Crew.fromJson(Map<String, dynamic> json) {
    department = json['department'];
    job = json['job'];
    name = json['name'];
    profile_path = json['profile_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['department'] = this.department;
    data['job'] = this.job;
    data['name'] = this.name;
    data['profile_path'] = this.profile_path;
    return data;
  }
}