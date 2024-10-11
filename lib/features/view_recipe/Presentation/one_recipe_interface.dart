import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/components/custom_error_widget.dart';
import 'package:ukla_app/core/analytics/events.dart';
import 'package:ukla_app/features/ads/Presentation/banner_ad_custom_widget.dart';
import 'package:ukla_app/features/view_recipe/Data/recipe_service.dart';
import 'package:ukla_app/features/view_recipe/Domain/chewie_player.dart';
import 'package:ukla_app/features/view_recipe/Presentation/Widgets/quantity_converter.dart';
import 'package:ukla_app/features/view_recipe/Presentation/creator_profile.dart';
import 'package:ukla_app/features/view_recipe/Presentation/creator_widget.dart';
import 'package:ukla_app/features/view_recipe/Presentation/step_by_step.dart';
import 'package:ukla_app/features/view_recipe/Presentation/Widgets/nutritive_fact/nutritive_facts_container.dart';
import '../../../core/Presentation/resources/colors_manager.dart';
import '../../../core/Presentation/components/translateUnitLogic.dart';
import '../../../main.dart';
import '../../ads/Domain/usecases/ingredient_ad_service.dart';
import '../Data/favorites_service.dart';
import '../Domain/Entities/nutritive_fact.dart';
import '../Domain/Entities/recipe.dart';
import '../Domain/Entities/tag.dart';
import '../Domain/recipe_methods.dart';
import 'Widgets/ingredient_image.dart';
import 'Widgets/quantity_converter.dart';
import 'Widgets/step_container.dart';
import 'Widgets/tags_builder.dart';
import 'heart_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class OneRecipeInterface extends StatefulWidget {
  final int? id;


  const OneRecipeInterface({Key? key, this.id})
      : super(key: key);

  @override
  State<OneRecipeInterface> createState() => _OneRecipeInterfaceState();
}

//////variables
TextStyle descriptionStepsStyle =
     TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w400);
Color primary = const Color(0xFFFA6375);
Color bcktype = const Color(0xFFF5F5F5);
Color fgtype = const Color(0xFF8A8A8A);
Color background = const Color(0xFFF6F6F6);
Color topBar = const Color(0xFFF5F5F5);

//bool isSelected = false;
int recipeId = 0;

late Future<Recipe> recipeFuture;

class _OneRecipeInterfaceState extends State<OneRecipeInterface> {

  @override
  void initState() {
    super.initState();
    setState(() {
      recipeFuture = getRecipeByIdWithAd(widget.id!);
    });
    Provider.of<AdDisplayCountModel>(context, listen: false).incrementAndLoad(false);
  }


  bool selectAll = false;
  bool allBoxesAreSelected = false;

  void reloadData(){
    setState(() {
      recipeFuture = getRecipeByIdWithAd(widget.id!);
    });
  }

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

  bool shouldShowAd() {
    final adDisplayCount = Provider.of<AdDisplayCountModel>(context, listen: false).countForRecipe;
    return (adDisplayCount % 3) == 0;
  }

  @override
  Widget build(BuildContext context) {
    String? contentLanguageCode = Provider.of<SelectedContentLanguage>(context, listen: false).contentLanguageCode;
    TextStyle titleingsteps =
         TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold);
    double height = MediaQuery.of(context).size.height;
    double widht = MediaQuery.of(context).size.width;
    List<Tag> tags = [];
    /////paddings
    EdgeInsetsGeometry titlePadding =
        const EdgeInsets.only(left: 10, right: 10);
    EdgeInsetsGeometry tagsPadding = const EdgeInsets.symmetric(horizontal: 10);
    EdgeInsetsGeometry description = const EdgeInsets.symmetric(horizontal: 10);
    EdgeInsetsGeometry ingredientsTitle =
        const EdgeInsets.only(left: 12, right: 15);

    final width = MediaQuery.of(context).size.width;
    List<int> viewedIngredientAdIds = [];
    return WillPopScope(
      onWillPop: () async {
        if (viewedIngredientAdIds.isNotEmpty) {
          incrementIngredientAdViewCount(viewedIngredientAdIds);
          viewedIngredientAdIds.clear();
        }
        return true;
      },
      child: SafeArea(
          child: Scaffold(
              body: FutureBuilder(
                  future: recipeFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(
                        color: AppColors.secondaryColor,
                        strokeWidth: 2.0,
                      ));
                    } else {
                      if (snapshot.hasData) {
                        Recipe recipe = snapshot.data as Recipe;
                        int servings = recipe.portions;
                        // loadStateHeart(rec1ipe);
                        int calories = recipe.nbrCalories.toInt();
                        Map<String, NutritiveFact> nutritivefactvalues =
                            nutritiveFactsValues(recipe);

                        ///tags list
                        for (var element in recipe.tags) {
                          tags.add(Tag(title: element.title));
                        }

                        return NestedScrollView(
                            floatHeaderSlivers: true,
                          headerSliverBuilder: (context, innerBoxIsScrolled) =>
                                [
                                  SliverAppBar(
                                    snap: true,
                                    elevation: 0,
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.transparent,
                                    leading: IconButton(
                                        onPressed: () {
                                          if (viewedIngredientAdIds
                                              .isNotEmpty) {
                                            incrementIngredientAdViewCount(
                                                viewedIngredientAdIds);
                                            viewedIngredientAdIds.clear();
                                          }
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Ionicons.arrow_back)),
                                    floating: true,
                                    actions: [
                                      customHeartFavoris(
                                        isSelected: recipe.favorite,
                                        isChecked: (check) async {
                                          if (check) {
                                          FireBaseAnalyticsEvents.recipeLiked(recipe.name);
                                            await FavoritesServices
                                              .addRecipeToFavorites(recipe.id!);
                                          } else {
                                          FireBaseAnalyticsEvents.recipeDisliked(recipe.name);
                                            await FavoritesServices
                                                .removeRecipeFromFavorites(
                                                    recipe.id!);
                                          }
                                        },
                                      ),
                                      //share icon to implement later
                                      // IconButton(
                                      //     onPressed: () {},
                                      //     icon: const Icon(
                                      //         Ionicons.share_social_outline)),
                                      const SizedBox(
                                        width: 25,
                                      )
                                    ],
                                  ),
                                ],
                            body: ListView(
                              children: [
                              BannerAdCustomWidget(videoUrl: recipe.video!.sasUrl!,id: recipe.id!,shouldShow: shouldShowAd()),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: width * 0.5,
                                      child: Padding(
                                        padding: titlePadding,
                                        child: Text(
                                          recipe.name,
                                        style:  TextStyle(
                                            fontSize: 17.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  if (recipe.creator != null && recipe.creator!.firstname.isNotEmpty && recipe.creator!.lastname.isNotEmpty)...[
                                      Padding(
                                        padding: tagsPadding,
                                      child: GestureDetector(
                                        onTap: (){
                                          if (recipe.creator!=null){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => CreatorProfile(creatorId: recipe.creator!.id)
                                                )
                                            );
                                          }
                                        },
                                        child: CreatorWidget(
                                            name: recipe.creator?.firstname.isEmpty ?? true ? 'Ukla Originals' : recipe.creator!.firstname+" "+recipe.creator!.lastname,
                                            image: recipe.creator!.image!.id
                                        ),
                                      ),
                                    ),
                                    ]
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: description,
                                    child: Text(
                                        recipe.description,
                                        style:  TextStyle(
                                            fontSize: 16.sp,
                                          fontFamily: 'Noto Sans',
                                          fontWeight: FontWeight.w500)),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                    padding: tagsPadding,
                                  child: tagsBuilder(tags,contentLanguageCode)),

                                const SizedBox(
                                  height: 12,
                                ),

                                /////timer + calories
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 15),
                                  child: Row(children: [
                                    //Timer
                                    const Icon(Ionicons.time_outline),
                                    const SizedBox(width: 5),
                                    Text(
                                      "${recipe.cookingTime + recipe.preparationTime} m",
                                    style:  TextStyle(fontSize: 18.sp),
                                    ),
                                    const SizedBox(width: 5),
                                    SizedBox(width: widht / 6),
                                    //Calories
                                    const Icon(Ionicons.flame_outline,
                                        color: Colors.orange),
                                    const SizedBox(width: 5),
                                    Text(
                                      "$calories" + "cal".tr(context),
                                    style:  TextStyle(fontSize: 18.sp),
                                    )
                                  ]),
                                ),

                                const SizedBox(
                                  height: 4,
                                ),
                                //description
                                StatefulBuilder(
                                    builder: ((context, setServingState) {
                                  return Column(
                                    children: [
                                      ////servings
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${recipe.portions} " +
                                                  'Servings'.tr(context),
                                              style:
                                                 TextStyle(fontSize: 18.sp),
                                            ),
                                            const SizedBox(
                                              width: 26,
                                            ),
                                            const Icon(
                                              Ionicons.people_outline,
                                              size: 25,
                                            ),
                                            //  const SizedBox(width: 110),
                                            const Spacer(),
                                            InkWell(
                                              onTap: () {
                                                if (servings > 1) servings--;
                                                setServingState(() {});
                                              },
                                            child:  Text(
                                                '-',
                                              style: TextStyle(fontSize: 30.sp),
                                              ),
                                            ),
                                            const SizedBox(width: 18),
                                            Text(
                                              '$servings',
                                              style:
                                                 TextStyle(fontSize: 18.sp),
                                            ),
                                            const SizedBox(width: 18),
                                            InkWell(
                                            child:  Text(
                                                '+',
                                              style: TextStyle(fontSize: 30.sp),
                                              ),
                                              onTap: () {
                                                servings++;
                                                setServingState(() {});
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      /////ingredients
                                      Padding(
                                        padding: ingredientsTitle,
                                        child: Row(children: [
                                          Text(
                                            'Ingredients'.tr(context),
                                            style: titleingsteps,
                                          ),
                                          const Spacer(),
                                          //feature add ingredients to grocery List to not delete
                                          // const Text(
                                          //   'Select all',
                                          //   style: TextStyle(
                                          //       fontSize: 15,
                                          //       fontWeight: FontWeight.w400,
                                          //       color: Colors.grey),
                                          // )
                                          // /////checkboxex,
                                          // ,
                                          // const SizedBox(width: 10),

                                          // GestureDetector(
                                          //   onTap: () {
                                          //     setServingState(() {
                                          //       selectAll = !selectAll;
                                          //       for (var i = 0;
                                          //           i <
                                          //               selectedIngredientsList
                                          //                   .length;
                                          //           i++) {
                                          //         selectedIngredientsList[i] =
                                          //             selectAll;
                                          //       }
                                          //     });
                                          //   },
                                          //   child: AnimatedContainer(
                                          //     height: 25,
                                          //     width: 25,
                                          //     duration: const Duration(
                                          //         milliseconds: 200),
                                          //     decoration: BoxDecoration(
                                          //         border: selectAll == false
                                          //             ? Border.all(
                                          //                 color: Colors.black)
                                          //             : Border.all(
                                          //                 color: primary),
                                          //         borderRadius:
                                          //             BorderRadius.circular(6),
                                          //         color: selectAll == true
                                          //             ? primary
                                          //             : Colors.transparent),
                                          //     child: selectAll == true
                                          //         ? const Icon(
                                          //             Ionicons.checkmark,
                                          //             color: Colors.white,
                                          //           )
                                          //         : null,
                                          //   ),
                                          // ),
                                        ]),
                                      ),
                                      const SizedBox(height: 15),
                                      //////////////////////////ingredients
                                      ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: recipe.steps.length,
                                    itemBuilder: (BuildContext context, int index) {
                                          return ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                          itemCount: recipe.steps[index].ingredientQuantityObjects.length,
                                          itemBuilder: (context, indexItem) {
                                                ////to be revisisted
                                            double quan = (((recipe.steps[index].ingredientQuantityObjects[indexItem].quantity) * servings) / recipe.portions);
                                            String quantity;
                                            if (quan == quan.truncateToDouble()) {
                                              quantity = quan.truncate().toStringAsFixed(0);
                                            } else {
                                              quantity = quan.toStringAsFixed(2);
                                            }
                                                int? imageID = recipe.steps[index].ingredientQuantityObjects[indexItem].ingredient.ingredientAd?.image?.id ?? recipe.steps[index].ingredientQuantityObjects[indexItem].ingredient.image!.id;
                                                return VisibilityDetector(
                                                  key: Key('item-$indexItem'),
                                                  onVisibilityChanged:
                                                      (VisibilityInfo info) {
                                                    isVisible =
                                                        info.visibleFraction >
                                                            0;
                                                    if (info.visibleFraction >
                                                            0 &&
                                                        recipe
                                                                .steps[index]
                                                                .ingredientQuantityObjects[
                                                                    indexItem]
                                                                .ingredient
                                                                .ingredientAd !=
                                                            null) {
                                                      _resetTimer();
                                                      Timer(
                                                          const Duration(
                                                              seconds: 2), () {
                                                        if (!viewedIngredientAdIds
                                                            .contains(
                                                            recipe
                                                                .steps[index]
                                                                .ingredientQuantityObjects[
                                                            indexItem]
                                                                .ingredient
                                                                .ingredientAd!
                                                                .id)) {
                                                          viewedIngredientAdIds
                                                              .add(
                                                              recipe
                                                                  .steps[index]
                                                                  .ingredientQuantityObjects[
                                                              indexItem]
                                                                  .ingredient
                                                                  .ingredientAd!
                                                                  .id);
                                                        }
                                                      });
                                                    } else {
                                                      _stopTimer();
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                height / 95,
                                                            horizontal: 16),
                                                    child: Row(children: [
                                                      IngredientImage(
                                                          ingredientId:
                                                              imageID),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      if (contentLanguageCode ==
                                                          'ar') ...[
                                                        Text(
                                                    '${recipe.steps[index].ingredientQuantityObjects[indexItem].ingredient.name} ${recipe.steps[index].ingredientQuantityObjects[indexItem].ingredient.ingredientAd!= null? ' ${recipe.steps[index].ingredientQuantityObjects[indexItem].ingredient.ingredientAd!.brandName}' : ''}',
                                                    style:  TextStyle(
                                                                  fontSize: 17.sp),
                                                        ),
                                                  const SizedBox(width: 5),
                                                                                                Text(
                                                      "$quantity ${translateUnit(recipe.steps[index].ingredientQuantityObjects[indexItem].unit, contentLanguageCode)}",
                                                      textDirection: TextDirection.rtl,
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                          FontWeight.w600)),
                                                      ] else ...[
                                                  Text(
                                                      "$quantity ${translateUnit(recipe.steps[index].ingredientQuantityObjects[indexItem].unit, contentLanguageCode)}",
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                          FontWeight.w600)),
                                                  const SizedBox(width: 5),
                                                        Text(
                                                          '${recipe.steps[index].ingredientQuantityObjects[indexItem].ingredient.name} ${recipe.steps[index].ingredientQuantityObjects[indexItem].ingredient.ingredientAd != null ? ' ${recipe.steps[index].ingredientQuantityObjects[indexItem].ingredient.ingredientAd!.brandName}' : ''}',
                                                          style:
                                                          TextStyle(fontSize: 17.sp),
                                                        ),
                                                      ],
                                                      const Spacer(),
                                                      ////select ingredient checkbox to not delete
                                                      // CustomCheckBox(
                                                      //   size: 25,
                                                      //   raduisBorder: 6,
                                                      //   isSelected:
                                                      //       selectedIngredientsList[
                                                      //           index],
                                                      //   isChecked: (bool e) {
                                                      //     selectedIngredientsList[
                                                      //         index] = e;

                                                      //     if (selectedIngredientsList
                                                      //             .where((element) =>
                                                      //                 element == true)
                                                      //             .length ==
                                                      //         selectedIngredientsList
                                                      //             .length) {
                                                      //       setServingState(() {
                                                      //         selectAll = true;
                                                      //       });
                                                      //     }
                                                      //     if (!e) {
                                                      //       selectAll = false;
                                                      //       setServingState(() {});
                                                      //     }

                                                      //     // setServingState(() {
                                                      //     //  allBoxesAreSelected = false;
                                                      //     //});
                                                      //   },
                                                      // )
                                                    ]),
                                                  ),
                                                );
                                              });
                                        },
                                      ),

                                      ////add to groceries button gorceryList feature
                                      // const SizedBox(height: 15),
                                      // Center(
                                      //   child: ElevatedButton(
                                      //       style: ElevatedButton.styleFrom(
                                      //         shape: RoundedRectangleBorder(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(8)),
                                      //         primary: primary,
                                      //         textStyle:
                                      //             const TextStyle(fontSize: 15),
                                      //         padding: const EdgeInsets.symmetric(
                                      //             vertical: 7, horizontal: 25),
                                      //       ),
                                      //       onPressed: () {
                                      //         const snackBar = SnackBar(
                                      //           behavior:
                                      //               SnackBarBehavior.floating,
                                      //           margin: EdgeInsets.all(5),
                                      //           backgroundColor:
                                      //               Color(0XFFFA6375),
                                      //           content: Text(
                                      //             'Ingredients added to grocerie list',
                                      //             style: TextStyle(fontSize: 15),
                                      //             textAlign: TextAlign.center,
                                      //           ),
                                      //         );
                                      //         ScaffoldMessenger.of(context)
                                      //             .showSnackBar(snackBar);
                                      //       },
                                      //       child:
                                      //           const Text("Add to groceries")),
                                      // ),
                                    ],
                                  );
                                })),

                                /////////////////// ingredients
                                const SizedBox(height: 15),
                                const SizedBox(height: 15),
                                Padding(
                                  padding: titlePadding,
                                  child: Text(
                                    'Nutritive Facts'.tr(context),
                                    style: titleingsteps,
                                  ),
                                ),

                                const SizedBox(height: 10),
                                //nutritive fact
                                NutritiveFactsContainer(
                                    nutritivefactvalues: nutritivefactvalues),
                                const SizedBox(height: 25),
                                Padding(
                                  padding: titlePadding,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Directions'.tr(context),
                                        style: titleingsteps,
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            backgroundColor: primary,
                                          textStyle: TextStyle(fontSize: 15.sp),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                          ),
                                          onPressed: () {
                                            if (viewedIngredientAdIds
                                                .isNotEmpty) {
                                              incrementIngredientAdViewCount(
                                                  viewedIngredientAdIds);
                                              viewedIngredientAdIds.clear();
                                            }
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        StepByStep(
                                                          recipe: recipe,
                                                        )),(route) => true);
                                          },
                                          child: Text(
                                              "Step by step mode".tr(context))),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),

                                const SizedBox(height: 15),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: recipe.steps.length,
                                    itemBuilder: (context, index) => Steps(
                                        number: index + 1,
                                        description: recipe.steps[index].instruction))
                              ],

                              ///
                            ));
                      } else if (snapshot.hasError) {
                        return Column(
                          children: [
                            SizedBox(height: height / 6),
                            Center(
                                child: CustomErrorWidget(
                                    onRefresh: reloadData,
                                    messgae: "error_text".tr(context)))
                          ],
                        );
                      } else {
                        return Text('Error'.tr(context));
                      }
                    }
                  }))),
    );
  }
}
