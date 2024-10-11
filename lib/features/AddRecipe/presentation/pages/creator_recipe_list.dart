import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/components/custom_circular_progress_indicator.dart';
import 'package:ukla_app/core/Presentation/components/custom_error_widget.dart';
import 'package:ukla_app/core/Presentation/components/snack_bar.dart';
import 'package:ukla_app/features/AddRecipe/Domain/Entities/creator_recipe.dart';
import 'package:ukla_app/features/AddRecipe/presentation/bloc/creator_recipe_bloc.dart';
import 'package:ukla_app/features/AddRecipe/presentation/bloc/creator_recipe_event.dart';
import 'package:ukla_app/features/AddRecipe/presentation/bloc/creator_recipe_state.dart';
import 'package:ukla_app/features/AddRecipe/presentation/pages/add_recipe.dart';
import 'package:ukla_app/features/AddRecipe/presentation/widgets/item_creator_recipe_list.dart';

class CreatorRecipeList extends StatefulWidget {
  const CreatorRecipeList({super.key});

  @override
  State<CreatorRecipeList> createState() => _CreatorRecipeListState();
}

class _CreatorRecipeListState extends State<CreatorRecipeList> {

  @override
  void initState() {
    _loadRecipes();
    super.initState();
  }

  void _loadRecipes() {
    context.read<CreatorRecipeBloc>().add(LoadCreatorRecipe());
  }

  void _deleteRecipe(CreatorRecipe recipe) {
    context.read<CreatorRecipeBloc>().add(DeleteCreatorRecipeEvent(recipe.id));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text("My recipes".tr(context),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    BlocConsumer<CreatorRecipeBloc, CreatorRecipeState>(
                      listener: (context, state) {
                        if (state is UpdateCreatorRecipeState) {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            var snackbar = CustomSnackBar(
                                message: "Recipe".tr(context)+" "+
                                    state.updateCreatorRecipeTitle+" "+
                                    "updated successfully".tr(context));
                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          });
                        }
                        if (state is AddCreatorRecipeState) {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            var snackbar = CustomSnackBar(
                                message: "Recipe" .tr(context)+" "+
                                    state.addedCreatorRecipeTitle+" "+
                                    "added successfully".tr(context));
                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          });
                        }
                        if (state is UndoDeleteCreatorRecipeState) {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            var snackbar = CustomSnackBar(
                                message: "Failed to delete"
                                    .tr(context) +
                                    state.creatorRecipeTitle);
                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          });
                        }
                        if (state is DeleteCreatorRecipeState) {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            var snackbar = CustomSnackBar(
                                message: "Recipe".tr(context) +
                                    " " +
                                    state.creatorRecipeTitle +
                                    " " +
                                    "deleted successfully".tr(context));
                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          });
                        }
                      },
                      builder: (context, state) {
                        if (state is CreatorRecipeLoading) {
                          return const Center(
                              child: CustomCircularProgressIndicator());
                        } else if (state is CreatorRecipeLoaded ||
                            state is DeleteCreatorRecipeState ||
                            state is UndoDeleteCreatorRecipeState ||
                            state is AddCreatorRecipeState ||
                            state is UpdateCreatorRecipeState ||
                            state is AddCreatorRecipeState) {
                          return _buildRecipeList(
                              (state as dynamic).list, height, context);
                        } else if (state is CreatorRecipeError) {
                          return Center(
                            child: CustomErrorWidget(
                              onRefresh: _loadRecipes,
                              messgae: "error_text".tr(context),
                            ),
                          );
                        } else {
                          return Container(); // Return an empty container if no state matches
                        }
                      },
                    ),
                    const SizedBox(height: 23),
                  ],
                ),
                Positioned(
                  bottom: height / 25,
                  right: width / 5,
                  left: width / 5,
                  child: SizedBox(
                    height: 45,
                    width: width / 1.8,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFFFA6375),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddRecipePage()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Create recipe".tr(context),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(Ionicons.add_circle, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }

  Widget _buildRecipeList(
      List<CreatorRecipe> recipes, double height, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Created recipes".tr(context),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "${recipes.length}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        "recipes".tr(context),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (recipes.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: SizedBox(
                  height: height * 0.6,
                  child: ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return ItemCreatorRecipeList(
                        recipe: recipe,
                        onDelete: () => _deleteRecipe(recipe),
                      );
                    },
                  ),
                ),
              ),
            ] else ...[
              SizedBox(height: height / 20),
              Center(
                  child: Text(
                      "No recipes found yet, add one...".tr(context)))
            ]
          ],
        ),
      ),
    );
  }
}
