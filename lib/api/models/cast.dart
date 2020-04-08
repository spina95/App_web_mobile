class Cast {
  int cast_id;
  String character;
  String name;
  String profile_path;

  Cast.fromJson(Map<String, dynamic> json) {
    cast_id = json['cast_id'];
    character = json['character'];
    name = json['name'];
    profile_path = json['profile_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cast_id'] = this.cast_id;
    data['character'] = this.character;
    data['name'] = this.name;
    data['profile_path'] = this.profile_path;
    return data;
  }
}