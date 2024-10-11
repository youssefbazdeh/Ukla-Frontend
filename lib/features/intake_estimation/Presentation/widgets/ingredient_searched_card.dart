import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_ingredient.dart';
import '../../../view_recipe/Presentation/Widgets/ingredient_image.dart';
import '../../Domain/entities/estimation_ingredient_quantity.dart';
import '../../Domain/entities/estimation_meal.dart';
import '../pages/ingredient_quantity.dart';

class IngredientSearchedCard extends StatefulWidget {
  final EstimationIngredient ingredient;
  final EstimationMeal estimationMeal;
  final int index;
  final List<List<EstimationIngredient>> estimationIngredientList;
  final List<List<EstimationIngredientQuantity>>
      estimationIngredientQuantityList;

  const IngredientSearchedCard({
    super.key,
    required this.ingredient,
    required this.estimationMeal,
    required this.index,
    required this.estimationIngredientList,
    required this.estimationIngredientQuantityList,
  });

  @override
  State<IngredientSearchedCard> createState() => _IngredientSearchedCardState();
}

class _IngredientSearchedCardState extends State<IngredientSearchedCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double widthValue;
    if (width < 360) {
      widthValue = width * 0.25;
    } else {
      widthValue = width * 0.35;
    }

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IngredientQuantity(
                  ingredient: widget.ingredient,
                  estimationMeal: widget.estimationMeal,
                  index: widget.index,
                  estimationIngredientList: widget.estimationIngredientList,
                  estimationIngredientQuantityList:
                      widget.estimationIngredientQuantityList),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0X80F6F6F6),
          ),
          child: Row(children: [
            IngredientImage(ingredientId: widget.ingredient.ingredientImageID!),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: widthValue,
              child: Text(widget.ingredient.name!,
                  style:  TextStyle(fontSize: 17.sp, color: Colors.black)),
            ),
            const Spacer(),
          ]),
        ),
      ),
    );
  }
}
