import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ukla_app/core/Presentation/components/snack_bar.dart';
import 'package:ukla_app/core/Presentation/resources/routes_manager.dart';
import 'package:ukla_app/features/Splash_Screen/Domain/usecase/splash_usecase.dart';
import 'package:ukla_app/features/authentification/Domain/user_info.dart';
import 'package:ukla_app/features/authentification/Presentation/LinkAccountScreen.dart';
import 'package:ukla_app/injection_container.dart';

import '../Data/google_signin_api.dart';

const storage = FlutterSecureStorage();
final googleSignInApi = sl<GoogleSignInApi>();


Future signIn(BuildContext context) async {
  var res = await googleSignInApi.login();
  if (res == "ID token not valid" || res == "error") {
    var snackbar = CustomSnackBar(
      message: "google sign in not valid continue with email signin",
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  } else if (res == "more user info required") {
    Navigator.pushReplacementNamed(context, Routes.googeSignupRoute);
  } else if (res == "link account"){
      var email = await googleSignInApi.getEmailFromGoogle();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LinkAccountScreen(username: email))
      );
  } else {
    storage.write(key: "jwt", value: res);
    SplashUsecase().checkFirstSeen(context,false);
  }
}

Future createAccount(BuildContext context, UserInfo userInfo) async {
  String idtoken = await googleSignInApi.getIdToken();
  if (idtoken == "error") {
    return "error";
  }
  userInfo.idtoken = idtoken;

  var res = await googleSignInApi.sendUserInfo(userInfo);
  if (res == "ID token not valid" || res == "error") {
    var snackbar = CustomSnackBar(
      message: "google sign in not valid continue with email signin",
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  } else if (res == "account already exists") {
    var snackbar = CustomSnackBar(
      message: "account already exists",
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  } else if (res == "user saved verify email") {
    // Navigator.pushReplacementNamed(context, Routes.verifyemail);
    // to do take the user to verification
  } else {
    storage.write(key: "jwt", value: res);
    SplashUsecase().checkFirstSeen(context,true);
  }
}
