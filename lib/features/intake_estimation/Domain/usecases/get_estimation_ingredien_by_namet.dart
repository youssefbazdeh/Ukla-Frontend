import '../entities/estimation_ingredient.dart';
import '../repositories/intake_estimation_repository.dart';

class GetEstimationIngredientsByName {
  final IntakeEstimationRepository repository;
  GetEstimationIngredientsByName({required this.repository});

  Future<List<EstimationIngredient>> call(
      {required String estimationIngredientName}) async {
    return await repository
        .getEstimationIngredientByName(estimationIngredientName);
  }
}
