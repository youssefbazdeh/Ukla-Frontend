import 'dart:convert';

Mail mailFromJson(String str) => Mail.fromJson(json.decode(str));

String mailToJson(Mail data) => json.encode(data.toJson());

class Mail {
  Mail({
    required this.email,
  });

  String? email;

  factory Mail.fromJson(Map<String, dynamic> json) => Mail(
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
      };
}
