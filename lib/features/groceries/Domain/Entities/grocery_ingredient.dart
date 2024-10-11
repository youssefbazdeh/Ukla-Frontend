class GroceryIngredient {
  GroceryIngredient(
  { this.ingredientId,
    this.ingredientImageID,
    this.ingredientName,
    this.purchased,
    this.quantity,
    this.unit,
    this.type,
    this.brandName,
    this.ingredientAdImageId,
    this.ingredientAdId});

  int? ingredientId;
  int? ingredientImageID;
  String? ingredientName;
  bool? purchased;
  double? quantity;
  String? unit;
  String? type;
  String? brandName;
  int? ingredientAdImageId;
  int? ingredientAdId;
}