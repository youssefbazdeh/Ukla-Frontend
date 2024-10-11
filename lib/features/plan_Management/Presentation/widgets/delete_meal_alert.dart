import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';

void alertmealdialog1(int index1, double width,
    void Function(int index) deletemeal, dynamic context) {
  // Future.delayed(Duration(milliseconds: 10), () {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Remove this meal ?".tr(context)),
          ],
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                width: width - 100,
                child: Text(
                  "By confirming this action this meal will be removed from the current plan "
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
                        "Cancel".tr(context),
                        style:  TextStyle(
                            fontSize: 20.sp, color: AppColors.secondaryColor),
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
                        deletemeal(index1);
                      },
                      child: Text(
                        "Remove".tr(context),
                        style:  TextStyle(
                            fontSize: 20.sp, color: AppColors.secondaryColor),
                      ))
                ],
              ),
            ],
          )
        ],
      ),
    );
  });
}
