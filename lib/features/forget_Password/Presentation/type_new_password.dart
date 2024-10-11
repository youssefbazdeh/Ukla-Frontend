import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/buttons/main_red_button.dart';
import 'package:ukla_app/main.dart';
import 'package:ukla_app/features/authentification/Presentation/LoginScreenUpdated.dart';
import 'package:ukla_app/features/forget_Password/Data/mail_service.dart';
import 'package:ukla_app/core/Presentation/inputs/InputFieldPass.dart';
import 'package:ukla_app/core/Presentation/titles/inputTitle.dart';

class TypeNewPassword extends StatefulWidget {
  const TypeNewPassword({Key? key}) : super(key: key);

  @override
  State<TypeNewPassword> createState() => _TypeNewPasswordState();
}

class _TypeNewPasswordState extends State<TypeNewPassword> {
  final newpassword1 = TextEditingController();
  final newpassword2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    newpassword1.dispose();
    newpassword2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

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
                children: [inputTitle("Change your password".tr(context))],
              ),
            ),
            const SizedBox(
              height: 56,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  InputFieldPass(
                    labelText: "enter your new password".tr(context),
                    hintText: "enter your new password".tr(context),
                    textEditingController: newpassword1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please insert your new password'.tr(context);
                      }
                      return null;
                    },
                  ),
                  InputFieldPass(
                    labelText: "confirm your new password".tr(context),
                    hintText: "confirm your new password".tr(context),
                    textEditingController: newpassword2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password'.tr(context);
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 56,
            ),
            Column(
              children: [
                MainRedButton(
                    onPressed: (() async {
                      if (_formKey.currentState!.validate() &&
                          (newpassword1.text == newpassword2.text)) {
                        // send data to server and showing a snackbar telling the user that all process is working well
                        String codeValue =
                            Provider.of<CodeModel>(context, listen: false)
                                .getCode();
                        var resstatuscode = await MailService.updatePassword(
                            codeValue, newpassword1.text);
                        if (resstatuscode == 200 || resstatuscode == 201) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginScreenUpdated()),
                                      (Route<dynamic> route) => false,);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text('updating the new password...'.tr(context))),
                        );
                      }
                      if (newpassword1.text != newpassword2.text) {
                        var snackBar = SnackBar(
                          backgroundColor: const Color(0XFFFA6375),
                          content: Text(
                            'Confirm password must be same as password'.tr(context),
                            style: TextStyle(fontSize: 16.sp),
                            textAlign: TextAlign.center,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                        //}
                        ),
                    text: 'Reset Password'.tr(context)),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
