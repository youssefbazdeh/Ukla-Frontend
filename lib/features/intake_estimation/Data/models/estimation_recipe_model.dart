import '../../Domain/entities/estimation_recipe.dart';

class EstimationRecipeModel extends EstimationRecipe {
  EstimationRecipeModel({
    super.id,
    super.name,
    super.frequency,
    super.estimationIngredientQuantities,
  });

  factory EstimationRecipeModel.fromJson(Map<String, dynamic> json) =>
      EstimationRecipeModel(
        id: json["id"],
        name: json["name"]!,
        frequency: json["frequency"]!,
        estimationIngredientQuantities: json["estimationIngredientQuantities"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "frequency": frequency,
      };
}
