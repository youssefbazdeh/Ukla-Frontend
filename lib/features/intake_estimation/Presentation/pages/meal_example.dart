import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_ingredient.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_recipe.dart';
import '../../../../core/Presentation/buttons/small_button.dart';
import '../../../../core/Presentation/resources/colors_manager.dart';
import '../../../../core/Presentation/resources/routes_manager.dart';
import '../../../../injection_container.dart';
import '../../Domain/entities/estimation_ingredient_quantity.dart';
import '../../Domain/entities/estimation_meal.dart';
import '../bloc/intake_estimation_bloc.dart';
import '../widgets/estimation_meal_card.dart';

class MealExample extends StatefulWidget {
  final EstimationMeal estimationMeal;
  final EstimationIngredientQuantity? estimationIngredientQuantity;
  final EstimationIngredient? estimationIngredient;
  final int? estimationRecipeIndex;
  final List<List<EstimationIngredient>> estimationIngredientList;
  final List<List<EstimationIngredientQuantity>>
      estimationIngredientQuantityList;
  const MealExample(
      {Key? key,
      required this.estimationMeal,
      this.estimationIngredientQuantity,
      this.estimationIngredient,
      this.estimationRecipeIndex,
      required this.estimationIngredientList,
      required this.estimationIngredientQuantityList})
      : super(key: key);

  @override
  State<MealExample> createState() => _MealExampleState();
}

class _MealExampleState extends State<MealExample> {
  final IntakeEstimationBloc bloc = sl<IntakeEstimationBloc>();

  List<EstimationMealCard> items = [];

  @override
  void initState() {
    bloc.add(GetEstimationMealEvent(widget.estimationMeal.id!));

    Future.delayed(const Duration(milliseconds: 80), () {
      setState(() {
        final state = bloc.state;
        if (state is EstimationMealLoaded) {
          if (state.estimationMeal.estimationRecipe!.isNotEmpty) {
            // ignore: unused_local_variable
            for (int i = 0;
                i < state.estimationMeal.estimationRecipe!.length;
                i++) {
              items.add(
                EstimationMealCard(
                    estimationMeal: state.estimationMeal,
                    index: i,
                    estimationRecipeSelectedIndex: widget.estimationRecipeIndex,
                    estimationIngredientList: widget.estimationIngredientList,
                    estimationIngredientQuantityList:
                        widget.estimationIngredientQuantityList),
              );
            }
          } else {
            items.add(
              EstimationMealCard(
                  estimationMeal: widget.estimationMeal,
                  index: 0,
                  estimationIngredientList: widget.estimationIngredientList,
                  estimationRecipeSelectedIndex: widget.estimationRecipeIndex,
                  estimationIngredientQuantityList:
                      widget.estimationIngredientQuantityList),
            );

            bloc.add(AddEstimationRecipeEvent(
                EstimationRecipe(
                    name: state.estimationMeal.name! + " example 1",
                    frequency: 1),
                state.estimationMeal.id!));
          }
        } //end if state
      });

      //fill the list so i can add at any index
      if (widget.estimationIngredientQuantityList.isEmpty) {
        for (int i = 0; i < items.length; i++) {
          List<EstimationIngredientQuantity> list = [];
          widget.estimationIngredientQuantityList.add(list);

          List<EstimationIngredient> listIngredient = [];
          widget.estimationIngredientList.add(listIngredient);
        }
      }

      if (widget.estimationIngredientQuantity != null &&
          widget.estimationIngredient != null) {
        //add the quantity and the ingredient at the same index
        widget.estimationIngredientQuantityList
            .elementAt(widget.estimationRecipeIndex!)
            .add(widget.estimationIngredientQuantity!);

        widget.estimationIngredientList
            .elementAt(widget.estimationRecipeIndex!)
            .add(widget.estimationIngredient!);
      }
    });

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
        if (state is EstimationMealLoaded || state is EstimationRecipeAdded) {
          return Scaffold(
            body: SafeArea(
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                               Text(
                                "Insert your meal",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textColor,
                                    letterSpacing: 0),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(
                                  Icons.info_outlined,
                                  color: AppColors.textColor,
                                  size: 35,
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
                            side: const BorderSide(
                                color: AppColors.secondaryColor),
                            shadowColor: AppColors.secondaryColor,
                          ),
                          onPressed: () {
                            items.add(
                              EstimationMealCard(
                                  estimationMeal: widget.estimationMeal,
                                  index: items.length,
                                  estimationRecipeSelectedIndex:
                                      widget.estimationRecipeIndex,
                                  estimationIngredientList:
                                      widget.estimationIngredientList,
                                  estimationIngredientQuantityList:
                                      widget.estimationIngredientQuantityList),
                            );
                            List<EstimationIngredientQuantity> listQuantities =
                                [];
                            List<EstimationIngredient> listIngredients = [];

                            widget.estimationIngredientQuantityList
                                .add(listQuantities);

                            widget.estimationIngredientList
                                .add(listIngredients);

                            bloc.add(AddEstimationRecipeEvent(
                                EstimationRecipe(
                                    name: widget.estimationMeal.name! +
                                        " example " +
                                        (items.length + 1).toString(),
                                    frequency: 1),
                                widget.estimationMeal.id!));
                          },
                          icon: const Icon(
                            CupertinoIcons.plus,
                            color: AppColors.textColor,
                          ),
                          label:  Text(
                            "Add meal example",
                            style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: height / 6,
                        ),
                        Row(
                          children: [
                            SmallButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, Routes.estimationFinalList);
                              },
                              text: "Close",
                              borderColor: AppColors.secondaryColor,
                              colorBg: const Color.fromARGB(255, 255, 255, 255),
                              textColor: AppColors.borderPlanList,
                            ),
                            const Spacer(),
                            SmallButton(
                              onPressed: () {
                                if (state is EstimationMealLoaded) {
                                  var j = 0;
                                  //loop for the list of the quantities list
                                  for (var quantityList in widget
                                      .estimationIngredientQuantityList) {
                                    //adding the ids to a list to send in the request
                                    if (quantityList.isNotEmpty) {
                                      List<int> list = [];
                                      for (var quantity in quantityList) {
                                        list.add(quantity.id!);
                                      }

                                      //sending the request
                                      BlocProvider.of<IntakeEstimationBloc>(
                                              context)
                                          .addListOfEstimationIngredientQuantitiesToEstimatonRecipe(
                                              estimationRecipeId: state
                                                  .estimationMeal
                                                  .estimationRecipe![j]
                                                  .id!,
                                              estimationIngredientQuantitiesIds:
                                                  list);
                                      j++;
                                    }
                                  }
                                }
                              },
                              text: "Done",
                              borderColor: AppColors.secondaryColor,
                              colorBg: AppColors.secondaryColor,
                              textColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColors.secondaryColor, strokeWidth: 2.0,)),
          );
        }
      }),
    );
  }
}
