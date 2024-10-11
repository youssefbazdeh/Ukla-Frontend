import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';

class MainRedButton extends StatelessWidget {
  const MainRedButton(
      {this.onPressed, this.isEnabled = true, required this.text, Key? key})
      : super(key: key);
  final String text;
  final bool isEnabled;
  final GestureTapCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 40,
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: width / 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled
                ? AppColors.secondaryColor
                : AppColors.secondaryColor.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
