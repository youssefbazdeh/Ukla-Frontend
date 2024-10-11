import '../entities/estimation_ingredient.dart';
import '../repositories/intake_estimation_repository.dart';

class GetEstimationIngredients {
  final IntakeEstimationRepository repository;
  GetEstimationIngredients({required this.repository});

  Future<List<EstimationIngredient>> call() async {
    return await repository.getEstimationIngredient();
  }
}
