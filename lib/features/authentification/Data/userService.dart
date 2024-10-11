import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/domain/api_Service.dart';
import 'package:ukla_app/core/utils/utils.dart';
import 'dart:convert' show json, jsonDecode, jsonEncode;
import 'package:ukla_app/features/signup/Domain/user.dart';
import 'package:ukla_app/main.dart';

class UserService {
  static Future<int> attemptLogIn(String username, String password) async {
    try {
      var res = await http.post(Uri.parse('${AppString.SERVER_IP}/ukla/login'),
          body: {
            "username": username,
            "password": password
          }).timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        Map<String, dynamic> tokens = json.decode(res.body);
        storage.write(key: "jwt", value: tokens['access_token']);
        storage.write(key: "refresh_token", value: tokens['refresh_token']);
        return 200;
      } else if (res.statusCode == 406) {
        return 406;
      } else if (res.statusCode == 500) {
        return 500;
      } else {
        return 400;
      }
    } on TimeoutException {
      return 408;
    } catch (e) {
      return 500;
    }
  }

  static Future<bool> isTokenExpired() async {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'jwt');

    if (accessToken != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      final expirationTime = decodedToken['exp'] * 1000; // in milliseconds
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      return expirationTime < currentTime;
    } else {
      throw Exception('Access token not found.');
    }
  }

  static Future<void> refreshToken() async {
    while (await isTokenExpired()) {
      const storage = FlutterSecureStorage();
      final refreshToken = await storage.read(key: 'refresh_token');

      final response = await http.post(
        Uri.parse('${AppString.SERVER_IP}/ukla/registration/refreshtoken'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      );

      if (response.statusCode == 200) {
        // Successfully got the new access token
        Map<String, dynamic> tokens = json.decode(response.body);
        storage.write(key: 'refresh_token', value: tokens['refresh_token']);
        storage.write(key: 'jwt', value: tokens['access_token']);
      }
    }
  }

  // fel methode hedhy badalt el controlleur fel back-end  maadech yekhou requestbody wala HttpServletRequest lawajt kifeh nbadalha malkitech donc pour le moment bech nekhdem haka
  static Future<http.Response> attemptSignUp(
      String firstname,
      String lastname,
      String birthdate,
      String username,
      String password,
      String email,
      String gender) async {
    var response = await http.post(
        Uri.parse('${AppString.SERVER_IP}/ukla/registration/user'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "firstName": firstname,
          "lastName": lastname,
          "birthdate": birthdate,
          "username": username,
          "password": password,
          "email": email,
          "gender": gender
        }));

    return response;
  }

  static Future<User> getUserByEmail(String email) async {
    var resp = await http.get(
      Uri.parse(
          "${AppString.SERVER_IP}/ukla/user/retrieveByEmail?email=$email"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'authorization': 'Bearer ${await storage.read(key: "jwt")}',
      },
    );

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      String date = jsonDecode(resp.body)['birthdate'];
      User user1 = User(
        username: jsonDecode(resp.body)['username'],
        id: jsonDecode(resp.body)['id'],
        email: jsonDecode(resp.body)['email'],
        password: jsonDecode(resp.body)['password'],
        birthdate: DateTime.parse(date),
      );

      return user1;
    } else {
      throw Exception("user doesn't exist");
    }
  }

  /* checkCode future */
  static Future<String> checkCode1(String code1) async {
    final res = await HttpService().post(
        '${AppString.SERVER_IP}/ukla/forgetPassword/reset_password?token=$code1',
        "");

    return (res.body);
  }

  static Future<User> getUserByUsername(String username) async {
    var resp = await HttpService().post(
        "${AppString.SERVER_IP}/ukla/user/retrieveByUsername",
        jsonEncode({"username": username}));

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return User.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception("user doesn't exist");
    }
  }

  static Future<bool> setOnBoaardingScreenToFalseAfterFirstLogin(
      String username) async {
    String? url = "${AppString.SERVER_IP}/ukla/user/setOnBoardingScreenToFalse";
    var resp = await HttpService().put(url, '');
    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  ///Checks if the username exists in the database
  ///
  ///Retuns `true` if it exists and `false` if it doesn’t exist.
  static Future<bool> checkUsernameExistence(String username) async {
    try {
      var resp = await HttpService().post(
          "${AppString.SERVER_IP}/ukla/registration/usernameexists",
        username);
      if (resp.statusCode == 406) {
        return true;
      }
      if (resp.statusCode == 200) {
        return false;
      } else {
        throw Exception("user doesn't exist");
      }
    } catch (e) {
      Utils.printf("Exception caught: $e");
      return true;
    }
  }
}
