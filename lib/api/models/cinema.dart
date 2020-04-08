class Cinema {
  int id;
  String name;
  double ticket_price;
  double longitude;
  double latitude;

  Cinema.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ticket_price = json['ticket_price'];
    longitude = double.parse(json['longitude']);
    latitude = double.parse(json['latitude']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['ticket_price'] = this.ticket_price;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}