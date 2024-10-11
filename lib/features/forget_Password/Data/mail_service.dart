import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';

class MailService {
  static Future<int> sendMail(String mail) async {
    final res = await http.post(
      Uri.parse('${AppString.SERVER_IP}/ukla/forgetPassword/forgot_password'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{
        'email': mail,
      }),
    );
    return (res.statusCode);
  }

  static Future<int> updatePassword(dynamic code, String newPassword) async {
    final res = await http.put(
      Uri.parse('${AppString.SERVER_IP}/ukla/forgetPassword/updatePassword1'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body:
          jsonEncode(<dynamic, dynamic>{'code': code, 'password': newPassword}),
    );
    return res.statusCode;
  }
}
