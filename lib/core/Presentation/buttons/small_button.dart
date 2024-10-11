import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmallButton extends StatelessWidget {
  final String text;
  final GestureTapCallback onPressed;
  final Color colorBg;
  final Color textColor;
  final Color borderColor;
  const SmallButton(
      {required this.onPressed,
      required this.text,
      Key? key,
      required this.colorBg,
      required this.textColor,
      required this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // backgroundColor: AppColors.secondaryColor,
          backgroundColor: colorBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          side: BorderSide(color: borderColor, width: 1),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
                //color: Color.fromARGB(255, 255, 255, 255),
                color: textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
