import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityHours extends StatelessWidget {
  const ActivityHours({
    super.key,
    required this.hours,
    required this.height,
    required this.text,
  });

  final double hours;
  final double height;
  final String text;

  @override
  Widget build(BuildContext context) {
    String formattedNumber =
        hours.toStringAsFixed(hours.truncateToDouble() == hours ? 0 : 1);

    return Row(
      children: [
        Text(
          "$text $formattedNumber h",
          style: TextStyle(
              fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: height / 25),
      ],
    );
  }
}
