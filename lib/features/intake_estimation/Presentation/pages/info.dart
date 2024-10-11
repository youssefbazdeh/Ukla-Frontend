import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/core/Presentation/buttons/main_red_button.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/core/Presentation/resources/routes_manager.dart';

import '../../../../injection_container.dart';
import '../bloc/intake_estimation_bloc.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  final IntakeEstimationBloc bloc = sl<IntakeEstimationBloc>();

  @override
  void initState() {
    bloc.add(const GetEstimationMealsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => bloc,
      child: BlocBuilder<IntakeEstimationBloc, IntakeEstimationState>(
          builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey,
          body: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: width / 15, left: width / 15),
                child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.backgroundGrey,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: width / 20,
                          left: width / 20,
                          top: height / 30),
                      child: Column(
                        children: [
                          RichText(
                            text:  TextSpan(
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                              children: const [
                                TextSpan(
                                    text: "Get to know you better ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        "\n\n\nPlease provide two or three frequent meals per day and the frequency of each meal per week so we can estimate your food intake and provide you with the best diet plan .",
                                    style: TextStyle()),
                                TextSpan(
                                  text:
                                      "\n\n\nLong press on a meal to make a copy or delete it .",
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox(
                              width: width / 2,
                              child: MainRedButton(
                                onPressed: () {
                                  if (state is EstimationMealsLoaded &&
                                      state.estimationMeals.isNotEmpty) {
                                    Navigator.pushNamed(
                                        context, Routes.estimationFinalList);
                                  } else {
                                    Navigator.pushReplacementNamed(
                                        context, Routes.estimationList);
                                  }
                                },
                                text: "Got it",
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
              SizedBox(
                height: height / 30,
              ),
            ],
          )),
        );
      }),
    );
  }
}
