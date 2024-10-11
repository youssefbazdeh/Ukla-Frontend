import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/features/view_recipe/Presentation/Widgets/nutritive_fact/my_arc.dart';

class NutritiveFactCercle extends StatelessWidget {
  final Color color;
  final String quantity;
  final String category;
  final int? pourcentage;
  const NutritiveFactCercle({
    Key? key,
    required this.quantity,
    required this.category,
    this.pourcentage,
    required this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height, width;
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    if (currentOrientation == Orientation.portrait) {
      height = MediaQuery.of(context).size.height;
      width = MediaQuery.of(context).size.width;
    } else {
      height = MediaQuery.of(context).size.width;
      width = MediaQuery.of(context).size.height;
    }

    return //width < 600

        Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(1000)),
            child:
                Stack(alignment: AlignmentDirectional.bottomCenter, children: [
              Positioned(
                top: 8,
                child: Column(
                  children: [
                    Text(
                      quantity,
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: color),
                    ),
                    Text(
                      category,
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: color),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: -10,
                child: MyArc(
                  diameter: 100,
                  color: color,
                ),
              ),
              Positioned(
                  bottom: 15,
                  child: Text(
                    pourcentage != null ? '$pourcentage %' : '',
                    style:  TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  )),
            ]));
  }
}
