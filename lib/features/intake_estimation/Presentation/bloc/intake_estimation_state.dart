part of 'intake_estimation_bloc.dart';

abstract class IntakeEstimationState extends Equatable {
  const IntakeEstimationState();

  @override
  List<Object> get props => [];
}

class EstimationMealEmpty extends IntakeEstimationState {}

class Loading extends IntakeEstimationState {}

class EstimationMealsLoaded extends IntakeEstimationState {
  final List<EstimationMeal> estimationMeals;
  const EstimationMealsLoaded({required this.estimationMeals}) : super();
}

class EstimationMealLoaded extends IntakeEstimationState {
  final EstimationMeal estimationMeal;
  const EstimationMealLoaded(this.estimationMeal) : super();
}

class EstimationRecipeAdded extends IntakeEstimationState {
  const EstimationRecipeAdded() : super();
}

class EstimationIngredientsLoaded extends IntakeEstimationState {
  final List<EstimationIngredient> estimationIngredients;
  const EstimationIngredientsLoaded(this.estimationIngredients) : super();
}

class EstimationIngredientsQuantitiesLoaded extends IntakeEstimationState {
  const EstimationIngredientsQuantitiesLoaded() : super();
}

class EstimationIngredientsQuantitiesAddedToEstimationRecipe
    extends IntakeEstimationState {
  const EstimationIngredientsQuantitiesAddedToEstimationRecipe() : super();
}

class Error extends IntakeEstimationState {
  final String message;
  const Error({required this.message}) : super();
}
