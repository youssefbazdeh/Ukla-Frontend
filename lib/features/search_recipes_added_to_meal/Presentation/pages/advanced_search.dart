  import 'dart:convert';
  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:ukla_app/features/search_recipes_added_to_meal/Data/recipes_services.dart';
  import 'package:ukla_app/features/search_recipes_added_to_meal/Data/tag_services.dart';
  import 'package:ukla_app/features/view_recipe/Domain/Entities/recipe.dart';
import 'package:ukla_app/main.dart';
  import '../../../Preferences/Presentation/widgets/cardofadvancedSearch.dart';
  import '../../../plan_Management/Presentation/pages/add_recipe_to_meal.dart';
  import '../../../view_recipe/Domain/Entities/tag.dart';
import '../../../view_recipe/Presentation/Widgets/tags_builder.dart';

  class AdvancedSearch extends StatefulWidget {
    const AdvancedSearch({Key? key}) : super(key: key);

    @override
    State<AdvancedSearch> createState() => _AdvancedSearchState();
  }

  class _AdvancedSearchState extends State<AdvancedSearch> with AutomaticKeepAliveClientMixin<AdvancedSearch>{

    double _currentSliderValue = 00;
    Set<Tag> selectedTags = {};
    List<Tag> tags = [];
    List<Recipe> recipesByTimeAndTags = [];

    @override
    void initState() {
      fetchTagsFromLocalStorage();
      super.initState();
    }

    @override
    bool get wantKeepAlive => true;

    @override
    Widget build(BuildContext context) {
      super.build(context);
      return WillPopScope(child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Meal",
                        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                          await fetchRecipesByTagsAndTime(_currentSliderValue.toInt(), selectedTags);
                          Provider.of<FiltredRecipeProvider>(context, listen: false).setRecipes(recipesByTimeAndTags);
                          Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddRecipeToMeal(),
                              ),
                          );

                      },
                      icon: const Icon(Icons.check),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        runSpacing: 8.0,
                        children: List.generate(
                          tags.length,
                              (index) {
                            var item = tags[index];
                            return IntrinsicWidth(
                              child: AdvancedSearchedCard(
                                cardTitle: translateTagTitle(item.title!,Provider.of<SelectedContentLanguage>(context,listen: false).contentLanguageCode),
                                onTagSelected: (isSelected) => onCardSelected(isSelected, item),
                                isSelected: selectedTags.contains(item),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                       Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Time",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        inactiveColor: const Color(0XFFE8E8E8),
                        activeColor: const Color(0XFFFA6375),
                        value: _currentSliderValue,
                        min: 0,
                        max: 100,
                        divisions: 5,
                        label: _currentSliderValue.round().toString(),
                        onChanged: (double value) async {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
          onWillPop: () async {
            Navigator.pop(context);
            return false;
        }
      );
    }

    void onCardSelected(bool isSelected, Tag tag) {
      setState(() {
        if (isSelected) {
          selectedTags.add(tag);
        } else {
          selectedTags.remove(tag);
        }
      });

    }

    Future<void> fetchTagsFromLocalStorage() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedTags = prefs.getString('tags');
      int? lastUpdateTimestamp = prefs.getInt('tagsTimestamp');

      if (storedTags != null && lastUpdateTimestamp != null) {
        List<dynamic> decodedTags = jsonDecode(storedTags);
        List<Tag> storedTagsList = decodedTags.map((tag) => Tag.fromJson(tag)).toList();

        if (DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(lastUpdateTimestamp)).inMinutes < 30) {
          setState(() {
            tags = storedTagsList;
          });
        } else {
          await fetchTagsFromServer();
        }
      } else {
        await fetchTagsFromServer();
      }
    }

    Future<void> fetchTagsFromServer() async {
      List<Tag> fetchedTags = await TagService.getAllTags();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        tags = fetchedTags;
      });

      List<Map<String, dynamic>> tagList = fetchedTags.map((tag) => tag.toJson()).toList();
      prefs.setString('tags', jsonEncode(tagList));
      prefs.setInt('tagsTimestamp', DateTime.now().millisecondsSinceEpoch);
    }

    Future<void> fetchRecipesByTagsAndTime(int cookingTime, Set<Tag> tags) async {
      List<Recipe> fetchedRecipes = await ServicesRecipes.retrieveRecipeByTagAndTime(cookingTime, tags);
      setState(() {
        recipesByTimeAndTags = fetchedRecipes;
      });
  }

  }
