import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/inputs/InputField.dart';
import 'package:ukla_app/core/Presentation/inputs/InputFieldPass.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/features/signup/Domain/gender.dart';
import 'package:ukla_app/features/signup/Presentation/provider/new_account_provider.dart';

import 'package:ukla_app/features/authentification/Data/userService.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';
import 'package:ukla_app/features/signup/Presentation/type_verification_code.dart';

import '../../../core/Presentation/buttons/main_red_button.dart';

class SignupPageTwo extends StatefulWidget {
  const SignupPageTwo({Key? key}) : super(key: key);

  @override
  State<SignupPageTwo> createState() => _SignupPageTwoState();
}

class _SignupPageTwoState extends State<SignupPageTwo> {
  _SignupPageTwoState();

  final _focusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    void displayDialog(context, title, text) => showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(title: Text(title), content: Text(text)),
        );

    var newaccount = context.watch<NewAccountProvider>();
    var updateaccount = context.read<NewAccountProvider>();
    if (newaccount.email != '') {
      _emailController.text = newaccount.getEmail();
      _passwordController.text = newaccount.getPassword();
      _confirmPasswordController.text = newaccount.getConfirmPassword();
    }
    bool _isLoading = false;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onTap: () {
              Provider.of<NewAccountProvider>(context, listen: false)
                  .setEmail(_emailController.text);
              updateaccount.setEmail(_emailController.text);
              updateaccount.setPassword(_passwordController.text);
              updateaccount.setConfirmPassword(_confirmPasswordController.text);

              Navigator.pop(context);
            }),
        backgroundColor: const Color.fromARGB(255, 253, 253, 253),
        title: Text(
          "Create a new account".tr(context),
          style:  TextStyle(
              fontSize: 25.sp,
              color: Colors.black,
              fontFamily: 'Noto_Sans',
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              InputField(
                labelText: 'email'.tr(context),
                hintText: 'email'.tr(context),
                textEditingController: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please insert your email'.tr(context);
                  }
                  if (EmailValidator.validate(value)) {
                    return null;
                  } else {
                    return 'insert a valid email'.tr(context);
                  }
                },
              ),
              InputFieldPass(
                labelText: "Password".tr(context),
                hintText: "Password".tr(context),
                textEditingController: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please insert password'.tr(context);
                  }
                  return null;
                },
              ),
              InputFieldPass(
                labelText: "Confirm password".tr(context),
                hintText: "Confirm password".tr(context),
                textEditingController: _confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password'.tr(context);
                  }
                  if (value != _passwordController.text) {
                    return 'confirm password and password are different'.tr(context);
                  }
                  if (value == _passwordController.text) {
                    return null;
                  }
                  return null;
                },
              ),
              SizedBox(
                height: height / 10,
              ),
              /* ************  signup button ********* */

              MainRedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading =
                            true; // set _isLoading to true to show CircularProgressIndicator
                      });
                      _focusNode.unfocus();
                      // show the loading dialog
                      showDialog(
                        context: context,
                        barrierDismissible:
                            false, // dialog cannot be dismissed by tapping outside
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SizedBox(
                                height: height / 6,
                                child:  Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                     const CircularProgressIndicator(color: AppColors.secondaryColor, strokeWidth: 2.0,),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                        child: Text(
                                      "We are sending a verification code to your email address".tr(context),
                                      textAlign: TextAlign.center,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );

                      Future future = UserService.attemptSignUp(
                          newaccount.firstName,
                          newaccount.lastName,
                          DateFormat('yyyy-MM-dd').format(newaccount.birthdate),
                          newaccount.username,
                          _passwordController.text,
                          _emailController.text,
                          newaccount.gender!.toJson());
                      future.then((response) {
                        setState(() {
                          _isLoading =
                              false; // set isLoading to false when future is completed
                        });
                        Navigator.pop(context); // close the loading dialog

                        switch (response.statusCode) {
                          case 201:
                            Provider.of<NewAccountProvider>(context,
                                    listen: false)
                                .setEmail("");
                            updateaccount.setEmail("");
                            updateaccount.setPassword("");
                            updateaccount.setConfirmPassword("");
                            updateaccount.setFirstName("");
                            updateaccount.setUsername("");
                            updateaccount.setLastName("");
                            updateaccount.setBirthday(DateTime.now());

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TypeVerfificationCode(
                                        email: _emailController.text,
                                      )),
                            );
                            break;
                          case 200:
                            ScaffoldMessenger.of(context)
                                .showSnackBar( SnackBar(
                                    content: Text(
                              "Success The user was created verify your email to be able to login".tr(context),
                            )));
                            displayDialog(
                              context,
                              "Success".tr(context),
                              "The user was created verify your email to be able to login".tr(context),
                            );
                            break;
                          case 406:
          
                              if(response.body.contains("username")){
                                    displayDialog(
                              context,
                              "This username is already registered".tr(context),
                              "Please try to sign up using another username or log in if you already have an account.".tr(context),
                            );
                              }
                              else if(response.body.contains("email")){
                                 displayDialog(
                              context,
                              "This email is already registered".tr(context),
                              "Please try to sign up using another email or log in if you already have an account.".tr(context),
                            );
                              }
                            
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
                    }
                  },
                  text: 'Sign Up'.tr(context)),
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
