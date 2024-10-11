import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/tabBar/tab_card.dart';
import 'package:ukla_app/core/analytics/events.dart';
import 'package:ukla_app/features/search_recipes_added_to_meal/Data/RecipeSearched.dart';
import 'package:ukla_app/features/search_recipes_added_to_meal/Presentation/pages/recipe_from_data_base.dart';
import 'package:ukla_app/features/search_recipes_added_to_meal/Presentation/widgets/searchbar.dart';
import 'package:ukla_app/main.dart';
import '../../../view_recipe/Domain/Entities/recipe.dart';

class AddRecipeToMeal extends StatefulWidget {
  const AddRecipeToMeal({Key? key}) : super(key: key);

  @override
  State<AddRecipeToMeal> createState() => _AddRecipeToMealState();


}

class _AddRecipeToMealState extends State<AddRecipeToMeal> with AutomaticKeepAliveClientMixin {
  String query = "";
  List<Recipe> recipes = [];
  List<Recipe> recipesPagination = [];
  List<Recipe> favRecipePagination = [];
  List<Recipe> filtredRecipes = [];
  late SelectedReceipe selectedRecipeProvider;
  Timer? _debounce;
  final Duration _debounceDuration = const Duration(milliseconds:  500);


  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    _debounce?.cancel();
    filtredRecipes.clear();
    super.dispose();
  }


  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    filtredRecipes = Provider.of<FiltredRecipeProvider>(context).recipes;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: const Color(0XFFFDFDFD),

          title: SearchBarWidget(
              controller: controller,
              text: query,
              hintText: "Search_recipe".tr(context),
              onChanged: searchRecipe),
        ),
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            body: SingleChildScrollView(
              // clipBehavior: Clip.none,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 45),
                    child: SizedBox(
                      height: 40,
                      child: TabBar(
                          dividerColor: Colors.white,
                          indicator: BoxDecoration(
                              color: const Color(0XFFFA6375),
                              borderRadius: BorderRadius.circular(10)),
                          automaticIndicatorColorAdjustment: false,
                          isScrollable: true,
                          splashBorderRadius: BorderRadius.circular(20),
                          labelColor: const Color(0XFFFDFDFD),
                          unselectedLabelColor:
                          const Color.fromARGB(255, 0, 0, 0),
                          onTap: (value) {
                            Provider.of<indexSarchedRecipes>(context, listen: false).setIndex(value);
                            searchRecipe(Provider.of<indexSarchedRecipes>(context, listen: false).getQuery());
                            Provider.of<FiltredRecipeProvider>(context, listen: false).clearRecipes();
                          },
                          tabs: [
                            TabCard(title: "explore".tr(context)),
                            TabCard(title: "favorites".tr(context)),
                          ]),
                    ),
                  ),
                      if(filtredRecipes.isNotEmpty) ... [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: TabBarView(
                            children: [
                                RecipeFromDB(recipes: filtredRecipes, favorites: false),
                                RecipeFromDB(recipes: filtredRecipes, favorites: true),
                            ],
                          ),
                        ),
                      ]else ... [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: TabBarView(
                            children: [
                              if (query != "") ... [
                                RecipeFromDB(recipes: recipes, favorites: false),
                                RecipeFromDB(recipes: recipes, favorites: true)

                              ]else ... [
                                RecipeFromDB(recipes: recipesPagination, favorites: false),
                                RecipeFromDB(recipes: favRecipePagination, favorites: true)

                              ]

                            ],
                          ),
                        ),
                      ]
                    ]
              ),
            ),
          ),
        ));
  }

  Future searchRecipe(String query) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () async {
      if (!mounted) return;
      filtredRecipes.clear();
      Provider.of<indexSarchedRecipes>(context, listen: false).setQuery(query);
      List<Recipe> searchedReceipes = [];
      int index = Provider.of<indexSarchedRecipes>(context, listen: false).getIndex();
      switch (index) {
        case  0:
          {
            FireBaseAnalyticsEvents.searchedQuery(query);
            searchedReceipes = await SerchedRecepiesApi.getRecipesfromquery(query);
            break;
          }
        case  1:
          {
            FireBaseAnalyticsEvents.searchedQuery(query);
            searchedReceipes = await SerchedRecepiesApi.searchRecipefromfavorites(query);
            break;
          }
        case  2:
          {
            FireBaseAnalyticsEvents.searchedQuery(query);
            searchedReceipes =  await SerchedRecepiesApi.getRecipesfromquery(query);
            break;
          }
      }

      if (!mounted) return;
      setState(() {
        this.query = query;
        recipes = searchedReceipes;
      });
    });
  }

  @override
  bool get wantKeepAlive => false;
}