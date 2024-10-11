import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainTitle extends StatelessWidget {
  const MainTitle({required this.text, Key? key}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(right: width / 10),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 26.sp,
            fontFamily: 'Noto_Sans',
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
