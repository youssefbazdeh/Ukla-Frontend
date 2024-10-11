import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/core/Presentation/components/translateUnitLogic.dart';

Wrap ingredientQuantityObjectText(String contentLanguageCode, String quantity,
    String unit, String ingredientName) {
  return Wrap(
    verticalDirection: contentLanguageCode == 'ar'?  VerticalDirection.up :VerticalDirection.down ,
    children: [
      if (contentLanguageCode == 'ar') ...[
        Text(
          ingredientName,
          style:  TextStyle(fontSize: 17.sp),
        ),
        const SizedBox(width: 5),
        Text("$quantity ${translateUnit(unit, contentLanguageCode)}",
            textDirection: TextDirection.rtl,
            style:  TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600)),
      ] else ...[
        Text("$quantity ${translateUnit(unit, contentLanguageCode)} ",
            style:  TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600)),
        Text(ingredientName, style:  TextStyle(fontSize: 17.sp)),
      ]
    ],
  );
}
