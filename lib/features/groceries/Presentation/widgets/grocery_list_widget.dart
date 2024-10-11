import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/features/groceries/Domain/Entities/grocery_list.dart';
import 'package:ukla_app/features/groceries/Presentation/widgets/purchased_ingr_card.dart';
import 'package:ukla_app/features/groceries/Presentation/widgets/recipe_image.dart';
import 'package:ukla_app/features/groceries/Presentation/widgets/unpurchased_ingr_card.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../core/Presentation/components/translate_day_logic.dart';
import '../../../../main.dart';
import '../../Domain/Entities/grocery_ingredient.dart';
import '../../Domain/logic.dart';
import '../bloc/grocery_bloc.dart';
import '../bloc/grocery_event.dart';

class GroceryListWidget extends StatefulWidget {
  final GroceryList groceryList;
  final GroceryBloc bloc;
  final bool byCategory;
  final Map<String, List<GroceryIngredient>>? map;
  const GroceryListWidget(
      {Key? key, required this.groceryList, required this.bloc, required this.byCategory, this.map})
      : super(key: key);

  @override
  State<GroceryListWidget> createState() => _GroceryListWidgetState();
}

class _GroceryListWidgetState extends State<GroceryListWidget> {
  bool hasPurchasedItems() {
    for (var day in widget.groceryList.groceryDays!) {
      for (var recipe in day.recipes!) {
        for (var item in recipe.groceryIngredientQuantityObjects!) {
          if (item.purchased!) {
            return true;
          }
        }
      }
    }
    return false;
  }
  bool isVisible = false;
  Timer? _timer;

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
    bool hasPurchased = hasPurchasedItems();
    var viewedIngredientAdIdsProvider = Provider.of<ViewedIngredientAdIdsProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.byCategory == true) ...[
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.map!.keys.map((key) {
                //key is the type
                List<GroceryIngredient> value = widget.map![key]!;
                return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    //color: Colors.amber,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            key,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //show it's ingredients
                        ListView.builder(
                            itemCount: value.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              GroceryIngredient ingredient = value[index];
                              return VisibilityDetector(
                                key: Key("ingredient : ${ingredient.ingredientName}"),
                                onVisibilityChanged: (VisibilityInfo info){
                                  if(info.visibleFraction > 0 && ingredient.ingredientAdId!= null){
                                    _resetTimer();
                                    Timer(const Duration(seconds: 2),(){
                                      if(!viewedIngredientAdIdsProvider.viewedIngredientAdIds.contains(ingredient.ingredientAdId)){
                                        viewedIngredientAdIdsProvider.addViewedIngredientAdId(ingredient.ingredientAdId!);
                                      }
                                    });
                                  }else{
                                    _stopTimer();
                                  }
                                },
                                child: UnpurchasedIngredientCard(
                                    ingredient: ingredient,
                                    groceryByCategory: true,
                                    groceryList: widget.groceryList),
                              );
                            }),
                      ],
                    ));
              }).toList()),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Purchased".tr(context),
                  style:  TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
              ),
              const Spacer(),
              TextButton(
                  onPressed: hasPurchased
                      ? () {
                    List<GroceryIngredient> groceryIngredientToDelete = [];
                    for (var day in widget.groceryList.groceryDays!) {
                      for (var recipe in day.recipes!) {
                        for (var item in recipe.groceryIngredientQuantityObjects!) {
                          groceryIngredientToDelete.add(item);
                        }
                      }
                    }
                    widget.bloc.add(RemoveAllIngredients(
                        getAllPurchasedindexes(widget.groceryList),
                        Provider.of<SelectedContentLanguage>(context,
                            listen: false)
                            .contentLanguageCode,
                        groceryIngredientToDelete));
                  }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      "Clear All".tr(context),
                      style:  TextStyle(
                          fontWeight: FontWeight.w600,
                           color: hasPurchased ? Colors.red : Colors.grey,
                          fontSize: 16.sp),
                    ),
                  ))
            ],
          ),
          for (var l in widget.groceryList.groceryDays!)
            for (var recipe in l.recipes!)
              ListView.builder(
                  itemCount: recipe.groceryIngredientQuantityObjects!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    GroceryIngredient ingredient = recipe.groceryIngredientQuantityObjects![index];
                    if (ingredient.purchased!) {
                      return VisibilityDetector(
                        key: Key("ingredient : ${ingredient.ingredientName}"),
                        onVisibilityChanged: (VisibilityInfo info){
                          if(info.visibleFraction > 0 && ingredient.ingredientAdId!= null){
                            _resetTimer();
                            Timer(const Duration(seconds: 2),(){
                              if(!viewedIngredientAdIdsProvider.viewedIngredientAdIds.contains(ingredient.ingredientAdId)){
                                viewedIngredientAdIdsProvider.addViewedIngredientAdId(ingredient.ingredientAdId!);
                              }
                            });
                          }else{
                            _stopTimer();
                          }
                        },
                        child: PurchasedIngredientCard(
                            ingredient: ingredient,
                            groceryByCategory: true,
                            groceryList: widget.groceryList),
                      );
                    } else {
                      return Container();
                    }
                  }),
        ] else ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.groceryList.groceryDays!.any((l) => l.recipes!.isNotEmpty)) ...[
                for (var l in widget.groceryList.groceryDays!)
                  if (l.recipes!.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              translateDay(
                                  l.day!.toUpperCase(),
                                  Provider.of<LanguageProvider>(context,
                                      listen: false)
                                      .languageCode),
                              style:  TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.sp),
                            ),
                          ),
                          const SizedBox(height: 10),
                          for (var recipe in l.recipes!)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Row(
                                    children: [
                                      RecipeImage(
                                          recipeImageId: recipe.recipeImageID!),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            recipe.recipeName!,
                                            style:  TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18.sp),
                                          ),
                                        ),
                                      ),
                                      if (recipe.groceryIngredientQuantityObjects!
                                          .isEmpty) ...[
                                        const Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text("Ingredients Deleted"),
                                          ),
                                        ),
                                        const SizedBox(width: 10)
                                      ],
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  itemCount: recipe
                                      .groceryIngredientQuantityObjects!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    GroceryIngredient ingredient = recipe.groceryIngredientQuantityObjects![index];
                                    if (!ingredient.purchased!) {
                                      return VisibilityDetector(
                                        key: Key("ingredient: ${ingredient.ingredientName}"),
                                        onVisibilityChanged: (VisibilityInfo info) {
                                          if(info.visibleFraction > 0 && ingredient.ingredientAdId!= null){
                                            _resetTimer();
                                            Timer(const Duration(seconds: 2),(){
                                              if(!viewedIngredientAdIdsProvider.viewedIngredientAdIds.contains(ingredient.ingredientAdId)){
                                                viewedIngredientAdIdsProvider.addViewedIngredientAdId(ingredient.ingredientAdId!);
                                              }
                                            });
                                          }else{
                                            _stopTimer();
                                          }
                                        },
                                        child: UnpurchasedIngredientCard(
                                            ingredient: ingredient,
                                            groceryByCategory: false,
                                            groceryList: widget.groceryList),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
              ] else ...[
                const Center(child: Text("No recipes found."))
              ],
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Purchased".tr(context),
                  style:
                   TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
              ),
              const Spacer(),
              TextButton(
                  onPressed: hasPurchased
                      ? () {
                    List<GroceryIngredient> groceryIngredientToDelete = [];
                    for (var day in widget.groceryList.groceryDays!) {
                      for (var recipe in day.recipes!) {
                        for (var item in recipe.groceryIngredientQuantityObjects!) {
                          groceryIngredientToDelete.add(item);
                        }
                      }
                    }
                    widget.bloc.add(RemoveAllIngredients(
                        getAllPurchasedindexes(widget.groceryList),
                        Provider.of<SelectedContentLanguage>(context,
                            listen: false)
                            .contentLanguageCode,
                        groceryIngredientToDelete));
                  }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      "Clear All".tr(context),
                      style:  TextStyle(
                          fontWeight: FontWeight.w600,
                          color: hasPurchased ? AppColors.secondaryColor : Colors.grey,
                          fontSize: 16.sp),
                    ),
                  ))
            ],
          ),
          for (var l in widget.groceryList.groceryDays!)
            for (var recipe in l.recipes!)
              ListView.builder(
                  itemCount: recipe.groceryIngredientQuantityObjects!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    GroceryIngredient ingredient =
                    recipe.groceryIngredientQuantityObjects![index];
                    if (ingredient.purchased!) {
                      return VisibilityDetector(
                        key: Key("ingredient : ${ingredient.ingredientName}"),
                        onVisibilityChanged: (VisibilityInfo info) {
                          if(info.visibleFraction > 0 && ingredient.ingredientAdId!= null){
                            _resetTimer();
                            Timer(const Duration(seconds: 2),(){
                              if(!viewedIngredientAdIdsProvider.viewedIngredientAdIds.contains(ingredient.ingredientAdId)){
                                viewedIngredientAdIdsProvider.addViewedIngredientAdId(ingredient.ingredientAdId!);
                              }
                            });
                          }else{
                            _stopTimer();
                          }
                        },
                        child: PurchasedIngredientCard(
                            ingredient: ingredient,
                            groceryByCategory: false,
                            groceryList: widget.groceryList
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
        ]
      ],
    );
  }
}
