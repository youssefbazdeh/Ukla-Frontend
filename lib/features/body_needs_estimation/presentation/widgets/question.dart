import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';

import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';

import '../../../../core/Presentation/checkBox/check_boxes.dart';

class Question extends StatefulWidget {
  final String text;
  final double height;
  final double width;
  final int questionNumber;
  final Function(DateTime newvalue, int questionnumber) updateTime;
  final DateTime timeQuestion;
  final bool last;
  final bool male;

  const Question({
    super.key,
    required this.text,
    required this.height,
    required this.width,
    required this.timeQuestion,
    required this.updateTime,
    required this.questionNumber,
    required this.last, required this.male,
  });

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if(widget.male)...[
        Text("Question".tr(context) + "${widget.questionNumber}/6", style: TextStyle(color: primary, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ]else...[
        Text("Question".tr(context) + "${widget.questionNumber}/5", style: TextStyle(color: primary, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ],
      SizedBox(height: widget.height / 25),
      if(widget.text.length > 220 )...[
        Container(
            height: widget.height / 4,
            decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                border: Border.all(color: AppColors.borderQuestion),
                borderRadius: BorderRadius.circular(26)),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: Text(
                        "${widget.questionNumber} ${widget.text}" ,
                        style:
                        TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                )
            )

        ),
      ]else ...[
        Container(
            height: widget.height / 4.8,
            decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                border: Border.all(color: AppColors.borderQuestion),
                borderRadius: BorderRadius.circular(26)),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: Text(
                        widget.text,
                        style:
                         TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                )
            )

        ),
      ],
      SizedBox(height: widget.height / 10),
      Center(
        child: SizedBox(
          height:widget.height / 7,
          width: widget.width * 2 / 3,
          child: CupertinoDatePicker(
            initialDateTime: widget.timeQuestion,
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            onDateTimeChanged: (DateTime newTime) {
              widget.updateTime(newTime, widget.questionNumber);
            },
          ),
        ),
      ),
   
      last()
    ]);
  }

  Widget last() {
    if (!widget.last) {
      return
          SizedBox(
            height: widget.height / 2.1,
          );
    } else {
      return
          SizedBox(
            height: widget.height / 5,
          );
    }
  }
}
