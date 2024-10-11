// To parse this JSON data, do
//
//     final msg = msgFromJson(jsonString);

import 'dart:convert';

Msg msgFromJson(String str) => Msg.fromJson(json.decode(str));

String msgToJson(Msg data) => json.encode(data.toJson());

class Msg {
  Msg({
    required this.msg,
  });

  String msg;

  factory Msg.fromJson(Map<String, dynamic> json) => Msg(
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
      };
}
