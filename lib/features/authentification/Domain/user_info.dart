// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));

String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
  UserInfo({
    this.birthdate,
    this.username,
    this.idtoken,
    this.gender,
  });

  DateTime? birthdate;
  String? username;
  String? idtoken;
  String? gender;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        birthdate: DateTime.parse(json["birthdate"]),
        username: json["username"],
        idtoken: json["idtoken"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "birthdate":
            "${birthdate?.year.toString().padLeft(4, '0')}-${birthdate?.month.toString().padLeft(2, '0')}-${birthdate?.day.toString().padLeft(2, '0')}",
        "username": username,
        "idtoken": idtoken,
        "gender": gender,
      };
}
