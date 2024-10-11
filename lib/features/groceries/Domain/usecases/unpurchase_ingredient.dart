import '../repositories/grocery_repository.dart';

class UnpurchaseGroceriesListIngredient {
  final GroceryRepository groceryRepository;
  UnpurchaseGroceriesListIngredient({required this.groceryRepository});

  Future<bool> call(List<int> ingredientIDS) async {
    return await groceryRepository.unpurchaseGroceryListIngredient(ingredientIDS);
  }
}
