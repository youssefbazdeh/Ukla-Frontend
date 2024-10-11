class EstimationIngredient {
  EstimationIngredient({
    this.id,
    this.name,
    this.unit,
    this.ingredientImageID,
    this.quantity,
    this.estimationIngredientQuantities,
  });

  int? id;
  String? name;
  String? unit;
  int? ingredientImageID;
  String? quantity;
  List<dynamic>? estimationIngredientQuantities;
}
