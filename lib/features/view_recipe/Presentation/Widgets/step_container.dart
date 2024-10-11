import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';

import '../../../../core/Presentation/checkBox/check_boxes.dart';
import '../one_recipe_interface.dart';

////Step
class Steps extends StatefulWidget {
  final int number;
  final String description;
  const Steps({Key? key, required this.description, required this.number})
      : super(key: key);

  @override
  State<Steps> createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
      padding: const EdgeInsets.only(top: 10, left: 32, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0x80F6F6F6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const StepsCheck(),
            const SizedBox(width: 15),
            Text(
              "Step".tr(context)+" ${widget.number}",
              style:  TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Noto_Sans',
                fontSize: 17.sp,
              ),
            ),
          ]),
          const SizedBox(
            height: 10,
          ),
          Text(widget.description, style: descriptionStepsStyle)
        ],
      ),
    );
  }
}
