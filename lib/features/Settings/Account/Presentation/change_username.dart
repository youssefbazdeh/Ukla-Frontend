import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/inputs/InputField.dart';
import 'package:ukla_app/core/Presentation/buttons/main_red_button.dart';
import 'package:ukla_app/features/Settings/Account/Data/account_service.dart';
import 'package:ukla_app/main.dart';
import 'package:ukla_app/features/authentification/Presentation/LoginScreenUpdated.dart';


class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  _RedirectionToTypeCodeState createState() => _RedirectionToTypeCodeState();
}

class _RedirectionToTypeCodeState extends State<ChangeUsername> {
  final TextEditingController _usernamecontroller = TextEditingController();

//////////////////////////////////jawha behi

  @override
  Widget build(BuildContext context) {
    var changeuserProvider = Provider.of<ProfileProvider>(context);
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
                            child: Text("Modify username title".tr(context),
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
                      // ignore: avoid_unnecessary_containers
                      child: Container(
                        child: Text(
                          "Modify username text".tr(context),
                          textAlign: TextAlign.left,
                          style:  TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
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
                  labelText: "Username".tr(context),
                  hintText: "Username",
                  textEditingController: _usernamecontroller),
              const SizedBox(
                height: 50,
              ),
              MainRedButton(
                  onPressed: () async {
                    if (_usernamecontroller.text.isEmpty) {
                      var snackBar = SnackBar(
                        backgroundColor: const Color(0XFFFA6375),
                        content: Text(
                          'Please insert your username'.tr(context),
                          style:  TextStyle(fontSize: 16.sp),
                          textAlign: TextAlign.center,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      //change username
                      var result = await changeUsername(
                          changeuserProvider.getId(),
                          _usernamecontroller.text);
                     
                      if (result == 200) {
                        var jwt = await storage.delete(key: 'jwt');
                        // delete jwt
                        // ihezek lel login
                        var snackBar = SnackBar(
                            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                            content: Text(
                              "Username changed successfully message".tr(context),
                              style:
                                   TextStyle(fontSize: 16.sp, color: Colors.white),
                              textAlign: TextAlign.center,
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LoginScreenUpdated()));
                      } else if (result == 304) {
                        var snackBar = SnackBar(
                            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                            content: Text(
                              "You already have this username".tr(context),
                              style:
                                   TextStyle(fontSize: 16.sp, color: Colors.white),
                              textAlign: TextAlign.center,
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        var snackBar = SnackBar(
                            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                            content: Text(
                              "An error occurred, try again later".tr(context),
                              style:
                                 TextStyle(fontSize: 16.sp, color: Colors.white),
                              textAlign: TextAlign.center,
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  text: "Change".tr(context)),
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
