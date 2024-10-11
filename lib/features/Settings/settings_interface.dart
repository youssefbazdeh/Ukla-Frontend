import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ionicons/ionicons.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/features/authentification/Data/google_signin_api.dart';

import 'package:ukla_app/features/signup/Domain/user.dart';
import 'package:ukla_app/features/Settings/Account/Presentation/profile.dart';
import 'package:ukla_app/injection_container.dart';
import '../../main.dart';
import '../body_needs_estimation/presentation/pages/instructions.dart';
import 'app/presentation/languages.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late Future<User> userFuture;

  @override
  Widget build(BuildContext context) {
    double width = getDimensions(context)[1];

    return SafeArea(
      child: Material(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // color: Colors.black87,
                margin: const EdgeInsets.only(top: 23, left: 10),
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Text('Settings'.tr(context), style: TextStyle(fontSize: width < 600 ? 24.sp : 30.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  SettingCard(
                    text: 'Account'.tr(context),
                    destination: const Profile(),
                  ),
                  /* SettingCard(
                    text: 'Allergies list'.tr(context),
                    destination: const AllergicPage(
                      fromSettings: true,
                    ),
                  ), */
                  SettingCard(
                    text: 'Physical Activity Evaluation'.tr(context),
                  destination: const Instructions(showBackArrow: true,),
                  ),
                  SettingCard(
                    text: 'Language'.tr(context),
                    destination: const Languages(),
                  ),

                ///to uncomment feature settings to not delete
                  // SettingCard(
                  //   text: 'Tastes',
                  //   destination: null,
                  // ),
                  // SettingCard(
                  //   text: 'Preferences',
                  //   destination: null,
                  // ),
                  // SettingCard(
                  //   text: 'Help and support',
                  //   destination: null,
                  // ),
                  // SettingCard(
                  //   text: 'Privacy & terms of service',
                  //   destination: null,
                  // ),
                  // SettingCard(
                  //   text: 'About',
                  //   destination: null,
                  // ),
                  const LogoutCard(),
                ],
              ),
            ],
          ),
        ),
      ),
      );
  }
}

class SettingCard extends StatelessWidget {
  final StatefulWidget? destination;
  final String text;
  const SettingCard({Key? key, required this.text, required this.destination})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = getDimensions(context)[0],
        width = getDimensions(context)[1];

    return InkWell(
        onTap: () {
          destination != null
              ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => destination!))
              : null;
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: height / 45, horizontal: width / 20),
          child: Row(
            children: [
              Text(
                text,
                style: TextStyle(
                    fontSize: width < 600 ? 16.sp : 22.sp,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Ionicons.arrow_forward_outline),
            ],
          ),
        ));
  }
}

class LogoutCard extends StatelessWidget {
  const LogoutCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final googleSignInApi = sl<GoogleSignInApi>();
    double height = getDimensions(context)[0],
        width = getDimensions(context)[1];

    return InkWell(
        onTap: () async {
          await storage.delete(key: "jwt");
          googleSignInApi.signOut();
          Navigator.pushNamedAndRemoveUntil(
            context,
              "/login",
                (Route<dynamic> route) => false,
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: height / 45, horizontal: width / 20),
          child: Row(
            children: [
              Text(
                'Log out'.tr(context),
                style: TextStyle(
                    fontSize: width < 600 ? 16.sp : 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade400),
              ),
              const Spacer(),
              const Icon(Ionicons.arrow_forward_outline),
            ],
          ),
        ));
  }
}

List<double> getDimensions(BuildContext context) {
  double height, width;
  Orientation currentOrientation = MediaQuery.of(context).orientation;
  if (currentOrientation == Orientation.portrait) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
  } else {
    height = MediaQuery.of(context).size.width;
    width = MediaQuery.of(context).size.height;
  }
  return [height, width];
}
