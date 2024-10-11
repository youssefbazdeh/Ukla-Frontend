import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';

void showMyDialogAddMeal(
    BuildContext context, double width, void Function() function) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
                child: Text(
              "add this meal to all days of this plan?".tr(context),
              textAlign: TextAlign.center,
            )),
          ),
        ],
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              width: width - 100,
              child: Text(
                "By confirming this action this meal will added to all days of the current plan "
                    .tr(context),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                TextButton(
                    onPressed: //         onPressed:
                        () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text(
                      "Only this day".tr(context),
                      style:  TextStyle(fontSize: 20.sp),
                    )),
              ],
            ),
            const Column(
              children: [
                Text(
                  "|",
                  style: TextStyle(
                      color: Color.fromARGB(255, 181, 181, 181),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: [
                TextButton(
                    //         onPressed:
                    onPressed: () {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pop(true);
                      });
                      //deletemeal(index1);
                    },
                    child: Text(
                      "All days".tr(context),
                      style:  TextStyle(fontSize: 20.sp),
                    ))
              ],
            ),
          ],
        )
      ],
    ),
  );
}
