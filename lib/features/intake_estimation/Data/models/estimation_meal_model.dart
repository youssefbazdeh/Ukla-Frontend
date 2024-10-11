import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_meal.dart';

class EstimationMealModel extends EstimationMeal {
  EstimationMealModel({
    super.id,
    super.name,
    super.filled,
    super.estimationRecipe,
  });

  factory EstimationMealModel.fromJson(Map<String, dynamic> json) =>
      EstimationMealModel(
        id: json["id"],
        name: json["name"]!,
        filled: json["filled"]!,
        estimationRecipe: json["estimationRecipes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "filled": filled,
      };
}
