import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabCard extends StatefulWidget {
  const TabCard({required this.title, Key? key}) : super(key: key);
  final String title;

  @override
  State<TabCard> createState() => _TabCardState();
}

class _TabCardState extends State<TabCard> {
  @override
  Widget build(BuildContext context) {
    double width = widget.title.length > 3 ? 75 : 50;
    return Tab(
      child: Container(
        width: width,
        height: 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          widget.title,
          style:  TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
        ),
      ),
    );
  }
}
