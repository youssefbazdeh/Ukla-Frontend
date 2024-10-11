import '../repositories/grocery_repository.dart';

class DeleteGroceriesListIngredient {
  final GroceryRepository groceryRepository;
  DeleteGroceriesListIngredient({required this.groceryRepository});

  Future<bool> call(List<int> ingredientIDS) async {
    return await groceryRepository.deleteGroceryListIngredient(ingredientIDS);
  }
}
