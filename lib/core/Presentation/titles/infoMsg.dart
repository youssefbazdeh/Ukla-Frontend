import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget infoMsg(String msg) {
  return Flexible(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        msg,
        textAlign: TextAlign.left,
        style:  TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w300,
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    ),
  );
}
