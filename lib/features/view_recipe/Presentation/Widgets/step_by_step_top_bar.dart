//topbar for stepby step
import 'package:flutter/material.dart';

Widget topBarStepByStep(int numberOfElement, int selectedElement) {
  List list = [];
  for (int i = 1; i <= numberOfElement; i++) {
    list.add(i == selectedElement ? -1 : i);
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      for (var i in list)
        Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: i != -1
                    ? const Color.fromARGB(255, 101, 104, 101)
                    : const Color(0xFFFA6375),
              ),
            )),
    ],
  );
}
