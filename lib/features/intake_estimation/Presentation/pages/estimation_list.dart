import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/Presentation/buttons/small_button.dart';
import '../../../../core/Presentation/resources/colors_manager.dart';
import '../../../../core/Presentation/resources/routes_manager.dart';
import '../../../../injection_container.dart';
import '../../Domain/entities/estimation_meal.dart';
import '../bloc/intake_estimation_bloc.dart';
import '../widgets/estimation_list_meal_card.dart';

class EstimationList extends StatefulWidget {
  const EstimationList({super.key});

  @override
  State<EstimationList> createState() => _EstimationListState();
}

class _EstimationListState extends State<EstimationList> {
  List<EstimationListMealCard> items = [
    EstimationListMealCard(
      mealTitle: 'Breakfast',
    ),
    EstimationListMealCard(
      mealTitle: 'Lunch',
    ),
    EstimationListMealCard(
      mealTitle: 'Dinner',
    ),
  ];
  List<EstimationMeal> estimationMeals = [];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    //var _listViewController;

    return Scaffold(
        body: BlocProvider(
      create: (_) => sl<IntakeEstimationBloc>(),
      child: Builder(builder: (context) {
        return SafeArea(
            child: SingleChildScrollView(
          child: SizedBox(
            width: width,
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
                              "Insert your daily meal including any snacks",
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
                  ListView.builder(
                      itemCount: items.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return items[index];
                      }),
                  const SizedBox(
                    height: 30,
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
                        items.add(
                          EstimationListMealCard(
                            mealTitle: 'new meal',
                          ),
                        );
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
                    height: items.length > 4 ? height / 15 : height / 4,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      SmallButton(
                        onPressed: () {
                          for (var item in items) {
                            EstimationMeal estimationMeal = EstimationMeal();
                            estimationMeal.name = item.mealTitle;
                            estimationMeal.filled = false;
                            estimationMeals.add(estimationMeal);
                          }
                          BlocProvider.of<IntakeEstimationBloc>(context)
                              .add(AddEstimationMealsEvent(estimationMeals));
                          Future.delayed(const Duration(milliseconds: 100), () {
                            Navigator.pushNamed(
                                context, Routes.estimationFinalList);
                            estimationMeals.clear();
                          });
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
          ),
        ));
      }),
    ));
  }
}
