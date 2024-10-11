import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/domain/api_Service.dart';
import 'package:ukla_app/features/groceries/Data/models/grocery_day_model.dart';
import 'package:ukla_app/features/groceries/Data/models/grocery_ingredient_model.dart';
import 'package:ukla_app/features/groceries/Data/models/grocery_list_model.dart';
import '../../Domain/Entities/grocery_list.dart';

abstract class GroceryRemoteDataSource {
  Future<GroceryList> getGroceryList(String languageCode);
  Future<bool> purchaseGroceryListIngredient(List<int> ingredientIDS);
  Future<bool> unpurchaseGroceryListIngredient(List<int> ingredientIDS);
  Future<bool> deleteGroceryListIngredient(List<int> ingredientIDS);
}

class GroceryListRemoteDataSourceImpl implements GroceryRemoteDataSource {
  final HttpService client;

  GroceryListRemoteDataSourceImpl({required this.client});

  @override
  Future<GroceryList> getGroceryList(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? countryCode = prefs.getString('country_code');
    try {
      final response = await client.get('${AppString.SERVER_IP}/ukla/grocery-list/$languageCode/$countryCode');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        GroceryListModel groceryListModel = GroceryListModel(
          id: jsonResponse["id"],
          groceryDays: (jsonResponse["groceryDays"] as List?)?.map((day) => GroceryDayModel.fromJson(day)).toList()?? [],
          userAddedIngredientQuantityObjects: (jsonResponse["userAddedIngredientQuantityObjects"] as List?)?.map((ingredient) => GroceryIngredientModel.fromJson(ingredient)).toList()?? [],
        );
        GroceryList groceryList = GroceryList(
          id: groceryListModel.id,
          groceryDays: groceryListModel.groceryDays,
          userAddedIngredientQuantityObjects: groceryListModel.userAddedIngredientQuantityObjects,
        );
        return groceryList;
      } else {
        throw ServerExceptionForGroceryList(response.statusCode, response.body);
      }
    } catch (e) {
        throw ServerExceptionForGroceryList(500, "Server Error");
    }
  }
  @override
  Future<bool> purchaseGroceryListIngredient(List<int> ingredientIDS) async {
    try{
      List<String> ingredients = ingredientIDS.map((id) => id.toString()).toList();
      String url = '${AppString.SERVER_IP}/ukla/grocery-list/purchased/${ingredients.join(',')}';
      final response = await client.put(url, "");
      if(response.statusCode != 200){
        return false;
      }
      return true;
    }catch (e){
      return false;
    }
  }

  @override
  Future<bool> unpurchaseGroceryListIngredient(List<int> ingredientIDS) async {
    try{
      List<String> ingredients = ingredientIDS.map((id) => id.toString()).toList();
      String url = '${AppString.SERVER_IP}/ukla/grocery-list/unpurchase/${ingredients.join(',')}';
      final response = await client.put(url, "");
      if(response.statusCode != 200){
        return false;
      }
      return true;
    }catch(e){
      return false;
    }

  }

  @override
  Future<bool> deleteGroceryListIngredient(List<int> ingredientIDS) async {
    try{
      List<String> ingredients = ingredientIDS.map((id) => id.toString()).toList();
      String url = '${AppString.SERVER_IP}/ukla/grocery-list/delete/${ingredients.join(',')}';
      final response = await client.delete(url);
      if(response.statusCode != 200){
        return false;
      }
      return true;
    }catch(e){
      return false;
    }

  }

}


class ServerExceptionForGroceryList implements Exception {
    final int statusCode;
    final String message;

    ServerExceptionForGroceryList(this.statusCode, this.message);

    @override
    String toString() => 'ServerException: $message (Status code: $statusCode)';
}
