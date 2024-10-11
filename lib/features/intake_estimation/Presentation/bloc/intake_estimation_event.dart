part of 'intake_estimation_bloc.dart';

abstract class IntakeEstimationEvent extends Equatable {
  const IntakeEstimationEvent();

  @override
  List<Object> get props => [];
}

class AddEstimationMealsEvent extends IntakeEstimationEvent {
  final List<EstimationMeal> estimationMeals;
  const AddEstimationMealsEvent(this.estimationMeals);
}

class GetEstimationMealsEvent extends IntakeEstimationEvent {
  const GetEstimationMealsEvent();
}

class AddEstimationRecipeEvent extends IntakeEstimationEvent {
  final EstimationRecipe estimationRecipe;
  final int estimationMealId;
  const AddEstimationRecipeEvent(this.estimationRecipe, this.estimationMealId);
}

class GetEstimationIngredientsEvent extends IntakeEstimationEvent {
  const GetEstimationIngredientsEvent();
}

class GetEstimationIngredientQuantitiesEvent extends IntakeEstimationEvent {
  final int estimationIngredientId;
  const GetEstimationIngredientQuantitiesEvent(this.estimationIngredientId);
}

class AddListOfEstimationIngredientQuantitiesToEstimatonRecipeEvent
    extends IntakeEstimationEvent {
  final int estimationRecipeId;
  final List<int> estimationIngredientQuantitiesIds;
  const AddListOfEstimationIngredientQuantitiesToEstimatonRecipeEvent(
      this.estimationRecipeId, this.estimationIngredientQuantitiesIds);
}

class GetEstimationMealEvent extends IntakeEstimationEvent {
  final int estimationMealId;
  const GetEstimationMealEvent(this.estimationMealId);
}

class SearchEstimationIngredientsEvent extends IntakeEstimationEvent {
  final String estimationIngredientName;
  const SearchEstimationIngredientsEvent(this.estimationIngredientName);
}
