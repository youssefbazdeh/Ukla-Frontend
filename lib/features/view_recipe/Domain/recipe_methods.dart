import 'package:ukla_app/features/view_recipe/Domain/Entities/nutritive_fact.dart';

import 'Entities/ingredient_quantity_object.dart';
import 'Entities/recipe.dart';

///calcul des calories per person
int caloriesCalculator(List<IngredientQuantityObject> ingredients) {
  double sum = 0.0;
  for (int i = 0; i < ingredients.length; i++) {
    sum += ((ingredients[i].quantity) *
            ingredients[i].ingredient.nbrCalories100Gr!) /
        800;
  }
  return sum.truncate();
}

/// nutritice facts
Map<String, NutritiveFact> nutritiveFactsValues(Recipe recipe) {
  double totalGramsInRecipe = recipe.fat + recipe.protein + recipe.carbs + recipe.sugar + recipe.fiber;
  double percentageCarbs;
  double percentageProteins = 0;
  double percentageFiber = 0;
  double percentageSugar = 0;
  double percentageFat = 0;

  percentageFat = (recipe.fat / totalGramsInRecipe) * 100;
  percentageProteins = (recipe.protein / totalGramsInRecipe) * 100;
  percentageCarbs = (recipe.carbs / totalGramsInRecipe) * 100;
  percentageSugar = (recipe.sugar / totalGramsInRecipe) * 100;
  percentageFiber = (recipe.fiber / totalGramsInRecipe) * 100;

  return {
    "Carbs": NutritiveFact(
        quantity: recipe.carbs.toInt(), pourcentage: percentageCarbs.toInt()),
    "Sugar": NutritiveFact(
        quantity: recipe.sugar.toInt(), pourcentage: percentageSugar.toInt()),
    "Fiber": NutritiveFact(
        quantity: recipe.fiber.toInt(), pourcentage: percentageFiber.toInt()),
    "Proteins": NutritiveFact(
        quantity: recipe.protein.toInt(), pourcentage: percentageProteins.toInt()),
    "Fat": NutritiveFact(
        quantity: recipe.fat.toInt(), pourcentage: percentageFat.toInt()),
    "Calories":
        NutritiveFact(quantity: recipe.nbrCalories.toInt())
  };
}
