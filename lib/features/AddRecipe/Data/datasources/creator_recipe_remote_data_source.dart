import 'dart:convert';

import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/domain/api_Service.dart';
import 'package:ukla_app/features/AddRecipe/Data/models/creator_recipe_model.dart';
import 'package:ukla_app/features/AddRecipe/Domain/Entities/creator_recipe.dart';
import 'package:ukla_app/injection_container.dart';

abstract class CreatorRecipeRemoteDataSource {
  Future<List<CreatorRecipe>> getCreatorRecipesByCreator();
  Future<bool> deleteCreatorRecipeById(int creatorRecipeId);
  Future<CreatorRecipe> updateCreatorRecipeById(int creatorRecipeId,String title,String description,int videoId);
  Future<CreatorRecipe> addCreatorRecipe(String title,String description,int videoId);
}

class CreatorRecipeRemoteDataSourceImpl implements CreatorRecipeRemoteDataSource {
  HttpService client = sl<HttpService>();

  CreatorRecipeRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CreatorRecipe>> getCreatorRecipesByCreator() async {
    try {
      final response = await client.get('${AppString.SERVER_IP}/ukla/CreatorRecipe/getAllByCreatorUsername');
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<CreatorRecipeModel> recipes = jsonResponse.map((json) => CreatorRecipeModel.fromJson(json)).toList();
        return recipes;
      } else if (response.statusCode == 204) {
        return List.empty();
      }else {
        throw ServerExceptionForCreatorRecipe(response.statusCode, "ServerError");
      }
    } catch (e) {
      throw ServerExceptionForCreatorRecipe(500, "Server Error");
    }
  }

  @override
  Future<bool> deleteCreatorRecipeById(int creatorRecipeId) async {
    try{
      final response = await client.delete('${AppString.SERVER_IP}/ukla/CreatorRecipe/delete/$creatorRecipeId');
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    }catch (e) {
      return false;
    }

  }

  @override
  Future<CreatorRecipe> updateCreatorRecipeById(int creatorRecipeId,String title,String description,int videoId) async {
    Uri uri = Uri.parse("${AppString.SERVER_IP}/ukla/CreatorRecipe/update/$creatorRecipeId").replace(queryParameters: {
      'title': title,
      'description': description,
      'videoId': videoId.toString(),
    });
    var result = await HttpService().put(uri.toString(), "");
    if(result.statusCode == 200){
      Map<String,dynamic> json = jsonDecode(result.body);
      return CreatorRecipeModel.fromJson(json);
    }else{
      throw Exception('Failed to update recipe');
    }
  }

  @override
  Future<CreatorRecipe> addCreatorRecipe(String title, String description, int videoId) async {
    Uri uri = Uri.parse("${AppString.SERVER_IP}/ukla/CreatorRecipe/add").replace(queryParameters: {
      'title': title,
      'description': description,
      'videoId': videoId.toString(),
    });
    var result = await HttpService().post(uri.toString(),"");
    if(result.statusCode == 201){
      Map<String,dynamic> json = jsonDecode(result.body);
      return CreatorRecipeModel.fromJson(json);
    }else{
      throw Exception('Failed to create recipe: ${result.body}');
    }
  }
}

class ServerExceptionForCreatorRecipe implements Exception {
  final int statusCode;
  final String message;

  ServerExceptionForCreatorRecipe(this.statusCode, this.message);

  @override
  String toString() => 'ServerException: $message (Status code: $statusCode)';
}
