import 'package:flutter/material.dart';
import 'package:ukla_app/features/view_recipe/Presentation/one_recipe_interface.dart';


void showRecipe(BuildContext context, String recipeName, int? recipeId) async {
  Future.delayed(const Duration(milliseconds: 500), () {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OneRecipeInterface(id: recipeId)));
  });
}


