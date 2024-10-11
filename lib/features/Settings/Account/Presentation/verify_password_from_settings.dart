import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/inputs/InputFieldPass.dart';
import 'package:ukla_app/core/Presentation/buttons/main_red_button.dart';
import 'package:ukla_app/features/Settings/Account/Data/account_service.dart';
import 'package:ukla_app/main.dart';

import 'package:ukla_app/features/Settings/Account/Presentation/change_email_from_settings.dart';
import 'package:ukla_app/features/Settings/Account/Presentation/change_password_from_settings.dart';

class VerifyPassowrdFromSettings extends StatefulWidget {
  final String destination;
  const VerifyPassowrdFromSettings({Key? key, required this.destination})
      : super(key: key);

  @override
  _RedirectionToTypeCodeState createState() => _RedirectionToTypeCodeState();
}

class _RedirectionToTypeCodeState extends State<VerifyPassowrdFromSettings> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<ProfileProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                          InkResponse(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Ionicons.arrow_back)),
                          const SizedBox(width: 15),
                          Flexible(
                            child: Text("Password verification title".tr(context),
                                style:  TextStyle(
                                    fontSize: 24.sp, fontWeight: FontWeight.bold)),
                          )
                       
                    ],
                  ),
                ),
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
                      child: Text(
                        "Password verification text".tr(context),
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
              InputFieldPass(
                  labelText: "Password".tr(context),
                  hintText: "Password",
                  textEditingController: _passwordController),
              const SizedBox(
                height: 50,
              ),
              MainRedButton(
                  onPressed: () async {
                    if (_passwordController.text.isNotEmpty) {
                      /////fonction tverifiy ken l pass shih
                      var response = await checkPasswordIsCorrect(
                          userProvider.username, _passwordController.text);

                      if (response == 'true') {
                        if (widget.destination == 'ChangeEmailFromSettings') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ChangeEmailFromSettings()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ChangePasswordFromSettings()));
                        }
                      } else {
                        var snackBar = SnackBar(
                          backgroundColor: const Color(0XFFFA6375),
                          content: Text(
                            "Incorrect password".tr(context),
                            style: TextStyle(fontSize: 16.sp),
                            textAlign: TextAlign.center,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } else if (_passwordController.text.isEmpty) {
                      var snackBar = SnackBar(
                        backgroundColor: const Color(0XFFFA6375),
                        content: Text(
                          "password is required".tr(context),
                          style:  TextStyle(fontSize: 16.sp),
                          textAlign: TextAlign.center,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  text: "Verify".tr(context)),
              const SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
