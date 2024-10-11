import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/buttons/main_red_button.dart';
import 'package:ukla_app/features/Settings/Account/Data/account_service.dart';
import 'package:ukla_app/features/Settings/Account/Presentation/profile.dart';
import 'package:ukla_app/core/Presentation/inputs/InputFieldPass.dart';

class ChangePasswordFromSettings extends StatefulWidget {
  const ChangePasswordFromSettings({Key? key}) : super(key: key);

  @override
  State<ChangePasswordFromSettings> createState() => _TypeNewPasswordState();
}

class _TypeNewPasswordState extends State<ChangePasswordFromSettings> {
  final _newpassword1 = TextEditingController();
  final _newpassword2 = TextEditingController();
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
///////////fazet l mdp current njibou ml token wela no93d kol initstate njibou ml fct check password wela nchargih mara barka w nhotou f variable
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(children: [
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
                   Text("Change password".tr(context),
                      style:
                           TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold))
                ]),
              ),
            ],
          ),
          const SizedBox(
            height: 56,
          ),
          Column(
            children: [
              InputFieldPass(
                  labelText: "New password".tr(context),
                  hintText: "",
                  textEditingController: _newpassword1),
              InputFieldPass(
                  labelText: "Confirm new password".tr(context),
                  hintText: "",
                  textEditingController: _newpassword2),
            ],
          ),
          const SizedBox(
            height: 56,
          ),
          Column(
            children: [
              MainRedButton(
                  onPressed: (() async {
                    if (_newpassword1.text.isNotEmpty &&
                        _newpassword2.text.isNotEmpty) {
                      if (_newpassword1.text == _newpassword2.text) {
                  
                        var response = await changepassword(_newpassword1.text);

                        if (response == 'password updated') {
                          var snackBar = SnackBar(
                              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                              content: Text(
                                "Password changed succefully".tr(context),
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.white),
                                textAlign: TextAlign.center,
                              ));

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Profile()));
                        } else {
                          var snackBar = SnackBar(
                              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                              content: Text(
                                "An error occurred, try again later".tr(context),
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.white),
                                textAlign: TextAlign.center,
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } else if (_newpassword1.text != _newpassword2.text) {
                        var snackBar = SnackBar(
                          backgroundColor: const Color(0XFFFA6375),
                          content: Text(
                            "Passwords doesn't match".tr(context),
                            style:  TextStyle(fontSize: 16.sp),
                            textAlign: TextAlign.center,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                    /////cas fama champs feragh
                    else {
                      var snackBar = SnackBar(
                        backgroundColor: const Color(0XFFFA6375),
                        content: Text(
                          "Please fill all the fields".tr(context),
                          style: TextStyle(fontSize: 16.sp),
                          textAlign: TextAlign.center,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }),
                  text: "Reset password".tr(context)),
            ],
          ),
        ]),
      )),
    );
  }
}
