import '../entities/estimation_recipe.dart';
import '../repositories/intake_estimation_repository.dart';

class AddEstimationRecipe {
  final IntakeEstimationRepository repository;
  AddEstimationRecipe({required this.repository});

  Future<bool> call(
      {required EstimationRecipe estimationRecipe,
      required int estimationMealId}) async {
    return await repository.addEstimationRecipe(
        estimationRecipe, estimationMealId);
  }
}
