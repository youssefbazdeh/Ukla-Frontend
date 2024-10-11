import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/core/Presentation/components/translateUnitLogic.dart';
import 'package:ukla_app/main.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../features/view_recipe/Domain/Entities/recipe.dart';
import '../../../features/view_recipe/Presentation/Widgets/ingredient_image.dart';

class TranlatedIngredientQuantityObject extends StatefulWidget {
  final Recipe recipe;
  final int index;
  final double height;
  final String? contentLanguageCode;

  const TranlatedIngredientQuantityObject({
    Key? key,
    required this.recipe,
    required this.index,
    required this.height,
    this.contentLanguageCode,
  }) : super(key: key);

  @override
  State<TranlatedIngredientQuantityObject> createState() => _TranlatedIngredientQuantityObject();
}
  class _TranlatedIngredientQuantityObject extends State<TranlatedIngredientQuantityObject>{

  Timer? _timer;
    bool isVisible = false;

    void _stopTimer() {
      _timer?.cancel();
    }

    void _resetTimer() {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
        if (isVisible) {
        } else {
          _stopTimer();
        }
      });
    }


    @override
    Widget build(BuildContext context) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.recipe.steps[widget.index].ingredientQuantityObjects.length,
        itemBuilder: (context, indexItem) {
          double quan = widget.recipe.steps[widget.index].ingredientQuantityObjects[indexItem].quantity;
          String quantity;
          if (quan == quan.truncateToDouble()) {
            quantity = quan.truncate().toStringAsFixed(0);
          } else {
            quantity = quan.toStringAsFixed(2);
          }
          int? imageID = widget.recipe.steps[widget.index].ingredientQuantityObjects[indexItem].ingredient.image!.id;
          return VisibilityDetector(
            key: Key('ingredient-$indexItem'),
            onVisibilityChanged: (VisibilityInfo info) {
              isVisible = info.visibleFraction > 0;
              if (info.visibleFraction > 0 && widget.recipe.steps[widget.index].ingredientQuantityObjects[indexItem].ingredient.ingredientAd != null) {
                _resetTimer();
                Timer(const Duration(seconds: 2), () {
                  if (!Provider.of<ViewedIngredientAdProvider>(context,listen: false).idsList.contains(widget.recipe.steps[widget.index].ingredientQuantityObjects[indexItem].ingredient.ingredientAd!.id)) {
                    Provider.of<ViewedIngredientAdProvider>(context,listen: false).setIdsList([widget.recipe.steps[widget.index].ingredientQuantityObjects[indexItem].ingredient.ingredientAd!.id]);
                  }
                });
              } else {
                _stopTimer();
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: widget.height / 95, horizontal: 16),
              child: Row(children: [
                IngredientImage(
                  ingredientId: imageID,
                ),
                const SizedBox(
                  width: 20,
                ),
                if(widget.contentLanguageCode == 'ar')...[
                  Text(
                    '${widget.recipe.steps[widget.index].ingredientQuantityObjects[indexItem].ingredient.name} ${widget.recipe.steps[widget.index].ingredientQuantityObjects[indexItem].ingredient.ingredientAd != null ?
                    ' ${widget.recipe.steps[widget.index].ingredientQuantityObjects[indexItem].ingredient.ingredientAd!.brandName}' : ''}',
                    style: TextStyle(
                        fontSize: 17.sp),
                  ),
                  const SizedBox(width: 5),
                  Text(
                      "$quantity ${translateUnit(widget.recipe.steps[widget.index].ingredientQuantityObjects[indexItem].unit, widget.contentLanguageCode ?? 'en')}",
                      textDirection: TextDirection.rtl,
                  style:  TextStyle(
                      fontSize: 17.sp,
                          fontWeight:
                          FontWeight.w600)),
                ]else...[
                  Text(
                      "$quantity ${translateUnit(widget.recipe.steps[widget.index].ingredientQuantityObjects[indexItem].unit, widget.contentLanguageCode ?? 'en')}",
                      style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight:
                          FontWeight.w600)),
                  const SizedBox(width: 5),
                  Text(
                    '${widget.recipe.steps[widget.index].ingredientQuantityObjects[indexItem].ingredient.name} ${widget.recipe.steps[widget.index].ingredientQuantityObjects[indexItem].ingredient.ingredientAd != null ? ' ${widget.recipe.steps[widget.index].ingredientQuantityObjects[indexItem].ingredient.ingredientAd!.brandName}' : ''}',
                    style: TextStyle(
                        fontSize: 17.sp),
                  ),
                ],
              ]),
            ),
          );
        },
      );
    }
  }
