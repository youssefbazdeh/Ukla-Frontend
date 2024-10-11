import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/components/snack_bar.dart';
import 'package:ukla_app/features/plan_Management/Domain/Use_Case/PlanService.dart';

class DeletePlanDialog extends StatefulWidget {
  final int planId;
  final Function onDeleteSuccess;

  const DeletePlanDialog({required this.planId, required this.onDeleteSuccess, Key? key}) : super(key: key);

  @override
  _DeletePlanDialogState createState() => _DeletePlanDialogState();
}

class _DeletePlanDialogState extends State<DeletePlanDialog> {
  bool isDeleting = false;

  Future<void> _deletePlan() async {
    setState(() {
      isDeleting = true;
    });

    try {
      int statusCode = await PlanService.deletPlan(widget.planId);
      if (statusCode == 200) {
        widget.onDeleteSuccess();
        Navigator.of(context).pop();
      } else {
        setState(() {
          isDeleting = false;
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: "Failed to delete the plan".tr(context),
          ),
        );
      }
    } catch (e) {
      // Handle error
      setState(() {
        isDeleting = false;
      });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: "Failed to delete the plan. Please try again.".tr(context),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Remove this plan ?".tr(context)),
        ],
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              width: width - 100,
              child: Text(
                "By confirming this action this plan will definitely removed from your plan list ".tr(context),
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
            TextButton(
                onPressed: () {
                  if (!isDeleting) {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  "Cancel".tr(context),
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: const Color(0XFFFA6375),
                  ),
                )),
            const Text(
              "|",
              style: TextStyle(
                  color: Color.fromARGB(255, 181, 181, 181),
                  fontWeight: FontWeight.bold),
            ),
            TextButton(
                onPressed: isDeleting ? null : _deletePlan,
                child: isDeleting
                    ? Text(
                  "Deleting...".tr(context),
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: const Color(0XFFFA6375),
                  ),
                )
                    : Text(
                  "Remove".tr(context),
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: const Color(0XFFFA6375),
                  ),
                )),
          ],
        )
      ],
    );
  }
}