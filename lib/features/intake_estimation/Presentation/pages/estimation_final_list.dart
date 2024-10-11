import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_meal.dart';
import '../../../../core/Presentation/buttons/small_button.dart';
import '../../../../core/Presentation/resources/colors_manager.dart';
import '../../../../core/Presentation/resources/routes_manager.dart';
import '../../../../injection_container.dart';
import '../bloc/intake_estimation_bloc.dart';
import '../widgets/estimation_final_add_meal_card.dart';
import '../widgets/estimation_final_list_meal_card.dart';

class EstimationFinalList extends StatefulWidget {
  const EstimationFinalList({super.key});

  @override
  State<EstimationFinalList> createState() => _EstimationListState();
}

class _EstimationListState extends State<EstimationFinalList> {
  var listLength = 0;
  var filledCount = 0;
  var loadedListLength = 0;
  var i = 0;
  bool show = false;
  final IntakeEstimationBloc bloc = sl<IntakeEstimationBloc>();
  List<EstimationFinalAddMealCard> items = [];

  @override
  void initState() {
    bloc.add(const GetEstimationMealsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocProvider(
        create: (_) => bloc,
        child: BlocBuilder<IntakeEstimationBloc, IntakeEstimationState>(
            builder: (context, state) {
          if (state is EstimationMealsLoaded && i == 0) {
            loadedListLength = state.estimationMeals.length;
            i++;
          }

          if (i == 1 &&
              state is EstimationMealsLoaded &&
              show == true &&
              loadedListLength < state.estimationMeals.length) {
            show = false;
            i = 0;
          }

          return SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Text(
                    "Food Intake",
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textColor,
                        letterSpacing: 0),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width / 1.4,
                          child:  Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              "Insert Examples for what you eat in each of your daily meals",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor,
                                  letterSpacing: 0),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.info_outlined,
                            color: AppColors.textColor,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, Routes.estimationIntake);
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (state is EstimationMealsLoaded)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.estimationMeals.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        listLength = state.estimationMeals.length;
                        filledCount = 0;
                        for (var item in state.estimationMeals) {
                          if (item.filled! == true) {
                            filledCount++;
                          }
                        }
                        return EstimationFinalListMealCard(
                            estimationMeal: EstimationMeal(
                                id: state.estimationMeals[index].id!,
                                name: state.estimationMeals[index].name!,
                                filled: state.estimationMeals[index].filled!));
                      },
                    ),
                  if (state is EstimationMealsLoaded && show == true)
                    EstimationFinalAddMealCard(
                      mealTitle: 'new meal',
                      bloc: bloc,
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      side: const BorderSide(color: AppColors.secondaryColor),
                      shadowColor: AppColors.secondaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        show = true;
                      });
                    },
                    icon: const Icon(
                      CupertinoIcons.plus,
                      color: AppColors.textColor,
                    ),
                    label:  Text(
                      "Add meal",
                      style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: listLength > 4 ? height / 15 : height / 3.2,
                  ),
                  Row(
                    children: [
                      SmallButton(
                        onPressed: () {
                          /*Navigator.pushReplacementNamed(
                              context, Routes.estimationList);*/
                        },
                        text: "Previous",
                        borderColor: AppColors.secondaryColor,
                        colorBg: const Color.fromARGB(255, 255, 255, 255),
                        textColor: AppColors.borderPlanList,
                      ),
                      const Spacer(),
                      SmallButton(
                        onPressed: () {
                          if (filledCount == listLength) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Next Page"),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Please Fill all your Meals!"),
                            ));
                          }
                        },
                        text: "Next",
                        borderColor: AppColors.secondaryColor,
                        colorBg: AppColors.secondaryColor,
                        textColor: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
        }),
      ),
    );
  }
}
