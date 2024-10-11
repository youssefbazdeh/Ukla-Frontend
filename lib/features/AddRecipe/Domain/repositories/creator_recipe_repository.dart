import 'package:ukla_app/features/AddRecipe/Domain/Entities/creator_recipe.dart';

abstract class CreatorRecipeRepository {
  Future<List<CreatorRecipe>> getCreatorRecipeListByCreator();
  Future<bool> deleteCreatorRecipeById(int creatorRecipeId);
  Future<CreatorRecipe> updateCreaotRecipeById(int creatorRecipeId,String title,String description,int videoId);
  Future<CreatorRecipe> addCreaotRecipe(String title,String description,int videoId);
}