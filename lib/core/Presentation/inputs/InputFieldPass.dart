import 'package:flutter/material.dart';

class InputFieldPass extends StatefulWidget {
  InputFieldPass({required this.labelText, required this.hintText, required this.textEditingController, this.validator, Key? key}) : super(key: key);

  final String labelText;
  final String hintText;
  final TextEditingController textEditingController;
  String? Function(String?)? validator;

  @override
  State<InputFieldPass> createState() => _InputFieldPassState(
        hintText: hintText,
        labelText: labelText,
        textEditingController: textEditingController,
        validator: validator,
      );
}

class _InputFieldPassState extends State<InputFieldPass> {
  _InputFieldPassState({
    required this.labelText,
    required this.hintText,
    required this.textEditingController,
    this.validator,
  });

  final String labelText;
  final String hintText;
  final TextEditingController textEditingController;
  String? Function(String?)? validator;
  bool _passwordVisible = false;
  void _toggle() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(top: 21, left: width / 10, right: width / 10, bottom: 0),
      child: TextFormField(
        validator: validator,
        obscureText: !_passwordVisible,
        controller: textEditingController,
        autofillHints: const [AutofillHints.password],
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),

            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              _toggle();
            },

            // hintText: 'Enter Your Name',
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          labelText: labelText,
          hintText: hintText,
        ),
      ),
    );
  }
}
