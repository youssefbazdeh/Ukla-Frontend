class Tag {
  Tag({
    this.title,
    this.id,
  });

  int? id;
  String? title;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    title: json["title"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
    };
  }
}
