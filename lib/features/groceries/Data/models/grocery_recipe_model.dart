import 'package:ukla_app/features/groceries/Data/models/grocery_ingredient_model.dart';
import 'package:ukla_app/features/groceries/Domain/Entities/grocery_recipe.dart';

class GroceryRecipeModel extends GroceryRecipe {

  GroceryRecipeModel(
      {super.recipeName,
       super.recipeImageID,
       super.groceryIngredientQuantityObjects,
       super.id,});

  factory GroceryRecipeModel.fromJson(Map<String, dynamic> json) => GroceryRecipeModel(
      recipeName: json["name"],
      recipeImageID: json["image"]["id"],
    groceryIngredientQuantityObjects: (json["groceryIngredientQuantityObjects"] as List)
        .map((ingredient) => GroceryIngredientModel.fromJson(ingredient as Map<String, dynamic>))
        .toList(),
    id:json["id"],
  );
}
