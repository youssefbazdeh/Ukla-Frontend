import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:ukla_app/features/intake_estimation/Data/models/estimation_recipe_model.dart';
import '../../Domain/entities/estimation_meal.dart';
import '../../Domain/entities/estimation_recipe.dart';
import '../models/estimation_ingredient_model.dart';
import '../models/estimation_ingredient_quantity_model.dart';
import '../models/estimation_meal_model.dart';

abstract class IntakeEstimationRemoteDataSource {
  //Future<List<EstimationMealModel>>
  void addEstimationMeal(List<EstimationMeal> estimationMeals);
  Future<List<EstimationMealModel>> getEstimationMeals();
  Future<bool> addEstimationRecipe(
      EstimationRecipe estimationRecipe, int estimatioMealId);
  Future<List<EstimationIngredientModel>> getEstimationIngredient();
  Future<List<EstimationIngredientQuantityModel>>
      getEstimationIngredientQuantities(int estimationIngredientId);
  Future<bool> addListOfEstimationIngredientQuantitiesToEstimatonRecipe(
      int estimationRecipeId, List<int> estimationIngredientQuantitiesIds);
  Future<EstimationMealModel> getEstimationMeal(int estimationMealId);

  Future<List<EstimationIngredientModel>> getEstimationIngredientByName(
      String estimationIngredientName);
}

class IntakeEstimationRemoteDataSourceImpl
    implements IntakeEstimationRemoteDataSource {
  final storage = const FlutterSecureStorage();
  final http.Client client;

  IntakeEstimationRemoteDataSourceImpl({required this.client});
  var serverIp = AppString.SERVER_IP;

  @override
  //Future<List<EstimationMealModel>>
  void addEstimationMeal(List<EstimationMeal> estimationMeals) async {
    List<EstimationMealModel> estimationMealModels = [];
    List<Map<String, dynamic>> jsonEncodedList = [];

    for (var estimationMeal in estimationMeals) {
      EstimationMealModel estimationMealModel = EstimationMealModel();
      estimationMealModel.name = estimationMeal.name;
      estimationMealModel.filled = estimationMeal.filled;
      estimationMealModels.add(estimationMealModel);
    }

    for (var item in estimationMealModels) {
      jsonEncodedList.add(item.toJson());
    }

    final response = await client.post(
        Uri.parse('${AppString.SERVER_IP}/ukla/EstimationMeal/add'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${await storage.read(key: "jwt")}',
        },
        body: jsonEncode(jsonEncodedList));

    if (response.statusCode == 200) {
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<EstimationMealModel>> getEstimationMeals() async {
    final response = await client.get(
      Uri.parse('${AppString.SERVER_IP}/ukla/EstimationMeal/All'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${await storage.read(key: "jwt")}',
      },
    );

    if (response.statusCode == 200) {
      List<EstimationMealModel> returnedList = [];

      for (var item in json.decode(response.body)) {
        EstimationMealModel estimationMealModel = EstimationMealModel();
        List<EstimationRecipe>? estimationRecipeList = [];

        estimationMealModel.id = item["id"];
        estimationMealModel.name = item["name"];
        estimationMealModel.filled = item["filled"];
        for (var estimationRecipe in item["estimationRecipes"]) {
          estimationRecipeList
              .add(EstimationRecipeModel.fromJson(estimationRecipe));
        }
        estimationMealModel.estimationRecipe = estimationRecipeList;
        returnedList.add(estimationMealModel);
      }
      return returnedList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> addEstimationRecipe(
      EstimationRecipe estimationRecipe, int estimationMealId) async {
    EstimationRecipeModel estimationRecipeModel = EstimationRecipeModel();
    estimationRecipeModel.name = estimationRecipe.name;
    estimationRecipeModel.frequency = estimationRecipe.frequency;

    final response = await client.post(
        Uri.parse(
            '${AppString.SERVER_IP}/ukla/EstimationRecipe/add/$estimationMealId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${await storage.read(key: "jwt")}',
        },
        body: jsonEncode(estimationRecipeModel.toJson()));

    if (response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<EstimationIngredientModel>> getEstimationIngredient() async {
    final response = await client.get(
      Uri.parse('${AppString.SERVER_IP}/ukla/EstimationIngredient/All'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${await storage.read(key: "jwt")}',
      },
    );

    if (response.statusCode == 200) {
      List<EstimationIngredientModel> returnedList = [];

      for (var item in json.decode(response.body)) {
        returnedList.add(EstimationIngredientModel.fromJson(item));
      }
      return returnedList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<EstimationIngredientQuantityModel>>
      getEstimationIngredientQuantities(int estimationIngredientId) async {
    final response = await client.get(
      Uri.parse(
          '${AppString.SERVER_IP}/ukla/EstimationIngredientQuantity/All?idEstimationIngredient=$estimationIngredientId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${await storage.read(key: "jwt")}',
      },
    );

    if (response.statusCode == 200) {
      List<EstimationIngredientQuantityModel> returnedList = [];

      for (var item in json.decode(response.body)) {
        returnedList.add(EstimationIngredientQuantityModel.fromJson(item));
      }
      return returnedList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> addListOfEstimationIngredientQuantitiesToEstimatonRecipe(
      int estimationRecipeId,
      List<int> estimationIngredientQuantitiesIds) async {
    final response = await client.put(
        Uri.parse(
            '${AppString.SERVER_IP}/ukla/EstimationRecipe/addQuantity/$estimationRecipeId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${await storage.read(key: "jwt")}',
        },
        body: jsonEncode(estimationIngredientQuantitiesIds));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<EstimationMealModel> getEstimationMeal(int estimationMealId) async {
    final response = await client.get(
      Uri.parse(
          '${AppString.SERVER_IP}/ukla/EstimationMeal/get/$estimationMealId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${await storage.read(key: "jwt")}',
      },
    );

    if (response.statusCode == 200) {
      EstimationMealModel estimationMealModel = EstimationMealModel();
      List<EstimationRecipe>? estimationRecipeList = [];

      estimationMealModel.id = json.decode(response.body)["id"];
      estimationMealModel.name = json.decode(response.body)["name"];
      estimationMealModel.filled = json.decode(response.body)["filled"];
      for (var estimationRecipe
          in json.decode(response.body)["estimationRecipes"]) {
        estimationRecipeList
            .add(EstimationRecipeModel.fromJson(estimationRecipe));
      }
      estimationMealModel.estimationRecipe = estimationRecipeList;
      return estimationMealModel;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<EstimationIngredientModel>> getEstimationIngredientByName(
      String estimationIngredientName) async {
    final response = await client.get(
      Uri.parse(
          '${AppString.SERVER_IP}/ukla/EstimationIngredient/search/$estimationIngredientName'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${await storage.read(key: "jwt")}',
      },
    );

    if (response.statusCode == 200) {
      List<EstimationIngredientModel> returnedList = [];

      for (var item in json.decode(response.body)) {
        returnedList.add(EstimationIngredientModel.fromJson(item));
      }
      return returnedList;
    } else {
      throw ServerException();
    }
  }
}
