import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/components/skeletonContainer.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/core/analytics/events.dart';
import 'package:ukla_app/features/plan_Management/Domain/Use_Case/PlanService.dart';
import 'package:ukla_app/features/plan_Management/Presentation/pages/add_recipe_to_meal.dart';
import 'package:ukla_app/features/plan_Management/Presentation/widgets/suggested_recipe_card.dart';
import 'package:ukla_app/features/view_recipe/Domain/Entities/recipe.dart';

import '../../../../core/Presentation/resources/strings_manager.dart';
import '../../../../main.dart';
import '../../../search_recipes_added_to_meal/Data/recipes_services.dart';
import '../../../view_recipe/Presentation/show_recipe.dart';
import '../../Domain/Entity/Plan.dart';

class EmptyRecipe extends StatefulWidget {
  EmptyRecipe(
      {required this.itemCounts,
      required this.onPressed,
      required this.onSuggest,
      required this.onSuggestionByttonOnClick,
      required this.mealname,
      required this.suggestionCounter,
      Key? key})
      : super(key: key);
  int itemCounts;
  bool onSuggestionByttonOnClick;
  final Function onPressed;
  final Function onSuggest;
  final String mealname;
  int suggestionCounter;

  @override
  State<EmptyRecipe> createState() => _EmptyRecipeState();
}

Recipe? recipe;

class _EmptyRecipeState extends State<EmptyRecipe> {
  @override
  void initState() {
    widget.suggestionCounter = 0;
    super.initState();
  }

  List<Recipe> recipes = [];
  Future<Recipe> getsuggestions(String mealname) async {
    if (widget.suggestionCounter == 1) {
      recipes = await PlanService.getReceipesByMealTag(mealname);
      return recipes[0];
    } else if (widget.suggestionCounter == 2) {
      return recipes[1];
    } else if (widget.suggestionCounter == 3) {
      widget.suggestionCounter = 0;
      return recipes[2];
    } else {
      return recipes[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var doubleGrayCard;
    width > 350 ? doubleGrayCard = width * 0.7 : 240;
    int indexDay =
        Provider.of<indexTabBarPlan>(context, listen: false).getIndex();
    int indexMeal2 = Provider.of<indexMeal>(context, listen: false).getIndex();

    var mealName = Provider.of<PlanProvider>(context, listen: false)
        .getplan()
        .days[indexDay]
        .meals![indexMeal2]
        .name;

    if (mealName.capitalize() != getMealNameInEnglish(widget.mealname)) {
      setState(() {
        widget.suggestionCounter = 0;
      });
    }
    if (widget.onSuggestionByttonOnClick == false) {
      return Row(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 10, right: 0, left: 10, bottom: 20),
            child: Container(
              height: 100,
              width: doubleGrayCard,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0, 2), //(x,y)
                      blurRadius: 3.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0XFFFDFDFD)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      color: Color(0XFFC4C4C4),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          GreyContainer(circular: 10, height: 10, width: 80),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GreyContainer(circular: 10, height: 10, width: 60),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              GreyContainer(
                                  circular: 10, height: 12, width: 27),
                              SizedBox(
                                height: 5,
                              ),
                              GreyContainer(
                                  circular: 10, height: 12, width: 17),
                            ],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            children: [
                              GreyContainer(
                                  circular: 10, height: 12, width: 27),
                              SizedBox(
                                height: 5,
                              ),
                              GreyContainer(
                                  circular: 10, height: 12, width: 17),
                            ],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            children: [
                              GreyContainer(
                                  circular: 10, height: 12, width: 27),
                              SizedBox(
                                height: 5,
                              ),
                              GreyContainer(
                                  circular: 10, height: 12, width: 17),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color(0XFFC4C4C4)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 20),
            child: SizedBox(
              height: 100,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      widget.onPressed();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => AddRecipeToMeal())));
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: const Color(0XFFFF7B8A),
                            borderRadius:
                                BorderRadiusDirectional.circular(200)),
                        child: const Icon(
                          Ionicons.add,
                          color: Colors.white,
                          size: 30,
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: const Color(0XFF7D99FF),
                          borderRadius: BorderRadiusDirectional.circular(200)),
                      child: GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              widget.suggestionCounter++;
                              widget.onSuggest();
                              widget.onSuggestionByttonOnClick = true;
                            });
                          }
                        },
                        child: const Icon(
                          Ionicons.sync_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      );
    } else {
      return Row(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 10, right: 0, left: 5, bottom: 20),
            child: Container(
              height: 120,
              width: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0, 2), //(x,y)
                      blurRadius: 3.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0XFFFDFDFD)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: FutureBuilder<Recipe>(
                        future: getsuggestions(getMealNameInEnglish(widget.mealname)),
                        builder:
                            (BuildContext context, AsyncSnapshot<Recipe> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              color: AppColors.secondaryColor,
                              strokeWidth: 2.0,
                            );
                          } else if (snapshot.hasError) {
                            return
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(child: Text('Error fetching recipes'.tr(context))),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              widget.onSuggestionByttonOnClick =
                                              false;
                                            });
                                          },
                                          icon: const Icon(Ionicons.close_circle, color: Colors.red)),
                                    ],
                                  ),
                                );
                          } else {
                            // Get the first recipe in the list
                            Recipe firstRecipe = snapshot.data!;
                            recipe = firstRecipe;
                      
                            // Return a Card widget displaying the first recipe
                            return Stack(
                              children: [
                                SuggestedRecipeCard(
                                    mealTitle: firstRecipe.name,
                                    onPressed: () {
                                      FireBaseAnalyticsEvents.recipeViewed(firstRecipe.name);
                                      FireBaseAnalyticsEvents.screenViewed('recipe_view');
                                      showRecipe(
                                        context,
                                        firstRecipe.name,
                                        firstRecipe.id!,
                                      );
                                    },
                                    calories: firstRecipe.nbrCalories.truncate(),
                                    cookingtime: firstRecipe.cookingTime +
                                        firstRecipe.preparationTime,
                                    image:
                                        "${AppString.SERVER_IP}/ukla/file-system/image/${firstRecipe.image.id}",
                                    selectOrDeselect: (value) {},
                                    recipeInList: false
                                ),
                                Positioned(
                                    //left: width / 1.55,
                                    right: 0,
                                    top: 0,
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.onSuggestionByttonOnClick =
                                                false;
                                          });
                                        },
                                        icon: const Icon(Ionicons.close_circle,
                                            color: Colors.red))),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 15, right: 8, left: 8, bottom: 20),
            child: SizedBox(
              height: 100,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      int indexDay =
                          Provider.of<indexTabBarPlan>(context, listen: false)
                              .getIndex();
                      int indexMeal2 =
                          Provider.of<indexMeal>(context, listen: false)
                              .getIndex();
                      ServicesRecipes.addRecipeToMeal(
                          Provider.of<PlanProvider>(context, listen: false)
                              .getplan()
                              .days[indexDay]
                              .meals![indexMeal2]
                              .id!,
                          recipe!.id!);
                      PlanApi plan = Provider.of<PlanProvider>(context, listen: false).getplan();
                      plan.days[indexDay].meals![indexMeal2].recipes.add(recipe!);
                      Provider.of<PlanProvider>(context,listen:false).setPlan(plan);
                      FireBaseAnalyticsEvents.screenViewed('Plan_of_week');
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadiusDirectional.circular(200)),
                        child: const Icon(
                          Ionicons.checkmark,
                          color: Colors.white,
                          size: 30,
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onPressed();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: const Color(0XFF7D99FF),
                          borderRadius: BorderRadiusDirectional.circular(200)),
                      child: GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              widget.suggestionCounter++;

                              widget.onSuggestionByttonOnClick = true;
                            });
                          }
                        },
                        child: const Icon(
                          Ionicons.sync_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      );
    }
  }
  String getMealNameInEnglish(String mealName) {
    String currentLanguageCode = Provider.of<LanguageProvider>(context, listen: false).languageCode;

    if (currentLanguageCode == 'en') {
      return mealName;
    } else {

      Map<String, String> mealNameTranslations = {
        'Petit déjeuner': 'Breakfast',
        'Déjeuner': 'Lunch',
        'Dîner': 'Dinner',
        'العشاء': 'Dinner',
        'الغداء': 'Lunch',
        'الإفطار': 'Breakfast',
      };

      return mealNameTranslations[mealName] ?? mealName;
    }
  }

}
