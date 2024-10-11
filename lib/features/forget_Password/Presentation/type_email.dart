import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/inputs/InputField.dart';
import 'package:ukla_app/core/Presentation/buttons/main_red_button.dart';
import 'package:ukla_app/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ukla_app/features/forget_Password/Data/mail_service.dart';
import 'type_verification_code.dart';

class RedirectionToTypeCode extends StatefulWidget {
  const RedirectionToTypeCode({Key? key}) : super(key: key);

  @override
  _RedirectionToTypeCodeState createState() => _RedirectionToTypeCodeState();
}

class _RedirectionToTypeCodeState extends State<RedirectionToTypeCode> {
  final TextEditingController _usernameController = TextEditingController();
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /*** Login label  ********/

              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: 21, left: size.width / 10, right: size.width / 10, bottom: 10),
                      child: Text(
                        "Please insert your email".tr(context),
                        style: const TextStyle(fontSize: 30, fontFamily: 'Noto_Sans', fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: 21, left: size.width / 10, right: size.width / 10, bottom: 10),
                      child: Text(
                        "please type your email , we'll send you a code verification".tr(context),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              /*** user name / login  input    ********/

              InputField(labelText: 'email'.tr(context), hintText: "Email", textEditingController: _usernameController),
              const SizedBox(
                height: 50,
              ),
              MainRedButton(
                  onPressed: () async {
                    if (_usernameController.text.isNotEmpty) {
                      Provider.of<CodeModel>(context, listen: false).addMail(_usernameController.text);
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(width: 16),
                                  Text("Sending email...".tr(context)),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      var res = await MailService.sendMail(_usernameController.text);
                      Navigator.of(context).pop();
                      if (res == 400) {
                        var snackBar = SnackBar(
                          backgroundColor: const Color(0XFFFA6375),
                          content: Text(
                            "this email doesn't exist !".tr(context),
                            style: TextStyle(fontSize: 20.sp),
                            textAlign: TextAlign.center,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      if (res == 201 || res == 200) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgetPassword()));
                      }
                    } else {
                      var snackBar = SnackBar(
                        backgroundColor: const Color(0XFFFA6375),
                        content: Text(
                          'Please insert your email'.tr(context),
                          style: TextStyle(fontSize: 20.sp),
                          textAlign: TextAlign.center,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  text: 'Send mail'.tr(context)),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
