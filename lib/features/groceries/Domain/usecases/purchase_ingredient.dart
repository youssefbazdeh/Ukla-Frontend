import '../repositories/grocery_repository.dart';

class PurchaseGroceriesListIngredient {
  final GroceryRepository groceryRepository;
  PurchaseGroceriesListIngredient({required this.groceryRepository});

  Future<bool> call(List<int> ingredientIDS) async {
    return await groceryRepository.purchaseGroceryListIngredient(ingredientIDS);
  }
}
