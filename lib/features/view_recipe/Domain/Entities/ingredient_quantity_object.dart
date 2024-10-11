import 'package:ukla_app/features/view_recipe/Domain/Entities/ingredient.dart';

class IngredientQuantityObject {
  IngredientQuantityObject({
    required this.ingredient,
    required this.quantity,
    required this.unit,
  });

  Ingredient ingredient;
  double quantity;
  String unit;

  factory IngredientQuantityObject.fromJson(Map<String, dynamic> json) =>
      IngredientQuantityObject(
        ingredient: Ingredient.fromJson(json["ingredient"]),
        quantity: json["quantity"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "ingredient": ingredient.toJson(),
        "quantity": quantity,
        "unit": unit,
      };
}
