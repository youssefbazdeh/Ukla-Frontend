import 'package:flutter/material.dart';
import 'package:ukla_app/core/Presentation/buttons/main_red_button.dart';
import 'package:ukla_app/core/Presentation/inputs/InputField.dart';
import 'package:ukla_app/core/Presentation/inputs/InputFieldPass.dart';
import 'package:ukla_app/core/Presentation/resources/routes_manager.dart';
import 'package:ukla_app/features/authentification/Data/google_signin_api.dart';
import 'package:ukla_app/injection_container.dart';
import '../../../core/Presentation/components/snack_bar.dart';
import '../../../core/Presentation/titles/mainTitle.dart';

class LinkAccountScreen extends StatefulWidget {
  final String username;
  const LinkAccountScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<LinkAccountScreen> createState() => _LinkAccountScreenState();
}

class _LinkAccountScreenState extends State<LinkAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  late TextEditingController _userNameController;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController(text: widget.username);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final googleSignInApi = sl<GoogleSignInApi>();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const MainTitle(text: 'Link account'),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 21, left: width / 10, right: width / 10, bottom: 0),
                  ),
                  SizedBox(
                    height: 100,
                    child: InputField(
                      labelText: 'username',
                      hintText: 'username',
                      textEditingController: _userNameController,
                      isReadOnly: true,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: InputFieldPass(
                      labelText: 'password',
                      hintText: 'password',
                      textEditingController: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please insert your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: height / 30,
                  ),


                  MainRedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                            var res = await googleSignInApi.checkPasswordToLink(_passwordController.text);
                            var snackbar = CustomSnackBar(message: res);
                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                            if(res == "Your account is successfully linked, you can now log in with Google."){
                              Navigator.pushReplacementNamed(context, Routes.loginRoute);
                            }
                        } else {}
                      },
                      text: 'Finish linking'),
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
