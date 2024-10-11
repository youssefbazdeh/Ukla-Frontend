import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/domain/api_Service.dart';
import '../Domain/Entities/recipe.dart';

Future<Recipe> getRecipeByName(String recipeName) async {
  String? url = '${AppString.SERVER_IP}/ukla/Recipe/retrieveByName/$recipeName';
  var res = await HttpService().get(url);
  Recipe recipe = recipeFromJson(res.body);
  if (res.statusCode == 200) {
    return recipe;
  } else {
    throw Exception("unable to load recipe");
  }
}

Future<Recipe> getRecipeById(int recipeId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? contentLanguageCode =  prefs.getString('contentLanguageCode');
  String? url = '${AppString.SERVER_IP}/ukla/Recipe/getByIdAndLanguageCode/$recipeId/$contentLanguageCode';
  var res = await HttpService().get(url);
  Recipe recipe = recipeFromJson(res.body);
  if (res.statusCode == 200) {
    return recipe;
  } else {
    throw Exception("unable to load recipe");
  }
}

Future<Recipe> getRecipeByIdWithAd(int recipeId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? countryCode = prefs.getString('country_code');
  String? url = '${AppString.SERVER_IP}/ukla/Recipe/getById/$recipeId/$countryCode';
  var res = await HttpService().get(url);
  Recipe recipe = recipeFromJson(res.body);
  if (res.statusCode == 200) {
    return recipe;
  } else {
    throw Exception("unable to load recipe");
  }
}