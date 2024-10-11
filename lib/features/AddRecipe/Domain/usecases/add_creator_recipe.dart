import 'package:ukla_app/features/AddRecipe/Domain/Entities/creator_recipe.dart';
import 'package:ukla_app/features/AddRecipe/Domain/repositories/creator_recipe_repository.dart';

class AddCreatorRecipe {
  final CreatorRecipeRepository repository;
  AddCreatorRecipe({required this.repository});
  Future<CreatorRecipe> call(String title, String description, int videoId) async {
    return await repository.addCreaotRecipe(title, description, videoId);
  }
}
