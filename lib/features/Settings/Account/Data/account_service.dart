import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/domain/api_Service.dart';

import '../../../../main.dart';

//////change email from settings
Future<int> sendmail(String mail) async {
  final res = await http.post(
    Uri.parse('${AppString.SERVER_IP}/ukla/forgetPassword/forgot_password'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${await storage.read(key: "jwt")}',
    },
    body: jsonEncode(<String, dynamic>{
      'email': mail,
    }),
  );
  if (res.statusCode == 201 || res.statusCode == 200) {
    return 1;
  } else {
    throw Exception('Failed to send mail . ${res.statusCode}');
  }
}

////verify the email exists or not
Future<String> verifyEmailExistence(String newemail) async {
  var response = await http.post(
    Uri.parse(
        '${AppString.SERVER_IP}/ukla/mail/sendCodeForUpdateEmail?email=$newemail'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${await storage.read(key: "jwt")}',
    },
  );
  return response.body;
}

//change password from settings

Future<String> changepassword(String newpassword) async {
  var response = await http.put(
    Uri.parse('${AppString.SERVER_IP}/ukla/user/updatePassword'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Accept-Encoding': 'gzip, deflate, br',
      'authorization': 'Bearer ${await storage.read(key: 'jwt')}',
    },
    body: newpassword,
  );
  return response.body;
}

///change username
Future<int> changeUsername(int newId, String newUsername) async {
  var response = await http.put(
    Uri.parse('${AppString.SERVER_IP}/ukla/user/updateUsername'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${await storage.read(key: "jwt")}',
    },
    body: jsonEncode(<String, dynamic>{
      'id': newId,
      'username': newUsername,
    }),
  );
  return response.statusCode;
}

///change birthdate
Future<int> changeBirthdate(int newId, String newBirthdate) async {
  var response = await http.put(
    Uri.parse('${AppString.SERVER_IP}/ukla/user/updateBithdate'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${await storage.read(key: "jwt")}',
    },
    body: jsonEncode(<String, dynamic>{
      'id': newId,
      'birthdate': newBirthdate,
    }),
  );
  return response.statusCode;
}

Future<String> checkPasswordIsCorrect(String username, String password) async {
  var response = await HttpService().get('${AppString.SERVER_IP}/ukla/user/checkIfPasswordIsCorrect?username=$username&password=$password');
  return response.body;
}
