import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/buttons/small_button.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';

class CustomErrorWidget extends StatefulWidget {
  final VoidCallback onRefresh;
  final String messgae;
  const CustomErrorWidget({Key? key,required this.onRefresh, required this.messgae}) : super(key: key);

  @override
  State<CustomErrorWidget> createState() => _CustomErrorWidgetState();
}

class _CustomErrorWidgetState extends State<CustomErrorWidget> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 35),
      child: Column(
        children: [
          SizedBox(
            height: height / 1.7,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/error_image.jpeg",
                    fit: BoxFit.cover,width: 200,height: 200,),
                const SizedBox(
                  height: 15,
                ),
                 Text("Something went wrong!".tr(context),
                    style:  TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700)
                ),
                Text(widget.messgae),
                Text("Please refresh app to continue planning.".tr(context)),
                const SizedBox(
                  height: 20,
                ),
                SmallButton(
                  onPressed: widget.onRefresh,
                  text: "Refresh".tr(context),
                  colorBg: AppColors.buttonTextColor,
                  textColor: AppColors.primaryColor,
                  borderColor: AppColors.buttonTextColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
