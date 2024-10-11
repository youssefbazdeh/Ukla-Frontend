import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_meal.dart';
import 'package:ukla_app/features/intake_estimation/Presentation/pages/search_ingredient.dart';

import '../../../../core/Presentation/buttons/main_red_button.dart';
import '../../../../core/Presentation/resources/colors_manager.dart';
import '../../Domain/entities/estimation_ingredient.dart';
import '../../Domain/entities/estimation_ingredient_quantity.dart';
import 'estimation_ingredient_quantity_card.dart';

class EstimationMealCard extends StatefulWidget {
  final EstimationMeal estimationMeal;
  final int index;
  final int? estimationRecipeSelectedIndex;
  final List<List<EstimationIngredient>> estimationIngredientList;
  final List<List<EstimationIngredientQuantity>>
      estimationIngredientQuantityList;

  const EstimationMealCard(
      {Key? key,
      required this.estimationMeal,
      required this.index,
      required this.estimationIngredientList,
      required this.estimationIngredientQuantityList,
      this.estimationRecipeSelectedIndex})
      : super(key: key);

  @override
  State<EstimationMealCard> createState() => _EstimationMealCardState();
}

class _EstimationMealCardState extends State<EstimationMealCard> {
  List<DropdownMenuItem<int>> get dropdownItems {
    List<DropdownMenuItem<int>> menuItems = [
      const DropdownMenuItem(child: Text("1 day a week"), value: 1)
    ];
    for (var i = 2; i < 8; i++) {
      menuItems.add(DropdownMenuItem(
          child: Text(i.toString() + " days a week"), value: i));
    }
    return menuItems;
  }

  int selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderQuestion),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width / 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.estimationMeal.estimationRecipe != null
                        ? widget.estimationMeal.estimationRecipe![widget.index]
                            .name!
                        : widget.estimationMeal.name! +
                            " example " +
                            (widget.index + 1).toString(),
                    maxLines: 2,
                    style:  TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                        letterSpacing: 0),
                  ),
                ),
              ),
              Row(
                children: [
                  const Text(
                    "frequency",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, letterSpacing: 0),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Material(
                    elevation: 2,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AppColors.backgroundGrey,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                                color: AppColors.backgroundGrey,
                                blurRadius: 5,
                                spreadRadius: 2)
                          ]),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          iconStyleData: const IconStyleData(
                            icon: Visibility(
                                visible: false,
                                child: Icon(Icons.arrow_downward)),
                          ),
                          selectedItemBuilder: (BuildContext context) {
                            return <String>['1', '2', '3', '4', '5', '6', '7']
                                .map((String value) {
                              return Text(
                                "x " + selectedValue.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              );
                            }).toList();
                          },
                          value: selectedValue,
                          items: dropdownItems,
                          onChanged: (int? value) {
                            setState(() {
                              selectedValue = value!;
                            });
                          },
                          dropdownStyleData: DropdownStyleData(
                            width: 140,
                            offset: Offset(-width / 3.8, -12),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black26,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          if (widget.estimationIngredientQuantityList.isNotEmpty &&
              widget.estimationIngredientList.isNotEmpty)
            ListView.builder(
                itemCount: widget
                    .estimationIngredientQuantityList[widget.index].length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return EstimationIngredientQuantityCard(
                    ingredient: widget.estimationIngredientList[widget.index]
                        [index],
                    ingredientQuantity: widget
                        .estimationIngredientQuantityList[widget.index][index],
                  );
                  //}
                }),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              child: MainRedButton(
                onPressed: () {
                  //Navigator.pushNamed(context, Routes.searchIngredient);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchIngredient(
                            estimationMeal: widget.estimationMeal,
                            index: widget.index,
                            estimationIngredientList:
                                widget.estimationIngredientList,
                            estimationIngredientQuantityList:
                                widget.estimationIngredientQuantityList),
                      ));
                },
                text: "add ingredient",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
