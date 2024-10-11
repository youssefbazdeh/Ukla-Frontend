import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/components/snack_bar.dart';
import 'package:ukla_app/core/Presentation/inputs/InputField.dart';
import 'package:ukla_app/core/Presentation/inputs/InputFieldPass.dart';
import 'package:ukla_app/core/Presentation/buttons/main_red_button.dart';
import 'package:ukla_app/core/Presentation/resources/assets_manager.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/core/analytics/events.dart';
import 'package:ukla_app/features/authentification/Data/userService.dart';
import 'package:ukla_app/features/authentification/Domain/google_sign_in.dart';
import 'package:ukla_app/features/signup/Domain/user.dart';
import '../../../core/Presentation/resources/routes_manager.dart';
import '../../Splash_Screen/Domain/usecase/splash_usecase.dart';
import '../../forget_Password/Presentation/type_email.dart';

class LoginScreenUpdated extends StatefulWidget {
  const LoginScreenUpdated({Key? key}) : super(key: key);

  @override
  _LoginScreenUpdatedState createState() => _LoginScreenUpdatedState();
}

class _LoginScreenUpdatedState extends State<LoginScreenUpdated> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool loading = true;
  final userService = UserService();
  final _formKey = GlobalKey<FormState>();

  int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(title), content: Text(text)),
      );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: AutofillGroup(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: size.height / 16),
                  Container(
                      constraints: BoxConstraints(
                        maxWidth: size.height / 6, // Maximum width
                        maxHeight: size.width * 0.8, // Maximum height
                      ),
                      child: Image.asset(ImageAssets.loginLogo)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 21, left: size.width / 10, right: size.width / 10, bottom: 0),
                          child: Text(
                            "Login to your account ".tr(context),
                            style: TextStyle(fontSize: 24.sp, fontFamily: 'Noto_Sans', fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (loading) ...[
                    /*** user name / login  input    ********/
                    InputField(
                        labelText: 'Username'.tr(context),
                        hintText: "Username".tr(context),
                        textEditingController: _usernameController,
                        autofillHints: const [AutofillHints.username],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'username is required'.tr(context);
                          } else {
                            return null;
                          }
                        }),
                    InputFieldPass(
                        labelText: 'Password'.tr(context),
                        hintText: 'Password'.tr(context),
                        textEditingController: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'password is required'.tr(context);
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(
                      height: 40,
                    ),
                    MainRedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var username = _usernameController.text;
                          var password = _passwordController.text;

                          setState(() {
                            loading = false;
                          });

                          int isConnected = await UserService.attemptLogIn(username, password);

                          await Future.delayed(const Duration(milliseconds: 800));
                          if (isConnected == 200) {
                            User user = await UserService.getUserByUsername(username);
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('user_role', user.role!.roleString);
                            FireBaseAnalyticsEvents.onUserLogin(user.email, user.gender!.toString(), calculateAge(user.birthdate!), user.username);
                            SplashUsecase().checkFirstSeen(context, user.profile!.onBoardingScreen);
                            if (user.profile!.onBoardingScreen) {
                              await UserService.setOnBoaardingScreenToFalseAfterFirstLogin(username);
                            }
                          } else if (isConnected == 406) {
                            setState(() {
                              loading = true;
                            });

                            var snackBar = CustomSnackBar(
                              message: "Invalid Username or Password".tr(context),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } else if (isConnected == 500) {
                            setState(() {
                              loading = true;
                            });
                            var snackBar = CustomSnackBar(
                              message: "An error occurred, try again later".tr(context),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } else if (isConnected == 408) {
                            setState(() {
                              loading = true;
                            });
                            var snackBar = CustomSnackBar(
                              message: "Connection timed out, please check your internet connection".tr(context),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } else {
                            setState(() {
                              loading = true;
                            });
                            var snackBar = CustomSnackBar(
                              message: "An unexpected error occurred, try again later".tr(context),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        }
                      },
                      text: 'Login'.tr(context),
                    ),
                  ] else ...[
                    const CircularProgressIndicator(
                      color: AppColors.secondaryColor,
                      strokeWidth: 2.0,
                    ),
                  ],
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (() {
                          // if (_usernameController.text.length != 0) {
                          if (loading) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const RedirectionToTypeCode()));
                          } else {
                            null;
                          }
                        }),
                        child: Text(
                          "Forgot your password ?".tr(context),
                          style: TextStyle(fontSize: 14.sp, decoration: TextDecoration.underline, color: Colors.grey.shade800),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text("or continue with".tr(context)),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.signupRoute);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(16.0), // Adjust the padding as needed
                            elevation: 5.0, // Adjust the elevation as needed
                          ),
                          child: SvgPicture.asset(
                            "assets/icons/mail-outline.svg",
                            height: 33,
                            width: 33,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      // !! do not delete we will add google signup after the verification
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            signIn(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(16.0), // Adjust the padding as needed
                            elevation: 5.0, // Adjust the elevation as needed
                          ),
                          child: SvgPicture.asset(
                            "assets/icons/icons8-logo-google.svg",
                            height: 33,
                            width: 33,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //commenting continue with FB
                  /*Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: size.width / 10),
                        child: ElevatedButton.icon(
                          icon: SvgPicture.asset(
                            "assets/icons/icons8-facebook-nouveau.svg",
                            height: 24,
                            width: 24,
                          ),
                          style: ElevatedButton.styleFrom(
                            surfaceTintColor:
                                const Color.fromARGB(214, 11, 121, 230),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {},
                          label: const Text(
                            "Continue with Facebook",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),*/
                  SizedBox(
                    height: size.height / 100,
                  ),
                  Row(
                    textDirection: TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.termsOfService);
                          },
                          child: Text(
                            'Terms of Service'.tr(context),
                            style: TextStyle(fontSize: 14.sp, decoration: TextDecoration.underline, color: Colors.grey.shade800),
                          )),
                      Text(
                        'and'.tr(context),
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.privacyPolicy);
                          },
                          child: SizedBox(
                            width: size.width / 4,
                            child: Text(
                              'Privacy Policy'.tr(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14.sp, decoration: TextDecoration.underline, color: Colors.grey.shade800),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
