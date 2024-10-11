import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorCustomizedWidget extends StatefulWidget {
  const ErrorCustomizedWidget({super.key});

  @override
  State<ErrorCustomizedWidget> createState() => _ErrorCustomizedWidgetState();
}

class _ErrorCustomizedWidgetState extends State<ErrorCustomizedWidget> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 35),
      child: Column(
        children: [
          SizedBox(
            height: height / 1.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/error_icon.png",
                    fit: BoxFit.fill, scale: 0.8),
                const SizedBox(
                  height: 15,
                ),
                 Text("There has been an issue ,Try again later ...",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
