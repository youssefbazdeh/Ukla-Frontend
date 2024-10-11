class EstimationRecipe {
  EstimationRecipe({
    this.id,
    this.name,
    this.frequency,
    this.estimationIngredientQuantities,
  });

  int? id;
  String? name;
  int? frequency;
  List<dynamic>? estimationIngredientQuantities;
}
