import 'dart:convert';

import 'package:ukla_app/features/signup/Domain/profileModel.dart';


import 'package:ukla_app/features/signup/Domain/gender.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    this.firstName,
    this.lastName,
    this.birthdate,
    required this.username,
    required this.email,
    required this.password,
    this.role,
    this.locked = false,
    this.enabled = false,
    this.resetPasswordToken,
    this.ingredientsOwned,
    this.ingredientsToHave,
    this.favoris,
    this.planOfWeek,
    this.gender,
    this.profile,
  });
  Profile? profile;
  int id;
  String? firstName;
  String? lastName;
  DateTime? birthdate;
  String username;
  String email;
  String password;
  Role? role;
  bool locked;
  bool enabled;
  String? resetPasswordToken;
  List<dynamic>? ingredientsOwned;
  List<dynamic>? ingredientsToHave;
  List<dynamic>? favoris;
  PlanOfWeek? planOfWeek;
  Gender? gender;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        firstName: json["firstName"],
        lastName: json["lastName"],
        birthdate: DateTime.parse(json["birthdate"]),
        username: json["username"],
        email: json["email"],
        password: json["password"],
        role: Role(json["role"]),
        locked: json["locked"],
        enabled: json["enabled"],
        resetPasswordToken: json["resetPasswordToken"],
        ingredientsOwned: List<dynamic>.from(json["ingredientsOwned"]?? []).map((x) => x).toList(),
        ingredientsToHave: List<dynamic>.from(json["ingredientsToHave"]?? []).map((x) => x).toList(),
        favoris: List<dynamic>.from(json["favoris"]?? []).map((x) => x).toList(),
        planOfWeek: json["planOfWeek"]!= null? PlanOfWeek.fromJson(json["planOfWeek"]) : null,
        gender: json["gender"] != null ? GenderExtension.fromString(json["gender"]) : null,
        profile: json["profile"]!= null? Profile.fromJson(json["profile"]) : null,
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "birthdate": birthdate != null
            ? "${birthdate?.year.toString().padLeft(4, '0')}-${birthdate?.month.toString().padLeft(2, '0')}-${birthdate?.day.toString().padLeft(2, '0')}"
            : null,
        "username": username,
        "email": email,
        "password": password,
        "role": role,
        "locked": locked,
        "enabled": enabled,
        "resetPasswordToken": resetPasswordToken,
        "ingredientsOwned": ingredientsOwned,
        "ingredientsToHave": ingredientsToHave,
        "favoris": favoris,
        "planOfWeek": planOfWeek?.toJson(),
        "gender": gender?.index,
      };
}

class Role {
  final String roleString;

  Role(this.roleString);
}

class PlanOfWeek {
  PlanOfWeek();

  factory PlanOfWeek.fromJson(Map<String, dynamic> json) => PlanOfWeek();

  Map<String, dynamic> toJson() => {};
}


//json used in quicktype

// {
//     "firstName" : "yassine",
//     "lastName" : "karoui", 
//     "birthdate" : "1999-01-06",
//     "username" : "BATOO",
//     "email" : "yassinekaroui1999@gmail.com",
//     "password" : "azerty123",
//     "role" : {},
// 	"locked":false,
// 	"enabled":false,
// 	"resetPasswordToken":"",
// 	"ingredientsOwned":[],
// 	"ingredientsToHave":[],
// 	"favoris":[],
// 	"planOfWeek":{}

// }