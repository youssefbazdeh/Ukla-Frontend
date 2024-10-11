import 'grocery_ingredient.dart';

class GroceryRecipe{
  GroceryRecipe({
    this.id,
    this.recipeName,
    this.recipeImageID,
    this.groceryIngredientQuantityObjects
  });
  int? id;
  String? recipeName;
  int? recipeImageID;
  List<GroceryIngredient>? groceryIngredientQuantityObjects;
}