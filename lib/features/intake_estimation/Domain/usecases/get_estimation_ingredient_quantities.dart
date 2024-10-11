import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_ingredient_quantity.dart';

import '../repositories/intake_estimation_repository.dart';

class GetEstimationIngredientQuantities {
  final IntakeEstimationRepository repository;
  GetEstimationIngredientQuantities({required this.repository});

  Future<List<EstimationIngredientQuantity>> call(
      {required int estimationIngredientId}) async {
    return await repository
        .getEstimationIngredientQuantities(estimationIngredientId);
  }
}
