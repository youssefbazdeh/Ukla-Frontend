import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_ingredient.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_ingredient_quantity.dart';
import '../../../view_recipe/Presentation/Widgets/ingredient_image.dart';
import '../../Domain/entities/estimation_meal.dart';
import '../pages/meal_example.dart';

class EstimationIngredientQuantityListCard extends StatefulWidget {
  final EstimationIngredientQuantity estimationIngredientQuantity;
  final EstimationMeal estimationMeal;
  final EstimationIngredient estimationIngredient;
  final int index;
  final List<List<EstimationIngredient>> estimationIngredientList;
  final List<List<EstimationIngredientQuantity>>
      estimationIngredientQuantityList;

  const EstimationIngredientQuantityListCard({
    Key? key,
    required this.estimationIngredientQuantity,
    required this.estimationMeal,
    required this.estimationIngredient,
    required this.index,
    required this.estimationIngredientList,
    required this.estimationIngredientQuantityList,
  }) : super(key: key);

  @override
  State<EstimationIngredientQuantityListCard> createState() =>
      _EstimationIngredientQuantityListCardState();
}

class _EstimationIngredientQuantityListCardState
    extends State<EstimationIngredientQuantityListCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealExample(
                  estimationRecipeIndex: widget.index,
                  estimationIngredientQuantity:
                      widget.estimationIngredientQuantity,
                  estimationMeal: widget.estimationMeal,
                  estimationIngredient: widget.estimationIngredient,
                  estimationIngredientList: widget.estimationIngredientList,
                  estimationIngredientQuantityList:
                      widget.estimationIngredientQuantityList),
            ));
      },
      child: Container(
        padding: const EdgeInsets.only(top: 8, left: 2, right: 2, bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: AppColors.borderQuestion),
        ),
        child: Column(children: [
          IngredientImage(
              ingredientId: widget.estimationIngredientQuantity.imageID!),
          const SizedBox(
            height: 2,
          ),
          Text(
              "${widget.estimationIngredientQuantity.quantity} ${widget.estimationIngredient.unit} ",
              style:
                   TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}
