import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_recipe.dart';

class EstimationMeal {
  EstimationMeal({
    this.id,
    this.name,
    this.filled,
    this.estimationRecipe,
  });

  int? id;
  String? name;
  bool? filled;
  List<EstimationRecipe>? estimationRecipe;
}
