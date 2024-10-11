import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

import '../one_recipe_interface.dart';

///Cooking's tip
class CookingTip extends StatelessWidget {
  final String? cookingTip;
  const CookingTip({super.key, this.cookingTip});

  @override
  Widget build(BuildContext context) {
    return cookingTip != ""
        ? Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                  children: [
                    const Icon(Ionicons.bulb_outline, color: Color(0xFFFFA800)),
                    const SizedBox(width: 10),
                    Text(
                      'Cook\'s Tip',
                      style:
                          TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(cookingTip!, style: descriptionStepsStyle),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: const Color(0xFFFFF2F2)))
        : const SizedBox(
            height: 0,
            width: 0,
          );
  }
}
