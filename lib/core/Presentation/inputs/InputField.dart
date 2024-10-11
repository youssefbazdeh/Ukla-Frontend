import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  InputField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.textEditingController,
    this.validator,
    this.onchanged,
    this.isReadOnly = false,
    this.focusNode,
    this.keyboardType,
    this.maxLines,
    this.minLines,
    this.applyPadding = true,
    this.autofillHints,
  }) : super(key: key);

  final String labelText;
  final String hintText;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final void Function(String)? onchanged;
  final bool isReadOnly;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final bool applyPadding;
  List<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    Widget textField = TextFormField(
      focusNode: focusNode,
      validator: validator,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      maxLines: maxLines,
      minLines: minLines,
      controller: textEditingController,
      onChanged: onchanged,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        hintMaxLines: 2,
      ),
    );

    if (applyPadding) {
      return Padding(
        padding: EdgeInsets.only(
            top: 21, left: width / 10, right: width / 10, bottom: 0),
        child: textField,
      );
    } else {
      return textField;
    }
  }
}
