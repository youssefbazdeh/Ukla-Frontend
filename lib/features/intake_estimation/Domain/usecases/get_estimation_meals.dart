import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_meal.dart';
import 'package:ukla_app/features/intake_estimation/Domain/repositories/intake_estimation_repository.dart';

class GetEstimationMeals {
  final IntakeEstimationRepository repository;
  GetEstimationMeals({required this.repository});

  Future<List<EstimationMeal>> call() async {
    return await repository.getEstimationMeals();
  }
}
