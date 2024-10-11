import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/domain/api_service.dart';
import '../../view_recipe/Domain/Entities/recipe.dart';
import '../../view_recipe/Domain/Entities/tag.dart';

class ServicesRecipes {
  static Future<String> addRecipeToMeal(int mealId, int recipeId) async {
    String? url = '${AppString.SERVER_IP}/ukla/Recipe/addRecipeToMeal/$mealId/$recipeId';
    var res = await HttpService().post(url,"");
    return res.body;
  }

  static Future<int> deleteRecipeFromMeal(int mealId, int recipeId) async {
    String? url = '${AppString.SERVER_IP}/ukla/Recipe/deleteRecipeFromMeal/$mealId/$recipeId';
    var res = await HttpService().delete(url);
    return (res.statusCode);
  }

  static Future<List<Recipe>> getAll(int offset, int limit) async {
    String? url = '${AppString.SERVER_IP}/ukla/Recipe/retrieveAll/$offset/$limit';
    List<Recipe> recipes = [];
    var res =await HttpService().get(url);
    if (res.statusCode == 200) {
      recipes = recipelistFromJson(res.body);
    }
    return recipes;
  }

  static Future<List<Recipe>> getOnlyVerifiedOrAcceptedRecipes(int offset, int limit) async {
    String? url = '${AppString.SERVER_IP}/ukla/Recipe/retrieveOnlyAcceptedOrVerifiedRecipes/$offset/$limit';
    List<Recipe> recipes = [];
    var res =await HttpService().get(url);
    if (res.statusCode == 200) {
      recipes = recipelistFromJson(res.body);
    }
    return recipes;
  }

  static Future<List<Recipe>> retrieveRecipeByTagAndTime(int time, Set<Tag> tags) async {
    List<String> tagIds = tags.map((tag) => tag.id.toString()).toList();
    String queryParams = 'time=$time&tagIds=${tagIds.join(',')}';
    String? url = "${AppString.SERVER_IP}/ukla/Recipe/findByTimeAndTags?$queryParams";
    List<Recipe> recipes = [];
    var res = await HttpService().get(url);
    if (res.statusCode == 200) {
      recipes = recipelistFromJson(res.body);
    }
    return recipes;
  }

}