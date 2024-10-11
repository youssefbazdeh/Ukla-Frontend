import 'package:ukla_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_ingredient.dart';
import '../entities/estimation_ingredient_quantity.dart';
import '../entities/estimation_meal.dart';
import '../entities/estimation_recipe.dart';

abstract class IntakeEstimationRepository {
  Future<Either<Failure, List<EstimationMeal>>> addEstimationMeals(
      List<EstimationMeal> estimationMeals);

  Future<List<EstimationMeal>> getEstimationMeals();

  Future<bool> addEstimationRecipe(
      EstimationRecipe estimationRecipe, int estimationMealId);

  Future<List<EstimationIngredient>> getEstimationIngredient();
  Future<List<EstimationIngredient>> getEstimationIngredientByName(
      String estimationIngredientName);

  Future<List<EstimationIngredientQuantity>> getEstimationIngredientQuantities(
      int estimationIngredientId);
  Future<bool> addListOfEstimationIngredientQuantitiesToEstimatonRecipe(
      int estimationRecipeId, List<int> estimationIngredientQuantitiesIds);

  Future<EstimationMeal> getEstimationMeal(int estimationMealId);
}
