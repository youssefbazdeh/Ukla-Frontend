import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/analytics/events.dart';
import 'package:ukla_app/features/plan_Management/Presentation/widgets/empty_recipe_in_meal.dart';
import 'package:ukla_app/features/search_recipes_added_to_meal/Data/recipes_services.dart';
import 'package:ukla_app/features/view_recipe/Presentation/show_recipe.dart';
import 'package:ukla_app/main.dart';
import '../../../view_recipe/Domain/Entities/recipe.dart';
import 'card_recipe_plan.dart';

typedef ValueChangedd = void Function(String, bool, bool);

enum Menu { itemOne, itemTwo, itemThree }

class MealEmptyCard extends StatefulWidget {
  MealEmptyCard({
    required this.mealTitle,
    required this.onPressed,
    required this.selecteditem,
    this.addrecipe,
    this.index,
    required this.onSuggest,
    required this.recipes,
    required this.tetsvalue,
    required this.addToDB,
    required this.mealtextController,
    this.onButtonPressed,
    Key? key,
  }) : super(key: key);

  final String mealTitle;
  final GestureTapCallback onPressed;
  final GestureTapCallback onSuggest;
  final ValueChanged<String> selecteditem;
  final ValueChanged<bool>? addrecipe;
  final int? index;
  final List<Recipe> recipes;
  bool tetsvalue;
  final ValueChangedd addToDB;
  TextEditingController mealtextController;
  final Function(bool)? onButtonPressed;

  @override
  State<MealEmptyCard> createState() => _MealEmptyCardState();
}

class _MealEmptyCardState extends State<MealEmptyCard> {
  String selecteditem = "";
  bool addrecipe = false;
  FocusNode myFocusNode = FocusNode();
  bool boovalue = true;
  bool completeTypingMealTitle = false;
  bool isEnabled = false;
  bool shouldShiftFocus = true; // Added flag
  int itemcounts=0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  void tetsing() {
    if (widget.tetsvalue == boovalue) {
      isEnabled = true;
      myFocusNode.requestFocus();
      boovalue = false;
      widget.tetsvalue = false;
    }
  }

  void isEnabledmeal() {
    myFocusNode.requestFocus();
  }

  void unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    widget.mealtextController.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.mealtextController.text.length),
    );
    tetsing();
    String _selectedMenu = "";
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        if (mounted) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (myFocusNode.hasFocus) {
              completeTypingMealTitle = true;
              widget.addToDB(
                Provider.of<PlanProvider>(context, listen: false)
                    .getmealTitle(),
                completeTypingMealTitle,
                isEnabled,
              );
              isEnabled = false;
              if (mounted) unfocus();
              completeTypingMealTitle = false;
            }
          });
        }
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width / 25,
            vertical: height / 60,
          ),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  offset: Offset(0, 2),
                  blurRadius: 6.0,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              color: const Color(0XFFF2F2F2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: width / 1.5,
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          onSubmitted: (value) {
                            if (myFocusNode.hasFocus) {
                              completeTypingMealTitle = true;
                              widget.addToDB(
                                widget.mealtextController.text,
                                completeTypingMealTitle,
                                isEnabled,
                              );
                              isEnabled = false;
                              if (mounted) unfocus();
                              completeTypingMealTitle = false;
                            }
                          },
                          controller: widget.mealtextController,
                          onTap: () {
                            Provider.of<PlanProvider>(context, listen: false)
                                .addmealIndex(widget.index!);
                          },
                          onChanged: (value) async {
                            Provider.of<PlanProvider>(context, listen: false)
                                .addmealtitle(value);
                            Future.delayed(Duration.zero, () {});
                          },
                          style:  TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          focusNode: myFocusNode,
                          enabled: isEnabled,
                          decoration:  InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      PopupMenuButton<Menu>(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        onSelected: (Menu item) {
                          _selectedMenu = item.name;

                          if (item.name == "itemOne") {
                            if (shouldShiftFocus) {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) async {
                                FocusScope.of(context)
                                    .requestFocus(myFocusNode);
                              });
                              isEnabled = true;
                              if (mounted) setState(() {});
                            }
                          } else {
                            isEnabled = false;
                          }
                          selecteditem = _selectedMenu;
                          widget.selecteditem(selecteditem);
                        },
                        itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<Menu>>[
                          PopupMenuItem<Menu>(
                            value: Menu.itemOne,
                            child: Row(
                              children: [
                                const Icon(Ionicons.share_outline),
                                const SizedBox(width: 5),
                                Text('Rename meal'.tr(context)),
                              ],
                            ),
                          ),
                          PopupMenuItem<Menu>(
                            value: Menu.itemTwo,
                            child: Row(
                              children: [
                                const Icon(CupertinoIcons.trash),
                                const SizedBox(width: 5),
                                Text('Delete meal'.tr(context)),
                              ],
                            ),
                          ),
                          PopupMenuItem<Menu>(
                            value: Menu.itemThree,
                            child: Row(
                              children: [
                                const Icon(Ionicons.arrow_redo_outline),
                                const SizedBox(width: 5),
                                Text('Share meal'.tr(context)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.recipes.length,
                  itemBuilder: ((context, index) {
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            right: 10,
                            left: 10,
                            bottom: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CardRecipePlan(
                                tags: widget.recipes[index].tags,
                                preparationTime:
                                widget.recipes[index].preparationTime,
                                recipeTitle: widget.recipes[index].name,
                                onPressed: () {
                                  FireBaseAnalyticsEvents.recipeViewed(widget.recipes[index].name);
                                  FireBaseAnalyticsEvents.screenViewed('recipe_view');
                                  showRecipe(
                                    context,
                                    widget.recipes[index].name,
                                    widget.recipes[index].id!,
                                  );
                                },
                                calories: widget.recipes[index].nbrCalories
                                    .toInt(),
                                cookingtime: widget.recipes[index].cookingTime,
                                image:
                                "${AppString.SERVER_IP}/ukla/file-system/image/${widget.recipes[index].image.id}",
                                isChecked: (value) async{
                                  if (value) {
                                    await ServicesRecipes.deleteRecipeFromMeal(
                                      Provider.of<PlanProvider>(context,
                                          listen: false)
                                          .getplan()
                                          .days[Provider.of<indexTabBarPlan>(
                                          context,
                                          listen: false)
                                          .getIndex()]
                                          .meals![widget.index!]
                                          .id!,
                                      widget.recipes[index].id!,
                                    );

                                    Provider.of<PlanProvider>(context, listen: false).removeRecipeFromMeal(
                                      Provider.of<indexTabBarPlan>(context, listen: false).getIndex(),
                                      widget.index!,
                                      widget.recipes[index].id!,
                                    );

                                    if (mounted) setState(() {});
                                    FireBaseAnalyticsEvents.screenViewed('Plan_of_week');
                                  }
                                },
                              ),
                              const Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                EmptyRecipe(
                  mealname: widget.mealTitle,
                  itemCounts: itemcounts,
                  onPressed: widget.onPressed,
                  onSuggestionByttonOnClick: false,
                  onSuggest: widget.onSuggest,
                  suggestionCounter: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}