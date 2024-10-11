import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ukla_app/features/intake_estimation/Domain/usecases/add_estimation_recipe.dart';
import 'package:ukla_app/features/intake_estimation/Domain/usecases/get_estimation_meal.dart';
import '../../Domain/entities/estimation_ingredient.dart';
import '../../Domain/entities/estimation_meal.dart';
import '../../Domain/entities/estimation_recipe.dart';
import '../../Domain/usecases/add_estimation_meals.dart';
import '../../Domain/usecases/add_list_estimation_ingredient_quantities_to_estimaton_recipe.dart';
import '../../Domain/usecases/get_estimation_ingredien_by_namet.dart';
import '../../Domain/usecases/get_estimation_ingredient_quantities.dart';
import '../../Domain/usecases/get_estimation_ingredients.dart';
import '../../Domain/usecases/get_estimation_meals.dart';

part 'intake_estimation_event.dart';
part 'intake_estimation_state.dart';

class IntakeEstimationBloc
    extends Bloc<IntakeEstimationEvent, IntakeEstimationState> {
  final AddEstimationMeals addEstimationMeals;
  final GetEstimationMeals getEstimationMeals;
  final AddEstimationRecipe addEstimationRecipe;
  final GetEstimationIngredients getEstimationIngredients;
  final GetEstimationIngredientQuantities getEstimationIngredientsQuantites;
  final AddListOfEstimationIngredientQuantitiesToEstimatonRecipe
      addListOfEstimationIngredientQuantitiesToEstimatonRecipe;
  final GetEstimationMeal getEstimationMeal;
  final GetEstimationIngredientsByName getEstimationIngredientsByName;

  IntakeEstimationBloc({
    required this.addEstimationMeals,
    required this.getEstimationMeals,
    required this.addEstimationRecipe,
    required this.getEstimationIngredients,
    required this.getEstimationIngredientsQuantites,
    required this.addListOfEstimationIngredientQuantitiesToEstimatonRecipe,
    required this.getEstimationMeal,
    required this.getEstimationIngredientsByName,
  }) : super(EstimationMealEmpty()) {
    on<IntakeEstimationEvent>((event, emit) async {
      if (event is AddEstimationMealsEvent) {
        emit(Loading());
        final estimationMealOrFailure =
            await addEstimationMeals(estimationMeals: event.estimationMeals);
        emit(estimationMealOrFailure.fold(
            (failure) => const Error(message: "adding infos error"),
            (estimationMeals) =>
                EstimationMealsLoaded(estimationMeals: estimationMeals)));
      } else if (event is GetEstimationMealsEvent) {
        emit(Loading());
        final estimationMeals = await getEstimationMeals();
        /*emit(estimationMealOrFailure.fold(
            (failure) => const Error(message: "adding infos error"),
            (estimationMeals) => const EstimationMealsLoaded()));*/
        emit(EstimationMealsLoaded(estimationMeals: estimationMeals));
      } else if (event is AddEstimationRecipeEvent) {
        emit(Loading());
        final response = await addEstimationRecipe(
            estimationRecipe: event.estimationRecipe,
            estimationMealId: event.estimationMealId);
        response
            ? emit(const EstimationRecipeAdded())
            : emit(const Error(message: "error in adding estimation recipe"));
      } else if (event is GetEstimationIngredientsEvent) {
        emit(Loading());
        List<EstimationIngredient> estimationIngredients =
            await getEstimationIngredients();
        emit(EstimationIngredientsLoaded(estimationIngredients));
      } else if (event is GetEstimationIngredientQuantitiesEvent) {
        emit(Loading());
        await getEstimationIngredientsQuantites(
            estimationIngredientId: event.estimationIngredientId);
        emit(const EstimationIngredientsQuantitiesLoaded());
      } else if (event
          is AddListOfEstimationIngredientQuantitiesToEstimatonRecipeEvent) {
        emit(Loading());
        await addListOfEstimationIngredientQuantitiesToEstimatonRecipe(
            estimationRecipeId: event.estimationRecipeId,
            estimationIngredientQuantitiesIds:
                event.estimationIngredientQuantitiesIds);
        emit(const EstimationIngredientsQuantitiesAddedToEstimationRecipe());
      } else if (event is GetEstimationMealEvent) {
        emit(Loading());
        EstimationMeal estimationMeal =
            await getEstimationMeal(estimationMealId: event.estimationMealId);
        emit(EstimationMealLoaded(estimationMeal));
      } else if (event is SearchEstimationIngredientsEvent) {
        emit(Loading());

        List<EstimationIngredient> estimationIngredients =
            await getEstimationIngredientsByName(
                estimationIngredientName: event.estimationIngredientName);
        emit(EstimationIngredientsLoaded(estimationIngredients));
      }
    });
  }
}
