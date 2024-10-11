import '../../Domain/entities/estimation_ingredient.dart';

class EstimationIngredientModel extends EstimationIngredient {
  EstimationIngredientModel({
    super.id,
    super.name,
    super.unit,
    super.ingredientImageID,
    super.quantity,
    super.estimationIngredientQuantities,
  });

  factory EstimationIngredientModel.fromJson(Map<String, dynamic> json) =>
      EstimationIngredientModel(
        id: json["id"],
        name: json["name"],
        unit: json["unit"],
        ingredientImageID: json["image"]["id"],
        estimationIngredientQuantities: json["estimationIngredientQuantities"],
      );
}
