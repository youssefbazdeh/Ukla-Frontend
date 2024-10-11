import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/components/custom_error_widget.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/analytics/events.dart';
import 'package:ukla_app/features/search_recipes_added_to_meal/Presentation/widgets/bottom_sheet.dart';
import 'package:ukla_app/features/search_recipes_added_to_meal/Presentation/widgets/searched_recipe_card.dart';
import 'package:ukla_app/features/view_recipe/Presentation/show_recipe.dart';
import 'package:ukla_app/main.dart';
import '../../../view_recipe/Data/favorites_service.dart';
import '../../../view_recipe/Domain/Entities/recipe.dart';
import '../../../view_recipe/Domain/Entities/tag.dart';
import '../../Data/recipes_services.dart';

class RecipeFromDB extends StatefulWidget {
  const RecipeFromDB({required this.recipes, Key? key, required this.favorites})
      : super(key: key);
  final List<Recipe> recipes;
  final bool favorites;

  @override
  State<RecipeFromDB> createState() => _RecipeFromDBState();
}

class _RecipeFromDBState extends State<RecipeFromDB>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const _pageSize = 4;
  int _page = 1;
  bool hasMore = true;
  int numItems = 0;
  final controller = ScrollController();
  bool loading = true;
  bool showErrorWidget = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset && hasMore) {
        fetch();
      }
    });
    if (widget.recipes.isNotEmpty) {
      loading = false;
    } else {
      fetch();
    }
  }

  Future<void> fetch() async {
    try{
      var localPlanList = widget.favorites
          ? await FavoritesServices.getAllFavorites(_page, _pageSize)
          : await ServicesRecipes.getOnlyVerifiedOrAcceptedRecipes(_page, _pageSize);

      setState(() {
        widget.recipes.addAll(localPlanList);
        loading = false;
        _page++;
      });

      if (localPlanList.length < _pageSize) {
        hasMore = false;
      }
    }catch(e){
      setState(() {
        showErrorWidget = true;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  void loadList() async {
    setState(() {
      _page = 1;
      hasMore = true;
      widget.recipes.clear();
      showErrorWidget = false;
    });
    fetch();
    if (mounted) setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      bottomSheet: null,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0XFFFDFDFD),
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      if(showErrorWidget)...[
                        Column(
                          children: [
                            SizedBox(height: height * 0.03),
                            Center(child: CustomErrorWidget(onRefresh: loadList,messgae: "error_text".tr(context)))
                          ],
                        )
                      ]
                      else if (!loading) ...[
                        SizedBox(
                          width: width / 1.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.recipes.length == 1
                                    ? "${widget.recipes.length} " +
                                        "Recipe".tr(context)
                                    : "${widget.recipes.length} " +
                                        "Recipes".tr(context),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        if (widget.favorites && widget.recipes.isEmpty)
                          Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Center(
                                  child: Text(
                                      "Your have no favorite recipes yet ... "
                                          .tr(context)))),
                        MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: SizedBox(
                            height: height / 1.4,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: widget.recipes.length + 1,
                              controller: controller,
                              itemBuilder: (context, index) {
                                if (widget.recipes.isNotEmpty &&
                                    index < widget.recipes.length) {
                                  bool recipeInSelectedList() {
                                    List<int?> listeIds =
                                        (Provider.of<SelectedReceipe>(context,
                                                    listen: false)
                                                .getRecipelist())
                                            .map((e) => e.id)
                                            .toList();
                                    if (listeIds
                                        .contains(widget.recipes[index].id)) {
                                      return true;
                                    } else {
                                      return false;
                                    }
                                  }

                                  List<Tag> tags = [];
                                  for (var element
                                      in widget.recipes[index].tags) {
                                    tags.add(Tag(title: element.title));
                                  }
                                  return SearchedRecipeCard(
                                      tags: tags,
                                      recipeInList: recipeInSelectedList(),
                                      recipeTitle: widget.recipes[index].name,
                                      onPressed: () {
                                        FireBaseAnalyticsEvents.recipeViewed(widget.recipes[index].name);
                                        FireBaseAnalyticsEvents.screenViewed('recipe_view');
                                        showRecipe(
                                            context,
                                            widget.recipes[index].name,
                                            widget.recipes[index].id!);
                                      },
                                      calories:
                                          (widget.recipes[index].nbrCalories)
                                              .toInt(),
                                      cookingTime:
                                          (widget.recipes[index].cookingTime),
                                      preparationTime:
                                          (widget.recipes[index]
                                                  .preparationTime),
                                      image:
                                          "${AppString.SERVER_IP}/ukla/file-system/image/${widget.recipes[index].image.id}",
                                      selectOrDeselect: (select) {
                                        if (select == true) {
                                          Provider.of<SelectedReceipe>(context,
                                                  listen: false)
                                              .addReceipe(
                                                  widget.recipes[index].id,
                                                  widget.recipes[index]);

                                          _scaffoldKey.currentState
                                              ?.showBottomSheet(
                                                  elevation: 0,
                                                  enableDrag: true,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight: Radius
                                                                .circular(30),
                                                            topLeft:
                                                                Radius.circular(
                                                                    30)),
                                                  ),
                                                  (context) =>
                                                      BottomSheetWidget(
                                                          recipelist: Provider
                                                                  .of<SelectedReceipe>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .getRecipelist(),
                                                          isRemoved: (removed) {
                                                            if (removed ==
                                                                true) {
                                                              Provider.of<testdeleteicon>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .setdeleteicon(
                                                                      true);
                                                              setState(() {});
                                                            }
                                                          }));
                                        } else if (select == false) {
                                          Provider.of<SelectedReceipe>(context,
                                                  listen: false)
                                              .deleteReceipebyId(
                                                  widget.recipes[index].id);
                                          _scaffoldKey.currentState
                                              ?.showBottomSheet(
                                                  elevation: 0,
                                                  enableDrag: true,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight: Radius
                                                                .circular(30),
                                                            topLeft:
                                                                Radius.circular(
                                                                    30)),
                                                  ),
                                                  (context) =>
                                                      BottomSheetWidget(
                                                          recipelist: Provider
                                                                  .of<SelectedReceipe>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .getRecipelist(),
                                                          isRemoved: (removed) {
                                                            if (removed ==
                                                                true) {
                                                              Provider.of<testdeleteicon>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .setdeleteicon(
                                                                      true);
                                                              setState(() {});
                                                            }
                                                          }));
                                        }
                                      });
                                } else {
                                  if (widget.recipes.length < 4) {
                                    return const Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Center(
                                          child: SizedBox(
                                        height: 10,
                                      )),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Center(
                                          child: hasMore
                                              ? const CircularProgressIndicator(
                                                  color:
                                                      AppColors.secondaryColor,
                                                  strokeWidth: 2.0,
                                                )
                                              : const SizedBox(
                                                  height: 10,
                                                )),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        )
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: height / 1.5,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.secondaryColor,
                                strokeWidth: 2.0,
                              ),
                            ),
                          ),
                        )
                      ]
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
