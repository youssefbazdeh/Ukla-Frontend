import 'package:flutter/material.dart';


class RadioBoxSelect extends StatefulWidget {
  final String title;

  const RadioBoxSelect({super.key, required this.title});

  @override
  State<RadioBoxSelect> createState() => _RadioBoxSelectState();
}

class _RadioBoxSelectState extends State<RadioBoxSelect> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(500)),
              ),
            ],
          ),
          SizedBox(
            height: height / 40,
          ),
          Row(
            children: [
              Text(widget.title),
            ],
          ),
        ],
      ),
    );
  }
}
