import 'package:ukla_app/features/AddRecipe/Domain/repositories/creator_recipe_repository.dart';

class DeleteCreatorRecipe{
  final CreatorRecipeRepository repository;
  DeleteCreatorRecipe({required this.repository});

  Future<bool> call(int id) async {
    return await repository.deleteCreatorRecipeById(id);
  }
}