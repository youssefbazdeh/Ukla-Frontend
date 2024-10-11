import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/buttons/main_red_button.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/core/Presentation/resources/routes_manager.dart';

class Instructions extends StatefulWidget {
  final bool showBackArrow;
  const Instructions({super.key, required this.showBackArrow});

  @override
  State<Instructions> createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 0.03 * height,
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: 10, right: width / 10, left: width / 10),
            child: Row(
              children: [
                if (widget.showBackArrow)...[
                  InkResponse(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Ionicons.arrow_back)),
                ],
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    "Physical activity evaluation".tr(context),
                    textAlign: TextAlign.left,
                    style:TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0XFFFA6375),
                        letterSpacing: 0),
                  ),
                ),
              ],
            )
          ),
          SizedBox(
            height: 0.025 * height,
          ),
          Padding(
            padding: EdgeInsets.only(right: width / 15, left: width / 15),
            child: Container(
                width: width,
                height: height * 0.66,
                // color: Color(0XFFF4F4F4),
                decoration: BoxDecoration(
                    color: AppColors.backgroundGrey,
                    borderRadius: BorderRadius.circular(26)),
                child: Padding(
                  padding: EdgeInsets.only(
                      right: width / 20, left: width / 20, top: height / 30),
                  child: RichText(
                    text: TextSpan(
                  style: TextStyle(
                      fontSize: 19.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                  children: [
                    TextSpan(
                        text:
                            "Let's calculate your body needs in calories. "
                                .tr(context),
                        style:
                            const TextStyle(fontWeight: FontWeight.bold)),
                    const WidgetSpan(
                      child: Icon(Ionicons.flame_outline,
                          color: Colors.orange),
                    ),
                    TextSpan(
                        text: "\n\n\n" +
                            "During the day how much time do you spend doing each of these activities? "
                                .tr(context),
                        style: const TextStyle()),
                    TextSpan(
                        text:
                            "Please Be specific and honest to get the right estimations."
                                .tr(context),
                        style:
                            const TextStyle(fontWeight: FontWeight.w600)),
                    TextSpan(
                      text: "\n\n" +
                          "If you don't do an activity leave at 0 hours."
                              .tr(context),
                    ),
                    TextSpan(
                        text: "\n\n" +
                            "sum activities"
                                .tr(context)),
                  ],
                    ),
                  ),
                )),
          ),
          SizedBox(
            height: height / 30,
          ),
          SizedBox(
            width: width / 1.5,
            child: MainRedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.selectHeightAndWeight);
              },
              text: "Start".tr(context),
            ),
          )
        ],
      )),
    );
  }
}
