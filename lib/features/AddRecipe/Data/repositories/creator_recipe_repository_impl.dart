import 'package:ukla_app/features/AddRecipe/Data/datasources/creator_recipe_remote_data_source.dart';
import 'package:ukla_app/features/AddRecipe/Domain/Entities/creator_recipe.dart';
import 'package:ukla_app/features/AddRecipe/Domain/repositories/creator_recipe_repository.dart';

class CreatorRecipeRepositoryImpl implements CreatorRecipeRepository {
  final CreatorRecipeRemoteDataSource remoteDataSource;

  CreatorRecipeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CreatorRecipe>> getCreatorRecipeListByCreator() async {
    final List<CreatorRecipe> list = await remoteDataSource.getCreatorRecipesByCreator();
    return list;
  }

  @override
  Future<bool> deleteCreatorRecipeById(int creatorRecipeId) async {
    return await remoteDataSource.deleteCreatorRecipeById(creatorRecipeId);
  }

  @override
  Future<CreatorRecipe> updateCreaotRecipeById(int creatorRecipeId, String title, String description, int videoId) async {
    return await remoteDataSource.updateCreatorRecipeById(creatorRecipeId, title, description, videoId);
  }

  @override
  Future<CreatorRecipe> addCreaotRecipe(String title, String description, int videoId) async {
    return await remoteDataSource.addCreatorRecipe(title, description, videoId);
  }
}
