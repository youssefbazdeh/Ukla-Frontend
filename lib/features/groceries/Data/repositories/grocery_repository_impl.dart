import 'package:ukla_app/features/groceries/Data/datasources/grocery_remote_data_source.dart';
import 'package:ukla_app/features/groceries/Domain/Entities/grocery_list.dart';
import 'package:ukla_app/features/groceries/Domain/repositories/grocery_repository.dart';

class GroceryRepositoryImpl implements GroceryRepository {
  final GroceryRemoteDataSource remoteDataSource;

  GroceryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GroceryList> getGroceryList(String languageCode) async {
    final GroceryList remoteGroceryList = await remoteDataSource.getGroceryList(languageCode);
    GroceryList receivedGroceryList = GroceryList(
      id: remoteGroceryList.id,
      groceryDays: remoteGroceryList.groceryDays,
      userAddedIngredientQuantityObjects: remoteGroceryList.userAddedIngredientQuantityObjects,
    );
    return receivedGroceryList;
  }

  @override
  Future<bool> deleteGroceryListIngredient(List<int> ingredientIDS) {
    return remoteDataSource.deleteGroceryListIngredient(ingredientIDS);
  }


  @override
  Future<bool> purchaseGroceryListIngredient(List<int> ingredientIDS) {
    return remoteDataSource.purchaseGroceryListIngredient(ingredientIDS);
  }

  @override
  Future<bool> unpurchaseGroceryListIngredient(List<int> ingredientIDS) {
    return remoteDataSource.unpurchaseGroceryListIngredient(ingredientIDS);
  }
}
