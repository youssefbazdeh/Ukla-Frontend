import 'package:flutter/material.dart';

class LittleInputField extends StatelessWidget {
   LittleInputField(
      {super.key,
      required this.labelText,
      required this.hintText,
      required this.textEditingController,
      this.validator,
      this.width});
  final String labelText;
  final String hintText;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
   double? width; 

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      height: 75,
      width: width ?? 100,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: textEditingController,
        validator: validator,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          labelText: labelText,
          hintText: hintText,
          errorMaxLines: 3,
        ),
      ),
    );
  }
}
