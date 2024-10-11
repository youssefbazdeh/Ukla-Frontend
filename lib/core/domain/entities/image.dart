class Image {
  Image({
    required this.id,
    this.location,
    this.data,
  });
  int id;
  String? location;
  dynamic content;
  dynamic data;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        location: json["location"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "location": location,
        "data": data,
      };
}
