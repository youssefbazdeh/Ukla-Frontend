import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/inputs/InputField.dart';
import 'package:ukla_app/core/Presentation/buttons/main_red_button.dart';
import 'package:ukla_app/features/Settings/Account/Presentation/verification_code_from_settings.dart';
import '../Data/account_service.dart';

class ChangeEmailFromSettings extends StatefulWidget {
  const ChangeEmailFromSettings({Key? key}) : super(key: key);

  @override
  _RedirectionToTypeCodeState createState() => _RedirectionToTypeCodeState();
}

class _RedirectionToTypeCodeState extends State<ChangeEmailFromSettings> {
  final TextEditingController _emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(children: [
                      InkResponse(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Ionicons.arrow_back)),
                      const SizedBox(width: 15),
                           Flexible(
                            child: Text("Modify Email title".tr(context),
                          style: TextStyle(
                              fontSize: 24.sp, fontWeight: FontWeight.bold))
                           )
                    ]),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 21,
                          left: size.width / 10,
                          right: size.width / 10,
                          bottom: 10),
                      // ignore: avoid_unnecessary_containers
                      child: Container(
                        child:  Text(
                          "Modify Email text".tr(context),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              letterSpacing: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              InputField(
                  labelText: "Email address".tr(context),
                  hintText: "Email Adress",
                  textEditingController: _emailcontroller),
              const SizedBox(
                height: 50,
              ),
              MainRedButton(
                  onPressed: () async {
                    if (_emailcontroller.text.isNotEmpty) {
                      ///////tverify l email msh mawjoud aand user ekher
                      var response =
                          await verifyEmailExistence(_emailcontroller.text);

                      if (response == 'reset email token sent') {
                        sendmail(_emailcontroller.text);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    VerificationCodeFromSettings(
                                      newEmail: _emailcontroller.text,
                                    )));
                      } else if (response == 'email already used') {
                        var snackBar = SnackBar(
                          backgroundColor: const Color(0XFFFA6375),
                          content: Text(

                            "This email is already registered".tr(context),
                            style: TextStyle(fontSize: 16.sp),
                            textAlign: TextAlign.center,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }

                      //////invalid email (REGEX)
                      ///
                    } else if (_emailcontroller.text.isEmpty) {
                      var snackBar = SnackBar(
                        backgroundColor: const Color(0XFFFA6375),
                        content: Text(
                          "Please insert your email".tr(context),
                          style: TextStyle(fontSize: 16.sp),
                          textAlign: TextAlign.center,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  text: "Send code".tr(context)),
              const SizedBox(
                height: 70,
              ),
            ],
          ),
        ]),
      ),
    ));
  }
}
