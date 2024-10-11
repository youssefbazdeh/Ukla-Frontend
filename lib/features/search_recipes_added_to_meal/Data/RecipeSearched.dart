import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/domain/api_Service.dart';

import '../../../main.dart';
import 'package:http/http.dart' as http;


import '../../../core/domain/entities/image.dart';
import '../../view_recipe/Domain/Entities/recipe.dart';

class SerchedRecepiesApi {
  static Future<List<Recipe>> getRecipesfromquery(String query) async {
    String? url = '${AppString.SERVER_IP}/ukla/Recipe/searchRecipeByQuery?query=$query';
    List<Recipe> recipesSearched = [];
    var res = await HttpService().get(url);
    if (res.statusCode == 200 || res.statusCode == 201) {
      recipesSearched = recipelistFromJson(res.body);
    }
    return recipesSearched;
  }

  static Future<List<Recipe>> searchRecipefromfavorites(String query) async {
    String? url = '${AppString.SERVER_IP}/ukla/Recipe/searchRecipefromfavorites?query=$query';
    List<Recipe> recipesSearched = [];
    var res = await HttpService().get(url);
    if (res.statusCode == 200 || res.statusCode == 201) {
      recipesSearched = recipelistFromJson(res.body);
    }
    return recipesSearched;
  }

  static Future<Recipe> getRecipeByName1(String recipeName) async {
    var response = await http.get(
        Uri.parse(
            '${AppString.SERVER_IP}/ukla/Recipe/retrieveByName/$recipeName'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        });
    Recipe recipe = recipeFromJson(response.body);
    if (response.statusCode == 200) {
      return recipe;
    } else {
      throw Exception("unable to load recipe");
    }
  }

  static Future<Image> getRecipeImage(int recipeId) async {
    var response = await http.get(
        Uri.parse(
            '${AppString.SERVER_IP}/ukla/file-system/image/1'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${await storage.read(key: "jwt")}',
        });
    Image image = response.body as Image;
    if (response.statusCode == 200) {
      return image;
    } else {
      throw Exception("unable to load image");
    }
  }
}