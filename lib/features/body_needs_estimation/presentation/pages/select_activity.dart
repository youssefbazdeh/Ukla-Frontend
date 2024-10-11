import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/BodyInfo.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/female_body_info.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/male_body_info.dart';
import 'package:ukla_app/features/body_needs_estimation/presentation/bloc/body_info_bloc.dart';
import 'package:ukla_app/features/body_needs_estimation/presentation/pages/activity_results.dart';
import 'package:ukla_app/features/body_needs_estimation/presentation/widgets/question.dart';
import 'package:ukla_app/features/body_needs_estimation/presentation/widgets/shake_classes/shake.dart';
import 'package:ukla_app/injection_container.dart';

class SelectActivity extends StatefulWidget {
  final BodyInfo bodyInfo;
  final String sex;
  const SelectActivity({Key? key, required this.bodyInfo, required this.sex})
      : super(key: key);
  @override
  State<SelectActivity> createState() => _SelectActivityState();
}

class _SelectActivityState extends State<SelectActivity> {
  final _shakeKey = GlobalKey<ShakeWidgetState>();

  int curentKey = 1;

  final ScrollController _scrollController = ScrollController();
  TimeOfDay timeLeft = const TimeOfDay(hour: 24, minute: 0);
  String timeleftOrOver = "";
  DateTime timeQuestion1 = DateTime(0, 0);
  DateTime timeQuestion2 = DateTime(0, 0);
  DateTime timeQuestion3 = DateTime(0, 0);
  DateTime timeQuestion4 = DateTime(0, 0);
  DateTime timeQuestion5 = DateTime(0, 0);
  DateTime timeQuestion6 = DateTime(0, 0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        double currentPosition = _scrollController.position.pixels;
        double screenHeight = MediaQuery.of(context).size.height*1 ;
        double newPosition =
            (currentPosition / screenHeight).ceil() * (screenHeight);
        _scrollController.animateTo(newPosition,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        double currentPosition = _scrollController.position.pixels;
        double screenHeight = MediaQuery.of(context).size.height;
        double newPosition =
            (currentPosition / screenHeight).floor() * screenHeight;
        _scrollController.animateTo(newPosition,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: buildBody(context),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: height / 4),
        child: Container(
          width: width / 2,
          height: height / 17,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: completed24hours ? AppColors.timeCompletedColor : AppColors.timeLeftColor,
          ),
          child: Center(
            child: ShakeWidget(
              key: _shakeKey,
              shakeCount: 3,
              shakeOffset: 5,
              shakeDuration: const Duration(milliseconds: 400),
              child: Text(
                "${timeLeft.hour}h ${timeLeft.minute}m $timeleftOrOver",
                style: TextStyle(color: Colors.white,
                  fontSize: 20.sp,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  bool get completed24hours => timeLeft.hour == 0 && timeLeft.minute == 0;

  BlocProvider<BodyInfoBloc> buildBody(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) =>
          sl<BodyInfoBloc>()..add(MaleOrFemaleEvent(sex: widget.sex)),
      child: Builder(builder: (context) {
        return SafeArea(
            child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        right: width / 20, left: width / 20, top: height / 30),
                    child: Wrap(children: [
                      BlocBuilder<BodyInfoBloc, BodyInfoState>(
                          builder: (context, state) {
                        if (state is MaleEmpty || state is MaleLoaded) {
                          return Column(children: [
                            Question(
                              text:
                                  "How many hours do you spend sleeping, resting lying down and napping per day?"
                                      .tr(context),
                              height: height,
                              width: width,
                              timeQuestion: timeQuestion1,
                              updateTime: updateParentValue,
                              questionNumber: 1,
                              last: false,
                              male: true,
                            ),
                            Question(
                              text:
                                  "How many hours do you spend in a sitting position such as eating, sewing, using the computer, working at the office, reading, writing, transporting, playing video games, watching TV"
                                      .tr(context),
                              height: height,
                              width: width,
                              timeQuestion: timeQuestion2,
                              updateTime: updateParentValue,
                              questionNumber: 2,
                              last: false,
                              male: true,
                            ),
                            Question(
                              text:
                                  "How many hours do you spend in a standing position such as shopping, washing, moving around the house or office, cooking?"
                                      .tr(context),
                              height: height,
                              width: width,
                              timeQuestion: timeQuestion3,
                              updateTime: updateParentValue,
                              questionNumber: 3,
                              last: false,
                              male: true,
                            ),
                            Question(
                              text:
                                  "How many hours do you spend doing moderate activities: manual work in a standing position: work in industry, machines, carpentry?"
                                      .tr(context),
                              height: height,
                              width: width,
                              timeQuestion: timeQuestion4,
                              updateTime: updateParentValue,
                              questionNumber: 4,
                              last: false,
                                male:true,
                            ),
                            Question(
                              text:
                                  "How many hours do you spend doing construction work, gardening (digging), walking, car repair, masonry, and plasterwork?"
                                      .tr(context),
                              height: height,
                              width: width,
                              timeQuestion: timeQuestion5,
                              updateTime: updateParentValue,
                              questionNumber: 5,
                              last: false,
                                male:true,
                            ),
                            Question(
                              text:
                                  "How many hours do you spend in intense activity: sports, earthworks, agriculture, forestry?"
                                      .tr(context),
                              height: height,
                              width: width,
                              timeQuestion: timeQuestion6,
                              updateTime: updateParentValue,
                              questionNumber: 6,
                              last: true,
                              male: true,
                            ),
                          ]);
                          //todo add female loaded to state condition
                        } else if (state is FemaleEmpty || state is FemaleLoaded) {
                          return Column(children: [
                            Question(
                              text:
                                  "How many hours do you spend sleeping, resting lying down and napping per day?"
                                      .tr(context),
                              height: height,
                              width: width,
                              timeQuestion: timeQuestion1,
                              updateTime: updateParentValue,
                              questionNumber: 1,
                              last: false,
                              male: false,
                            ),
                            Question(
                                text:
                                    "How many hours do you spend in a sitting position such as eating, sewing, using the computer, working at the office, reading, writing, transporting, playing video games, watching TV"
                                        .tr(context),
                                height: height,
                                width: width,
                                timeQuestion: timeQuestion2,
                                updateTime: updateParentValue,
                                questionNumber: 2,
                                last: false,male: false),
                            Question(
                                text:
                                    "How many hours do you spend in a standing position such as shopping, washing, moving around the house or office, cooking?"
                                        .tr(context),
                                height: height,
                                width: width,
                                timeQuestion: timeQuestion3,
                                updateTime: updateParentValue,
                                questionNumber: 3,
                                last: false,male: false),
                            Question(
                                text:
                                    "How many hours do you spend doing a moderate activity such as: walking, gardening, yoga, gymnastics, house cleaning?"
                                        .tr(context),
                                height: height,
                                width: width,
                                timeQuestion: timeQuestion4,
                                updateTime: updateParentValue,
                                questionNumber: 4,
                                last: false,male: false),
                            Question(
                                text: "How many hours do you spend working out?"
                                    .tr(context),
                                height: height,
                                width: width,
                                timeQuestion: timeQuestion5,
                                updateTime: updateParentValue,
                                questionNumber: 5,
                                last: true,male: false),
                          ]);
                        }
                        return Container();
                      }),
                      Builder(builder: (context) {
                        return BlocListener<BodyInfoBloc, BodyInfoState>(
                            listener: (context, state) {
                              if (state is Loading) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.secondaryColor,
                                    ), // Show progress indicator
                                  ),
                                );
                              }
                              if (state is MaleLoaded) {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ActivityResults(
                                              malebodyInfo: state.malebodyInfo,
                                            )));
                              } else if (state is FemaleLoaded) {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ActivityResults(
                                              femalebodyInfo:
                                                  state.femalebodyInfo,
                                            )));
                              }
                            },
                            child: Container());
                      })
                    ]),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 33,
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: width / 9, left: width / 9, bottom: height / 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text("Previous".tr(context))),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFFFA6375),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      if (!completed24hours) {
                        _shakeKey.currentState?.shake();
                      } else {
                        if (widget.sex == "Male") {
                          MaleBodyInfo maleBodyInfo = MaleBodyInfo();
                          bodyInfoToMaleBodyInfo(maleBodyInfo);

                          BlocProvider.of<BodyInfoBloc>(context)
                              .add(AddMaleBodyInfoEvent(maleBodyInfo));
                        }
                        if (widget.sex == "Female") {
                          FemaleBodyInfo femaleBodyInfo = FemaleBodyInfo();
                          bodyInfoToFemaleBodyInfo(femaleBodyInfo);

                          BlocProvider.of<BodyInfoBloc>(context)
                              .add(AddFemaleBodyInfoEvent(femaleBodyInfo));
                        }
                      }
                    },
                    child: Text(
                      "Send".tr(context),
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
      }),
    );
  }

  void updateTimeLeft() {
    int hoursSpent = timeQuestion1.hour +
        timeQuestion2.hour +
        timeQuestion3.hour +
        timeQuestion4.hour +
        timeQuestion5.hour +
        timeQuestion6.hour;

    int minutesSpent = timeQuestion1.minute +
        timeQuestion2.minute +
        timeQuestion3.minute +
        timeQuestion4.minute +
        timeQuestion5.minute +
        timeQuestion6.minute;

    int hourMinutesDifference;

    if (minutesSpent % 60 == 0) {
      hourMinutesDifference = 0;
    } else {
      hourMinutesDifference = 1;
    }
    if ((24 -
            (hoursSpent +
                (minutesSpent / 60).floor() +
                hourMinutesDifference)) <
        0) {
      timeLeft = TimeOfDay(
          hour: (24 - (hoursSpent + (minutesSpent / 60).floor())).abs(),
          minute: (minutesSpent % 60));
      timeleftOrOver = "over".tr(context);
    } else {
      timeLeft = TimeOfDay(
          hour: 24 -
              (hoursSpent +
                  (minutesSpent / 60).floor() +
                  hourMinutesDifference),
          minute: (60 - (minutesSpent % 60)) % 60);
      timeleftOrOver = "left".tr(context);
    }
  }

  void updateParentValue(DateTime newValue, int questionNumber) {
    switch (questionNumber) {
      case (1):
        setState(() => timeQuestion1 = newValue);

        break;
      case (2):
        setState(() => timeQuestion2 = newValue);
        break;
      case (3):
        setState(() => timeQuestion3 = newValue);
        break;
      case (4):
        setState(() => timeQuestion4 = newValue);
        break;
      case (5):
        setState(() => timeQuestion5 = newValue);
        break;
      case (6):
        setState(() => timeQuestion6 = newValue);
    }
    updateTimeLeft();
  }

  void bodyInfoToMaleBodyInfo(MaleBodyInfo maleBodyInfo) {
    maleBodyInfo.age = widget.bodyInfo.age;
    maleBodyInfo.height = widget.bodyInfo.height;
    maleBodyInfo.weight = widget.bodyInfo.weight;
    maleBodyInfo.physicalActivityLevelA =
        timeTodouble(timeQuestion1.hour, timeQuestion1.minute);
    maleBodyInfo.physicalActivityLevelB =
        timeTodouble(timeQuestion2.hour, timeQuestion2.minute);
    maleBodyInfo.physicalActivityLevelC =
        timeTodouble(timeQuestion3.hour, timeQuestion3.minute);
    maleBodyInfo.physicalActivityLevelD =
        timeTodouble(timeQuestion4.hour, timeQuestion4.minute);
    maleBodyInfo.physicalActivityLevelE =
        timeTodouble(timeQuestion5.hour, timeQuestion5.minute);
    maleBodyInfo.physicalActivityLevelF =
        timeTodouble(timeQuestion6.hour, timeQuestion6.minute);
  }

  void bodyInfoToFemaleBodyInfo(FemaleBodyInfo femaleBodyInfo) {
    femaleBodyInfo.age = widget.bodyInfo.age;
    femaleBodyInfo.height = widget.bodyInfo.height;
    femaleBodyInfo.weight = widget.bodyInfo.weight;
    femaleBodyInfo.physicalActivityLevelA =
        timeTodouble(timeQuestion1.hour, timeQuestion1.minute);
    femaleBodyInfo.physicalActivityLevelB =
        timeTodouble(timeQuestion2.hour, timeQuestion2.minute);
    femaleBodyInfo.physicalActivityLevelC =
        timeTodouble(timeQuestion3.hour, timeQuestion3.minute);
    femaleBodyInfo.physicalActivityLevelD =
        timeTodouble(timeQuestion4.hour, timeQuestion4.minute);
    femaleBodyInfo.physicalActivityLevelE =
        timeTodouble(timeQuestion5.hour, timeQuestion5.minute);
  }

  double timeTodouble(int hours, int minutes) {
    return (hours + (minutes / 60)).toDouble();
  }
}
