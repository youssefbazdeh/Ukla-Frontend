import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget inputTitle(String input) {
  return Text(
    input,
    textAlign: TextAlign.center,
    style:  TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
      color: const Color.fromARGB(255, 0, 0, 0),
    ),
  );
}
