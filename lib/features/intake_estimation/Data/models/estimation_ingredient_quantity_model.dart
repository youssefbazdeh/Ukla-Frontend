import '../../Domain/entities/estimation_ingredient_quantity.dart';

class EstimationIngredientQuantityModel extends EstimationIngredientQuantity {
  EstimationIngredientQuantityModel({
    super.id,
    super.imageID,
    super.quantity,
  });

  factory EstimationIngredientQuantityModel.fromJson(
          Map<String, dynamic> json) =>
      EstimationIngredientQuantityModel(
        id: json["id"],
        imageID: json["image"]["id"],
        quantity: json["quantity"],
      );
}
