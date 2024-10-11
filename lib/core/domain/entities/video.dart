class Video {
  Video({
    required this.id,
    this.location,
    this.data,
    this.sasUrl
  });
  int id;
  String? location;
  String? sasUrl;
  dynamic content;
  dynamic data;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: json["id"],
    location: json["location"],
    sasUrl: json["sasUrl"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "location": location,
    "sasUrl": sasUrl,
    "data": data,
  };
}
