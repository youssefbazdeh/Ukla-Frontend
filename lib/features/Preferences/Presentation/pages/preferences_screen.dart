import 'package:flutter/material.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/features/body_needs_estimation/presentation/pages/instructions.dart';

import '../../../../core/Presentation/shape/PrefcustomShape.dart';

class Preferences extends StatefulWidget {
  const Preferences({Key? key}) : super(key: key);

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final heigth = MediaQuery.of(context).size.height;
    Color mainColor = const Color(0xFFFDFDFD);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Image.asset(
                    "assets/images/getstarted.jpg",
                    fit: BoxFit.cover,
                    width: width * 1.3,
                    height: heigth * 0.5,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: heigth * 0.4),
              child: ClipPath(
                clipper: PrefMyCustomShape(),
                child: Container(
                  color: mainColor,
                  height: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: heigth * 0.5, left: width / 10, right: width / 10),
              child: Text(
                "For a better experience we’re going to ask you some questions".tr(context),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
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
                    width: 160,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFFFA6375),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      // onPressed: onPressed,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const Instructions(showBackArrow: false,))));
                      },
                      child: const Text(
                        "Let's Go",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
