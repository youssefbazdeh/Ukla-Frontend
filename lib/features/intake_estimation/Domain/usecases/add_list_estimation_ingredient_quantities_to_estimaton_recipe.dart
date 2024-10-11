import '../repositories/intake_estimation_repository.dart';

class AddListOfEstimationIngredientQuantitiesToEstimatonRecipe {
  final IntakeEstimationRepository repository;
  AddListOfEstimationIngredientQuantitiesToEstimatonRecipe(
      {required this.repository});

  Future<bool> call(
      {required int estimationRecipeId,
      required List<int> estimationIngredientQuantitiesIds}) async {
    return await repository
        .addListOfEstimationIngredientQuantitiesToEstimatonRecipe(
            estimationRecipeId, estimationIngredientQuantitiesIds);
  }
}
