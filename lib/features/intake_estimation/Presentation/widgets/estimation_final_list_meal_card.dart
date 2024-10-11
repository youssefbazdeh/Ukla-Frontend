import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_meal.dart';

import '../../../../core/Presentation/resources/colors_manager.dart';
import '../../Domain/entities/estimation_ingredient.dart';
import '../../Domain/entities/estimation_ingredient_quantity.dart';
import '../pages/meal_example.dart';

// ignore: must_be_immutable
class EstimationFinalListMealCard extends StatefulWidget {
  EstimationMeal estimationMeal;
  EstimationFinalListMealCard({
    Key? key,
    required this.estimationMeal,
  }) : super(key: key);

  @override
  State<EstimationFinalListMealCard> createState() =>
      _EstimationFinalListMealCardState();
}

class _EstimationFinalListMealCardState
    extends State<EstimationFinalListMealCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<List<EstimationIngredient>> estimationIngredientList = [];
    List<List<EstimationIngredientQuantity>> estimationIngredientQuantityList =
        [];

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealExample(
                estimationMeal: widget.estimationMeal,
                estimationIngredientList: estimationIngredientList,
                estimationIngredientQuantityList:
                    estimationIngredientQuantityList,
              ),
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderQuestion),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(
                width: width / 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.estimationMeal.name!,
                    style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400),
                  ),
                )),
            const Spacer(),
            if (widget.estimationMeal.filled == false)
              const Icon(
                Icons.check_circle,
                color: AppColors.borderQuestion,
              ),
          ],
        ),
      ),
    );
  }
}
