import 'package:ukla_app/features/AddRecipe/Domain/Entities/creator_recipe.dart';
import 'package:ukla_app/features/AddRecipe/Domain/repositories/creator_recipe_repository.dart';

class UpdateCreatorRecipe {
  final CreatorRecipeRepository repository;
  UpdateCreatorRecipe({required this.repository});
  Future<CreatorRecipe> call(int creatorRecipeId,String title,String description,int videoId)async{
    return await repository.updateCreaotRecipeById(creatorRecipeId, title, description, videoId);
  }
}