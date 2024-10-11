import 'package:ukla_app/core/error/exceptions.dart';
import 'package:ukla_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_ingredient.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_ingredient_quantity.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_meal.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_recipe.dart';

import 'package:ukla_app/features/intake_estimation/Domain/repositories/intake_estimation_repository.dart';

import '../datasources/intake_estimation_remote_data_source.dart';

class IntakeEstimationRepositoryImpl implements IntakeEstimationRepository {
  final IntakeEstimationRemoteDataSource remoteDataSource;

  IntakeEstimationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<EstimationMeal>>> addEstimationMeals(
      List<EstimationMeal> estimationMeals) async {
    try {
      //final remoteEstimationMeals = await
      remoteDataSource.addEstimationMeal(estimationMeals);

      List<EstimationMeal> recievedEstimationMeals = [];
      EstimationMeal recievedEstimationMeal = EstimationMeal();

      /*for (var remoteEstimationMeal in remoteEstimationMeals) {
        recievedEstimationMeal.id = remoteEstimationMeal.id;
        recievedEstimationMeal.name = remoteEstimationMeal.name;
        recievedEstimationMeal.filled = remoteEstimationMeal.filled;
        recievedEstimationMeal.estimationRecipe =
            remoteEstimationMeal.estimationRecipe;
        recievedEstimationMeals.add(recievedEstimationMeal);
      }*/

      return Right(recievedEstimationMeals);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<List<EstimationMeal>> getEstimationMeals() async {
    // try {
    final remoteEstimationMeals = await remoteDataSource.getEstimationMeals();
    List<EstimationMeal> recievedEstimationMeals = [];

    for (var remoteEstimationMeal in remoteEstimationMeals) {
      EstimationMeal recievedEstimationMeal = EstimationMeal();
      recievedEstimationMeal.id = remoteEstimationMeal.id;
      recievedEstimationMeal.name = remoteEstimationMeal.name;
      recievedEstimationMeal.filled = remoteEstimationMeal.filled;
      recievedEstimationMeal.estimationRecipe =
          remoteEstimationMeal.estimationRecipe;

      recievedEstimationMeals.add(recievedEstimationMeal);
    }
    return recievedEstimationMeals;
    /*} catch (e) {
      throw ServerFailure();
    }*/
  }

  @override
  Future<bool> addEstimationRecipe(
      EstimationRecipe estimationRecipe, int estimationMealId) async {
    return await remoteDataSource.addEstimationRecipe(
        estimationRecipe, estimationMealId);
  }

  @override
  Future<List<EstimationIngredient>> getEstimationIngredient() async {
    try {
      final remoteEstimationIngredients =
          await remoteDataSource.getEstimationIngredient();
      List<EstimationIngredient> recievedEstimationIngredients = [];

      for (var remoteEstimationIngredient in remoteEstimationIngredients) {
        EstimationIngredient recievedEstimationIngredient =
            EstimationIngredient();
        recievedEstimationIngredient.id = remoteEstimationIngredient.id;
        recievedEstimationIngredient.name = remoteEstimationIngredient.name;
        recievedEstimationIngredient.unit = remoteEstimationIngredient.unit;
        recievedEstimationIngredient.ingredientImageID =
            remoteEstimationIngredient.ingredientImageID;
        recievedEstimationIngredient.estimationIngredientQuantities =
            remoteEstimationIngredient.estimationIngredientQuantities;

        recievedEstimationIngredients.add(recievedEstimationIngredient);
      }
      return recievedEstimationIngredients;
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<List<EstimationIngredientQuantity>> getEstimationIngredientQuantities(
      int estimationIngredientId) async {
    try {
      final remoteEstimationIngredientQuantites = await remoteDataSource
          .getEstimationIngredientQuantities(estimationIngredientId);
      List<EstimationIngredientQuantity> recievedEstimationIngredientQuantites =
          [];

      for (var remoteEstimationIngredientQuantity
          in remoteEstimationIngredientQuantites) {
        EstimationIngredientQuantity recievedEstimationIngredientQuantity =
            EstimationIngredientQuantity();
        recievedEstimationIngredientQuantity.id =
            remoteEstimationIngredientQuantity.id;
        recievedEstimationIngredientQuantity.imageID =
            remoteEstimationIngredientQuantity.imageID;
        recievedEstimationIngredientQuantity.quantity =
            remoteEstimationIngredientQuantity.quantity;

        recievedEstimationIngredientQuantites
            .add(recievedEstimationIngredientQuantity);
      }
      return recievedEstimationIngredientQuantites;
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<bool> addListOfEstimationIngredientQuantitiesToEstimatonRecipe(
      int estimationRecipeId,
      List<int> estimationIngredientQuantitiesIds) async {
    return await remoteDataSource
        .addListOfEstimationIngredientQuantitiesToEstimatonRecipe(
            estimationRecipeId, estimationIngredientQuantitiesIds);
  }

  @override
  Future<EstimationMeal> getEstimationMeal(int estimationMealId) async {
    return await remoteDataSource.getEstimationMeal(estimationMealId);
  }

  @override
  Future<List<EstimationIngredient>> getEstimationIngredientByName(
      String estimationIngredientName) async {
    try {
      final remoteEstimationIngredients = await remoteDataSource
          .getEstimationIngredientByName(estimationIngredientName);
      List<EstimationIngredient> recievedEstimationIngredients = [];

      for (var remoteEstimationIngredient in remoteEstimationIngredients) {
        EstimationIngredient recievedEstimationIngredient =
            EstimationIngredient();
        recievedEstimationIngredient.id = remoteEstimationIngredient.id;
        recievedEstimationIngredient.name = remoteEstimationIngredient.name;
        recievedEstimationIngredient.unit = remoteEstimationIngredient.unit;
        recievedEstimationIngredient.ingredientImageID =
            remoteEstimationIngredient.ingredientImageID;
        recievedEstimationIngredient.estimationIngredientQuantities =
            remoteEstimationIngredient.estimationIngredientQuantities;

        recievedEstimationIngredients.add(recievedEstimationIngredient);
      }
      return recievedEstimationIngredients;
    } catch (e) {
      throw ServerFailure();
    }
  }
}
