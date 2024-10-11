import 'grocery_day.dart';
import 'grocery_ingredient.dart';

class GroceryList{
  GroceryList({
    this.id,
    this.groceryDays,
    this.userAddedIngredientQuantityObjects
  });
  int? id;
  List<GroceryDay>? groceryDays;
  List<GroceryIngredient>? userAddedIngredientQuantityObjects;
}