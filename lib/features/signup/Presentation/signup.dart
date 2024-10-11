import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/buttons/main_red_button.dart';
import 'package:ukla_app/core/Presentation/inputs/InputField.dart';
import 'package:ukla_app/core/Presentation/titles/mainTitle.dart';
import 'package:ukla_app/core/utils/debouncer.dart';
import 'package:ukla_app/core/utils/utils.dart';
import 'package:ukla_app/features/authentification/Data/userService.dart';
import 'package:ukla_app/features/signup/Domain/gender.dart';
import 'package:ukla_app/features/signup/Presentation/provider/new_account_provider.dart';
import 'package:ukla_app/features/authentification/Presentation/LoginScreenUpdated.dart';
import 'package:ukla_app/features/signup/Presentation/signupPageTwo.dart';
import 'package:intl/intl.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  _SignupState();

  final TextEditingController dateinput = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool? _isValidUsername = null;
  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  Gender? gender;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var newAccountProvider = context.read<NewAccountProvider>();

    final _debouncer = Debouncer(milliseconds: 500);

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: height / 30,
              ),
              MainTitle(
                text: 'Create a new account'.tr(context),
              ),
              SizedBox(
                height: height / 30,
              ),
              InputField(
                labelText: 'First name'.tr(context),
                hintText: 'First name'.tr(context),
                textEditingController: _firstNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please insert firstname'.tr(context);
                  }
                  if (value.length < 2) {
                    return 'firstname should be at least 2 characters'
                        .tr(context);
                  }
                  return null;
                },
              ),
              InputField(
                labelText: 'Last name'.tr(context),
                hintText: 'Last name'.tr(context),
                textEditingController: _lastNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please insert lastname'.tr(context);
                  }
                  if (value.length < 2) {
                    return 'lastname should be at least 2 characters'
                        .tr(context);
                  }
                  return null;
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 21, left: width / 10, right: width / 10, bottom: 0),
                child: SizedBox(
                  child: TextFormField(
                    controller: dateinput,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        suffixIcon: const Icon(Icons.calendar_today),
                        labelText: "Birth date".tr(context)),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Colors.black, // Button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);

                        setState(() {
                          dateinput.text = formattedDate;
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please insert birthdate'.tr(context);
                      }
                      if (dateinput.text != "") {
                        return null;
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 21, left: width / 10, right: width / 10, bottom: 0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: DropdownButtonFormField<Gender>(
                    decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8)))),
                    value: gender,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    validator: (value) {
                      if (value == null) {
                        return 'Please insert your sex'.tr(context);
                      }
                      return null;
                    },
                    hint: Text("sex".tr(context)),
                    items: Gender.values.map((Gender gender) {
                      return DropdownMenuItem<Gender>(
                        value: gender,
                        child: Text(gender.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (Gender? value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: InputField(
                  labelText: 'username'.tr(context),
                  hintText: 'username'.tr(context),
                  textEditingController: _userNameController,
                  onchanged: (usernameToCheck) {
                    setState(() {
                      _isLoading = true; //Checks username validity
                    });
                    _debouncer.run(() {
                      try {
                        Future<bool> future =
                            UserService.checkUsernameExistence(usernameToCheck);
                        future.then((exists) {
                          setState(() {
                            _isLoading =
                                false; // set isLoading to false when future is completed
                          });
                          if (exists) {
                            setState(() {
                              _isValidUsername = false;
                            });
                          } else {
                            setState(() {
                              _isValidUsername = true;
                            });
                          }
                        });
                      } catch (e) {
                        Utils.printf("Exception caught: $e");
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please insert your username'.tr(context);
                    }
                    if (value.length < 3) {
                      return 'username should be at least 4 characters'
                          .tr(context);
                    }
                    return null;
                  },
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 10),
                    child: Text(
                      _isLoading
                          ? "Searching...".tr(context)
                          : _isValidUsername != null
                              ? _isValidUsername!
                                  ? "Valid username".tr(context)
                                  : "Invalid username".tr(context)
                              : "",
                    ),
                  )),
              SizedBox(
                height: height / 30,
              ),
              MainRedButton(
                  isEnabled: _isValidUsername != null &&
                      _isValidUsername! &&
                      _firstNameController.text.isNotEmpty &&
                      _lastNameController.text.isNotEmpty &&
                      gender != null &&
                      selectedDate != DateTime.now(),
                  onPressed: _isValidUsername != null && _isValidUsername!
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            newAccountProvider
                                .setFirstName(_firstNameController.text);
                            newAccountProvider
                                .setLastName(_lastNameController.text);
                            newAccountProvider.setGender(gender!);
                            newAccountProvider.setBirthday(selectedDate);
                            newAccountProvider
                                .setUsername(_userNameController.text);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignupPageTwo()));
                          }
                        }
                      : null,
                  text: 'Next'.tr(context)),
              SizedBox(
                height: height / 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LoginScreenUpdated()));
                    }),
                    child: Text(
                      "Already have an account?".tr(context),
                      style: TextStyle(
                          fontSize: 14.sp,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height / 40,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
