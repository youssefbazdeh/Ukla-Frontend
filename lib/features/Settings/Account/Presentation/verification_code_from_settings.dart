
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';

import 'package:ukla_app/features/Settings/Account/Presentation/profile.dart';

import 'package:ukla_app/core/Presentation/titles/infoMsg.dart';

import '../../../../core/Presentation/OTP/otp.dart';
import '../../../../main.dart';

class VerificationCodeFromSettings extends StatefulWidget {
  final String newEmail;
  const VerificationCodeFromSettings({Key? key, required this.newEmail})
      : super(key: key);

  @override
  State<VerificationCodeFromSettings> createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<VerificationCodeFromSettings> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    // String body = '';
    var bool = false;

    /* checkCode future */

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(children: [
                  InkResponse(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Ionicons.arrow_back)),
                  const SizedBox(width: 15),
                   Text('Verification Code',
                      style:
                          TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold))
                ]),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width / 10, right: width / 10, top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    infoMsg(
                        "Please type the verification code sent to your email ")
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
                  "Wrong code! Try again !",
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
          
                      

                            var updateRes = await http.put(
                              Uri.parse(
                                  '${AppString.SERVER_IP}/ukla/mail/updateNewEmail?token=$code&email=${widget.newEmail}'),
                              headers: <String, String>{
                                'Content-Type': 'application/json'
                              },
                            );

                      

                            if (updateRes.statusCode == 200) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Profile()));
                              var snackBar = SnackBar(
                                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                                content: Text(
                                  'Your email has been changed successfully',
                                  style: TextStyle(
                                      fontSize: 16.sp, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {}
                          },
                        child:  Text(
                          "confirm code ",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  //mainButton("Confirm code", width, context, TypeNewPassword())
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
                      text: 'Did not receive a code ? ',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xff8E8E8E))),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {

                   //todo add resend call ?
                      },
                    text: 'Resend',
                    style:  TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 15.sp,
                      color: const Color(0xFFFA6375),
                    ),
                  )
                    ]
                    ),
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
