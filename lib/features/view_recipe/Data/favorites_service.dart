import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/domain/api_Service.dart';
import '../Domain/Entities/recipe.dart';

class FavoritesServices {
  static Future<String> addRecipeToFavorites(int recipeId) async {
    String? url = '${AppString.SERVER_IP}/ukla/Favoris/add/$recipeId';
    var res = await HttpService().put(url,"");
    return res.body;
  }

  static Future<String> removeRecipeFromFavorites(int recipeId) async {
    String? url = '${AppString.SERVER_IP}/ukla/Favoris/delete/$recipeId';
    var res = await HttpService().delete(url);
    return res.body;
  }

  static Future<List<Recipe>> getAllFavorites(int offset, int limit) async {
    String? url = '${AppString.SERVER_IP}/ukla/Recipe/getAllFavoriteRecipe/$offset/$limit';
    var res = await HttpService().get(url);
    List<Recipe> recipes = recipelistFromJson(res.body);
    return recipes;
  }

}