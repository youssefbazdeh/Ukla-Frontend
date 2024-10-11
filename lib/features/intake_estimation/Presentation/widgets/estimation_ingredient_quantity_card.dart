import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_ingredient.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_ingredient_quantity.dart';
import '../../../view_recipe/Presentation/Widgets/ingredient_image.dart';

class EstimationIngredientQuantityCard extends StatefulWidget {
  final EstimationIngredientQuantity ingredientQuantity;
  final EstimationIngredient ingredient;

  const EstimationIngredientQuantityCard(
      {super.key, required this.ingredientQuantity, required this.ingredient});

  @override
  State<EstimationIngredientQuantityCard> createState() =>
      _EstimationIngredientQuantityCardState();
}

class _EstimationIngredientQuantityCardState
    extends State<EstimationIngredientQuantityCard> {
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
        //Navigator.pushNamed(context, Routes.ingredientQuantity);
        /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IngredientQuantity(
                ingredient: widget.ingredient,
              ),
            ));*/
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
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                        text:
                            "${widget.ingredientQuantity.quantity} ${widget.ingredient.unit} ",
                        style:  TextStyle(
                            fontSize: 17.sp, fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: widget.ingredient.name,
                        style:  TextStyle(fontSize: 17.sp)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {},
                icon: const Icon(Ionicons.close_outline,
                    color: Color(0xFF989898)))
          ]),
        ),
      ),
    );
  }
}
