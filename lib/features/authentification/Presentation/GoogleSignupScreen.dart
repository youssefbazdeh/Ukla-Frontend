import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ukla_app/core/Presentation/buttons/main_red_button.dart';
import 'package:ukla_app/core/Presentation/inputs/InputField.dart';
import 'package:ukla_app/core/Presentation/titles/mainTitle.dart';
import 'package:ukla_app/features/authentification/Domain/google_sign_in.dart';
import 'package:ukla_app/features/authentification/Domain/user_info.dart';


class GoogleSignupScreen extends StatefulWidget {
  const GoogleSignupScreen({Key? key}) : super(key: key);

  @override
  State<GoogleSignupScreen> createState() => _GoogleSignupScreenState();
}

class _GoogleSignupScreenState extends State<GoogleSignupScreen> {
  UserInfo userinfo = UserInfo();

  final TextEditingController dateinput = TextEditingController();

  final TextEditingController _userNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    
    super.initState();
  }

  @override
  String gender = "Female";

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    DateTime selectedDate = DateTime.now();

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const MainTitle(text: 'Create a new account'),
              SizedBox(
                height: height / 30,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 21, left: width / 10, right: width / 10, bottom: 0),
                child: SizedBox(
                  child: TextFormField(
                    controller: dateinput,

                    decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        suffixIcon: Icon(Icons.calendar_today),
                        labelText: "Birth date"),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              1900), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime.now());

                      if (pickedDate != null) {
                        //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        selectedDate = pickedDate;

                        setState(() {
                          dateinput.text = formattedDate;
                        

                   
                        });
                      } 
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please insert birthdate';
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
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8)))),
                    // Initial Value
                    value: gender,

                    isExpanded: true,

                    icon: const Icon(Icons.keyboard_arrow_down),

                   
                    items: const [
                      DropdownMenuItem(
                        child: Text("Male"),
                        value: "Male",
                      ),
                      DropdownMenuItem(
                        child: Text("Female"),
                        value: "Female",
                      ),
                      DropdownMenuItem(
                        child: Text("Other"),
                        value: "Other",
                      )
                    ],
                    onChanged: (String? value) {
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
                  labelText: 'username',
                  hintText: 'username',
                  textEditingController: _userNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please insert your username';
                    }
                    if (value.length < 3) {
                      return 'username should be at least 4 caracters';
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
                  
                      
                      userinfo.birthdate = selectedDate;
                   

                      userinfo.gender = gender;
                     
                      userinfo.username = _userNameController.text;
                             

                      createAccount(context, userinfo

                      
                          );
                    } else {}
                  },
                  text: 'Finish registration'),
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
