import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_meal.dart';
import 'package:ukla_app/features/intake_estimation/Domain/repositories/intake_estimation_repository.dart';

class GetEstimationMeal {
  final IntakeEstimationRepository repository;
  GetEstimationMeal({required this.repository});

  Future<EstimationMeal> call({required int estimationMealId}) async {
    return await repository.getEstimationMeal(estimationMealId);
  }
}
