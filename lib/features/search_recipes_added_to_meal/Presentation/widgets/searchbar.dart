import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../pages/advanced_search.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget(
      {required this.text,
      required this.hintText,
      required this.onChanged,
      required this.controller,
      Key? key})
      : super(key: key);
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;
  final TextEditingController controller;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    const styleActive = TextStyle(color: Color(0XFF8B8B8B));
    const styleHint = TextStyle(color: Color(0XFF8B8B8B));
    final style = widget.text.isEmpty ? styleHint : styleActive;

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
        borderRadius: BorderRadius.circular(8),
        color: const Color(0XFFFDFDFD),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: controller,
        // controller : ,
        decoration: InputDecoration(
          icon: Icon(Ionicons.search, color: style.color),
          focusedBorder: InputBorder.none,
          suffixIcon: GestureDetector(
            child: Icon(
              Ionicons.options_outline,
              color: style.color,
            ),
            onTap: () {
              // controller.clear();
              // widget.onChanged('');
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AdvancedSearch()),
              );
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
          hintText: widget.hintText,
          hintStyle: style,
          border: InputBorder.none,
        ),
        //style: style,
        onChanged: widget.onChanged,
      ),
    );
  }
}
