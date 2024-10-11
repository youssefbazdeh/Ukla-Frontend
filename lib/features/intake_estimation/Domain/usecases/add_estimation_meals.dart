import 'package:dartz/dartz.dart';
import 'package:ukla_app/core/error/failures.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_meal.dart';
import 'package:ukla_app/features/intake_estimation/Domain/repositories/intake_estimation_repository.dart';

class AddEstimationMeals {
  final IntakeEstimationRepository repository;
  AddEstimationMeals({required this.repository});

  Future<Either<Failure, List<EstimationMeal>>> call(
      {required List<EstimationMeal> estimationMeals}) async {
    return await repository.addEstimationMeals(estimationMeals);
  }
}
