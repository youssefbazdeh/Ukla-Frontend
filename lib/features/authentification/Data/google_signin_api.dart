import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:ukla_app/features/authentification/Domain/user_info.dart';
import '../../../core/Presentation/resources/strings_manager.dart';

class GoogleSignInApi {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: "176674262123-tplcpaa73ghvfp32n55da3hc66ivfnui.apps.googleusercontent.com",
    scopes: ['https://www.googleapis.com/auth/userinfo.profile'],
  );

  String? email;
  GoogleSignInAuthentication? googleKey;
  String? idToken;

  Future<GoogleSignInAccount?> _signIn() async {
    if (_googleSignIn.currentUser != null) {
      return _googleSignIn.currentUser;
    }
    var result = await _googleSignIn.signIn();
    email = result!.email;
    googleKey = await result.authentication;
    idToken = googleKey!.idToken;
    return result;
  }

  Future<String> sendIdToken(String idToken) async {
    var response = await http.post(
      Uri.parse('${AppString.SERVER_IP}/ukla/auth0/google-signin'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{'idtoken': idToken}),
    );
    switch (response.statusCode) {
      case 200:
        {
          Map<String, dynamic> tokens = json.decode(response.body);
          return tokens['access_token'];
        }
      case 406:
        return "ID token not valid";
      case 202:
        return "more user info required";
      case 307:
        return "link account";
      default:
        return "error";
    }
  }

  Future<String> linkAccount(String idToken, String password) async {
    var response = await http.post(
      Uri.parse('${AppString.SERVER_IP}/ukla/auth0/link-account/$password'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{'idtoken': idToken}),
    );
    switch (response.statusCode) {
      case 200:
        return "Your account is successfully linked, you can now log in with Google.";
      case 406:
        return "ID token not valid";
      case 401:
        return "Incorrect password";
      default:
        return "error";
    }
  }

  Future<String> getEmailFromGoogle() async {
    return email!;
  }

  Future<String> checkPasswordToLink(String password) async {
      return await linkAccount(idToken!, password);
  }

  Future<String> sendUserInfo(UserInfo userInfo) async {
    var response = await http.post(
      Uri.parse('${AppString.SERVER_IP}/ukla/auth0/google-signin/create_account'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userInfo.toJson()),
    );
    switch (response.statusCode) {
      case 200:
        {
          Map<String, dynamic> tokens = json.decode(response.body);
          return tokens['access_token'];
        }
      case 406:
        return "ID token not valid";
      case 226:
        return "account already exists";
      case 201:
        return "user saved verify email";
      default:
        return "error";
    }
  }

  Future<String> login() async {
    var result = await _signIn();
    if (result == null) {
      return "error";
    }

    if (idToken != null) {
      return await sendIdToken(idToken!);
    } else {
      return "error";
    }
  }

  Future<String> getIdToken() async {
    var result = await _signIn();
    if (result == null) {
      return "error";
    }
    if (idToken != null) {
      return idToken!;
    } else {
      return "error";
    }
  }

  void signOut() {
    email = "";
    idToken = "";
    googleKey = null;
    _googleSignIn.signOut();
  }
}
