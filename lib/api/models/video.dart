class Video {
  String site;
  String key;
  String type;

  Video.fromJson(Map<String, dynamic> json) {
    site = json['site'];
    key = json['key'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['site'] = this.site;
    data['key'] = this.key;
    data['type'] = this.type;
    return data;
  }
}