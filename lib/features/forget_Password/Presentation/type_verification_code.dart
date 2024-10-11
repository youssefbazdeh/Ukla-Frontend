import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/features/forget_Password/Presentation/type_new_password.dart';
import 'package:ukla_app/main.dart';
import 'package:ukla_app/features/forget_Password/Data/mail_service.dart';
import 'package:ukla_app/features/authentification/Data/userService.dart';
import 'package:ukla_app/core/Presentation/titles/inputTitle.dart';
import 'package:ukla_app/core/Presentation/titles/infoMsg.dart';

import '../../../core/Presentation/OTP/otp.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var bool = false;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 116,
              ),
              Padding(
                padding: EdgeInsets.only(left: width / 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [inputTitle("Verification code".tr(context))],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width / 10, right: width / 10, top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    infoMsg(
                        "Please type the verification code sent to your mail".tr(context))
                  ],
                ),
              ),
              const SizedBox(
                height: 51,
              ),
              //otp
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 10),
                child: const OTPwidget(),
              ),
              const SizedBox(
                height: 18,
              ),
              Visibility(
                visible: bool,
                child:  Text(
                  "Wrong code! Try again !".tr(context),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFFFF0000),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 40,
                    width: width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 0, horizontal: width / 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFFFA6375),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () async {
                          //setState();
                          var code = Provider.of<CodeModel>(context, listen: false).code;
                          var checkcoderesponse =
                              await UserService.checkCode1(code);
                          if (checkcoderesponse ==
                              "interface change your password") {
                            Provider.of<CodeModel>(context, listen: false)
                                .add(code);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const TypeNewPassword()));
                          }

                          if (checkcoderesponse == "invalid Token") {
                            var snackBar = SnackBar(
                              backgroundColor: const Color(0XFFFA6375),
                              content: Text(
                                'wrong code !'.tr(context),
                                style: TextStyle(fontSize: 20.sp),
                                textAlign: TextAlign.center,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }

                          Provider.of<CodeModel>(context, listen: false)
                              .add(code);
                        },
                        child: Text(
                          "confirm code".tr(context),
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 13,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                       TextSpan(
                          text: 'Did not receive a code ?'.tr(context),
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xff8E8E8E))),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            MailService.sendMail(
                                Provider.of<CodeModel>(context, listen: false)
                                    .getMail());
                          },
                        text: 'Resend'.tr(context),
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15.sp,
                          color: const Color(0xFFFA6375),
                        ),
                      )
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
