import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/OTP/otp.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/features/authentification/Presentation/LoginScreenUpdated.dart';
import 'package:ukla_app/main.dart';
import 'package:ukla_app/core/Presentation/titles/inputTitle.dart';
import 'package:ukla_app/core/Presentation/titles/infoMsg.dart';

import '../Data/Account_service.dart';

class TypeVerfificationCode extends StatefulWidget {
  const TypeVerfificationCode({required this.email, key}) : super(key: key);
  final String email;
  @override
  State<TypeVerfificationCode> createState() => _TypeVerfificationCodeState();
}

class _TypeVerfificationCodeState extends State<TypeVerfificationCode> {
  bool _isLoading = false;
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
                  children: [inputTitle("Activation code".tr(context))],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width / 10, right: width / 10, top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    infoMsg(
                        "Please type the activation code sent to your mail".tr(context))
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
                child: Text(
                  "Wrong code! Try again !".tr(context),
                  style:  TextStyle(
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
                              await SignupService.checkCodeActivation(code);
                          if (checkcoderesponse == "confirmed") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LoginScreenUpdated()));
                          } else if (checkcoderesponse ==
                              "email already confirmed") {
                            displayDialog(context, "email already confirmed !".tr(context),
                                "email already confirmed !".tr(context));
                          } else if (checkcoderesponse == "token expired") {
                            displayDialog(
                                context, "token expired".tr(context), "token expired".tr(context));
                          } else {
                            //to verify
                            displayDialog(context, "Error occured".tr(context),
                                "You have submitted a wrong code please verif your code.".tr(context));
                          }
                        },
                        child: Text(
                          "confirm code".tr(context),
                          style:  TextStyle(
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
                          style:  TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xff8E8E8E))),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // show the loading dialog
                            showDialog(
                              context: context,
                              barrierDismissible:
                                  false, // dialog cannot be dismissed by tapping outside
                              builder: (BuildContext context) {
                                return  Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: SizedBox(
                                      height: 800 / 6,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                           const CircularProgressIndicator(color: AppColors.secondaryColor, strokeWidth: 2.0,),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Expanded(
                                              child: Text(
                                            "We are sending the mail to you...".tr(context),
                                            textAlign: TextAlign.center,
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                            Future future = SignupService.resendActivationCode(
                                widget.email);

                            future.then((res) {
                              setState(() {
                                _isLoading =
                                    false; // set isLoading to false when future is completed
                              });
                              Navigator.pop(
                                  context); // close the loading dialog

                              switch (res) {
                                case 201:
                                  break;
                                case 200:
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    "Success The user was created verify your email to be able to login".tr(context),
                                  )));

                                  break;
                                default:
                                  ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                      backgroundColor: const Color(0XFFFA6375),
                                      content: Text(
                                        "error occured please verify your internet connection".tr(context),
                                        style:  TextStyle(fontSize: 20.sp),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );

                                  break;
                              }
                            });
                          },
                        text: 'Resend'.tr(context),
                        style:  TextStyle(
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

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
}
