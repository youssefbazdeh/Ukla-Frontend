import 'dart:convert';

List<Allergy> allergiesListFromJson(String str) =>
    List<Allergy>.from(json.decode(str).map((x) => Allergy.fromJson(x)));

Allergy allergyFromJson(String str) => Allergy.fromJson(json.decode(str));

String allergyToJson(Allergy data) => json.encode(data.toJson());

class Allergy {
  Allergy({required this.id, required this.name, required this.imageId});

  int id;
  String name;
  int imageId;

  factory Allergy.fromJson(Map<String, dynamic> json) => Allergy(
        id: json["id"],
        name: json["name"],
        imageId: json["image"]["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
