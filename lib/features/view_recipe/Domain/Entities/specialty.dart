class Speciality {
  Speciality({
    this.id,
    required this.name,
  });

  int? id;
  String name;

  factory Speciality.fromJson(Map<String, dynamic> json) => Speciality(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
