import 'package:ukla_app/features/groceries/Domain/Entities/grocery_list.dart';

class GroceryListModel extends GroceryList {
  GroceryListModel({
    super.id,
    super.groceryDays,
    super.userAddedIngredientQuantityObjects
  });

  factory GroceryListModel.fromJson(Map<String, dynamic> json) =>
      GroceryListModel(
        id: json["id"],
        groceryDays: json["groceryDays"],
        userAddedIngredientQuantityObjects: json["userAddedIngredientQuantityObjects"]
      );
}
