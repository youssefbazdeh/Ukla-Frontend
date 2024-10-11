import 'dart:convert';

import 'package:ukla_app/features/signup/Domain/gender.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.username,
    required this.email,
    required this.password,
    required this.gender
  });

  String firstName;
  String lastName;
  DateTime birthdate;
  String username;
  String email;
  String password;
  Gender gender;

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["firstName"],
        lastName: json["lastName"],
        birthdate: DateTime.parse(json["birthdate"]),
        username: json["username"],
        email: json["email"],
        password: json["password"],
        gender: Gender.values[json["gender"]]
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "birthdate":
            "${birthdate.year.toString().padLeft(4, '0')}-${birthdate.month.toString().padLeft(2, '0')}-${birthdate.day.toString().padLeft(2, '0')}",
        "username": username,
        "email": email,
        "password": password,
        "gender":gender.index
      };
}
