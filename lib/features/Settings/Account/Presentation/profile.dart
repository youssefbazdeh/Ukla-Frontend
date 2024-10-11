import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/components/custom_error_widget.dart';
import 'package:ukla_app/features/Settings/Account/Data/account_service.dart';
import 'package:ukla_app/main.dart';
import 'package:ukla_app/features/Settings/Account/Presentation/change_username.dart';

import 'package:ukla_app/features/Settings/Account/Presentation/verify_password_from_settings.dart';
import 'package:ukla_app/features/authentification/Data/userService.dart';
import '../../../signup/Domain/user.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late FocusNode myfocus;
  final usercntrl = TextEditingController();
  Future<User>? userfuture;
  String? jwt;
  String username = "";
  DateTime selectedDate= DateTime.now();

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }
  Future<void> fetchUserData() async {
    jwt = await getToken();
    username = jwt!;
    setState(() {});
    userfuture = UserService.getUserByUsername(username);
  }

  Future<void> onRefresh() async {
    await fetchUserData();
  }

  Future<String> getToken() async {
    var jwt = await storage.read(key: 'jwt');
    var payloaad = json.decode(
        ascii.decode(base64.decode(base64.normalize(jwt!.split(".")[1]))));
    return payloaad["sub"];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ////// future builder
            Container(
                // color: Colors.black87,
                margin: const EdgeInsets.only(top: 23, left: 10),
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    InkResponse(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Ionicons.arrow_back)),
                    const SizedBox(width: 15),
                    Text('Account'.tr(context),
                        style:  TextStyle(
                            fontSize: 24.sp, fontWeight: FontWeight.bold))
                  ],
                )),
            FutureBuilder(
                future: userfuture?? Future.value(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      clipBehavior: Clip.antiAlias,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      height: 50,
                      width: 50,
                    );
                  }
                  else if (snapshot.hasData) {
                    User user = snapshot.data as User;
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 24, left: 20, right: 35),
                      child: Column(
                        children: [
                          ////change photo sfeature to not delete
                          // const Text('Account info',
                          //     style: TextStyle(
                          //         fontSize: 18, fontWeight: FontWeight.bold)),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 25),
                          //   child: Column(
                          //     children: [
                          //       const CircleAvatar(
                          //         radius: 49,
                          //         backgroundColor:
                          //             Color.fromARGB(213, 172, 172, 172),
                          //       ),
                          //       const SizedBox(height: 5),
                          //       InkResponse(
                          //         onTap: () {},
                          //         child: const Text('Change photo'),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          const SizedBox(height: 37),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('Account info'.tr(context),
                                        style:  TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w800)),
                                  ],
                                ),
                                const SizedBox(height: 37),
                                Row(
                                  children: [
                                    Text('Username'.tr(context),
                                        style:  TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    InkResponse(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ChangeUsername()));
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Ionicons.pencil_outline,
                                            size: 14,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            'Edit'.tr(context),
                                            style:
                                                 TextStyle(fontSize: 14.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          TextField(
                            controller: usercntrl,
                            decoration: InputDecoration(
                                hintText: user.username),
                            // focusNode: myfocus,
                            enabled: false,
                          ),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('Email address'.tr(context),
                                        style:  TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    InkResponse(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const VerifyPassowrdFromSettings(
                                                      destination:
                                                          'ChangeEmailFromSettings',
                                                    )));
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Ionicons.pencil_outline,
                                            size: 14,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            'Edit'.tr(context),
                                            style:
                                                 TextStyle(fontSize: 14.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          TextField(
                            controller: usercntrl,
                            decoration: InputDecoration(
                                hintText:
                                    user.email),
                            // focusNode: myfocus,
                            enabled: false,
                          ),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('Date of birth'.tr(context),
                                        style:  TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    InkResponse(
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: Provider.of<ProfileProvider>(context,listen: false).birthdate ?? user.birthdate!,
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                          builder: (BuildContext context, Widget? child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                textButtonTheme: TextButtonThemeData(
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Colors.black, // Button text color
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (pickedDate != null) {
                                          //pickedDate output format => 2021-03-10 00:00:00.000
                                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                          var result = await changeBirthdate(user.id, formattedDate);
                                          if(result==200){
                                            Provider.of<ProfileProvider>(context,listen: false).setBirthday(pickedDate);
                                            setState(() {});
                                          }
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Ionicons.pencil_outline,
                                            size: 14,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            'Edit'.tr(context),
                                            style:
                                                 TextStyle(fontSize: 14.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          TextField(
                            controller: usercntrl,
                            decoration: InputDecoration(
                                hintText: DateFormat("y-M-d").format(
                                    Provider.of<ProfileProvider>(context,listen: false).birthdate ?? user.birthdate!
                                )),
                            // focusNode: myfocus,
                            enabled: false,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const VerifyPassowrdFromSettings(
                                              destination:
                                                  'ChangePPasswordFromSettings')));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Change Password'.tr(context),
                                    style:  TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return CustomErrorWidget(onRefresh: onRefresh,messgae: "error_text".tr(context));
                  }
                })
          ],
        ),
      ),
    ));
  }
}
