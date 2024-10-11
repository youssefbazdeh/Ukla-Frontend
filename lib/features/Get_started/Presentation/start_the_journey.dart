import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/shape/getstartedCustomshape.dart';
import '../../Preferences/Presentation/pages/preferences_screen.dart';

class StartJourney extends StatefulWidget {
  const StartJourney({Key? key}) : super(key: key);

  @override
  State<StartJourney> createState() => _StartJourneyState();
}

class _StartJourneyState extends State<StartJourney> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final heigth = MediaQuery.of(context).size.height;
    Color mainColor = const Color(0xFFFDFDFD);
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: Stack(children: [
            /*firststack child : the image */
            Row(
              children: [
                Expanded(
                    child: SizedBox(
                      child: Image.asset('assets/images/getstarted.jpg', fit:BoxFit.cover,),
                      width: width * 1.3,
                      height: heigth * 0.5,
                    )
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: heigth * 0.37),
              child: ClipPath(
                clipper: GetStartedMyCustomShape(),
                child: Container(
                  color: const Color(0XffFFA63E),
                  height: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: heigth * 0.38),
              child: ClipPath(
                clipper: GetStartedMyCustomShapeWithOpacity(),
                child: Container(
                  color: const Color(0XFFFFB54D),
                  height: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: heigth * 0.55, left: width / 10, right: width / 10),
              child: Text(
                "Welcome to the app that will change your life. ".tr(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                    letterSpacing: 0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: heigth * 0.75),
                  child: SizedBox(
                    height: 40,
                    width: width,
                    child: Padding(
                      padding: EdgeInsets.only(right: width / 10, left: width / 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        // onPressed: onPressed,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Preferences()));
                        },
                        child: Text(
                          "Start the journey".tr(context),
                          style:  TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            /*econd stack child : the orange clip  */
          ]),
        ));
  }
}