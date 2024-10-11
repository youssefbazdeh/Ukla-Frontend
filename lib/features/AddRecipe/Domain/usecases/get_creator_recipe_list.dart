import 'package:ukla_app/features/AddRecipe/Domain/Entities/creator_recipe.dart';
import 'package:ukla_app/features/AddRecipe/Domain/repositories/creator_recipe_repository.dart';

class GetCreatorRecipeList{
  final CreatorRecipeRepository repository;
  GetCreatorRecipeList({required this.repository});

  Future<List<CreatorRecipe>> call() async {
    return await repository.getCreatorRecipeListByCreator();
  }

}