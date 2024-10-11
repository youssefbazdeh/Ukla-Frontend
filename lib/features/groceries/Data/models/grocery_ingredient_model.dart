import 'package:ukla_app/features/groceries/Domain/Entities/grocery_ingredient.dart';

class GroceryIngredientModel extends GroceryIngredient {
  GroceryIngredientModel(
      {super.ingredientId,
       super.ingredientImageID,
       super.ingredientName,
       super.purchased,
       super.quantity,
       super.unit,
       super.type,
        super.ingredientAdImageId,
        super.brandName,
        super.ingredientAdId});

  factory GroceryIngredientModel.fromJson(Map<String, dynamic> json) =>
      GroceryIngredientModel(
          ingredientId: json["id"],
          ingredientImageID: json["ingredientQuantityObject"]["ingredient"]
              ["image"]["id"],
          ingredientName: json["ingredientQuantityObject"]["ingredient"]
              ["name"],
          purchased: json["purchased"],
          quantity: json["ingredientQuantityObject"]["quantity"],
          unit: json["ingredientQuantityObject"]["unit"],
          type: json["ingredientQuantityObject"]["ingredient"]["type"],
          ingredientAdImageId : json["ingredientQuantityObject"]["ingredient"]["ingredientAd"]!= null
              ? json["ingredientQuantityObject"]["ingredient"]["ingredientAd"]["image"]["id"]
              : null,
          brandName : json["ingredientQuantityObject"]["ingredient"]["ingredientAd"]!= null
          ? json["ingredientQuantityObject"]["ingredient"]["ingredientAd"]["brandName"]
          : null,
          ingredientAdId: json["ingredientQuantityObject"]["ingredient"]["ingredientAd"]!= null
              ? json["ingredientQuantityObject"]["ingredient"]["ingredientAd"]["id"]
              : null,
      );
}
