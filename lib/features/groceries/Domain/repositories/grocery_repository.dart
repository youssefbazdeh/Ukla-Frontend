import 'package:ukla_app/features/groceries/Domain/Entities/grocery_list.dart';

abstract class GroceryRepository {
  Future<GroceryList> getGroceryList(String languageCode);
  Future<bool> purchaseGroceryListIngredient(List<int> ingredientIDS);
  Future<bool> unpurchaseGroceryListIngredient(List<int> ingredientIDS);
  Future<bool> deleteGroceryListIngredient(List<int> ingredientIDS);
}