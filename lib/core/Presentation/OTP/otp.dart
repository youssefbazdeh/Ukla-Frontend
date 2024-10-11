import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';

import '../../../main.dart';

class OTPwidget extends StatefulWidget {
  const OTPwidget({
    Key? key,
    this.phoneNumber,
  }) : super(key: key);

  final String? phoneNumber;

  @override
  State<OTPwidget> createState() =>
      _OTPwidgetState();
}

class _OTPwidgetState extends State<OTPwidget> {
  TextEditingController textEditingController = TextEditingController();

  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child:  Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 30,
                  ),
                  child: PinCodeTextField(
                    cursorWidth: 1,
                    appContext: context,
                    pastedTextStyle: const TextStyle(
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      selectedFillColor: AppColors.primaryColor,
                      selectedColor: AppColors.secondaryColor,
                      inactiveColor: AppColors.secondaryColor,
                      inactiveFillColor: AppColors.primaryColor,
                      activeColor: AppColors.secondaryColor,
                      shape: PinCodeFieldShape.underline,
                      borderWidth: 0,
                      fieldHeight: 50,
                      fieldWidth: 30,
                      activeFillColor: Colors.white,
                    ),
                    validator: (v) {
                      if (v!.length < 6) {
                        return "Code is too short";
                      } else {
                        return null;
                      }
                    },
                    cursorColor: AppColors.textColor,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    controller: textEditingController,
                    onCompleted: (v) {
                      Provider.of<CodeModel>(context, listen: false)
                          .add(currentText);
                    },
                    onChanged: (value) {
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      return true;
                    },
                  ),
                ),
              ),
      );
  }
}