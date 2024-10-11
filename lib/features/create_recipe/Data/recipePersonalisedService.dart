import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/models/recipe_personalised.dart';


class RecipePersonalisedService {
  static Future<int> recipeAdd() async {
    IngredientQuantityObject ingredientQuantityObject =
         IngredientQuantityObject(
            ingredient: Ingredient(
                name: "tmatem", nbrCalories100Gr: 100, type: "AUTRE"),
            quantity: "100",
            unit: "g");

    Speciality speciality =  Speciality(name: "Tunisienne");

    Step step =  Step(instruction: "qss", tip: "");

    RecipePersonnalised recipePersonnalized = RecipePersonnalised(
        recipeSeparations: ["LUNCH", "BREAKFAST"],
        name: "sdssd",
        description: "descr",
        preparationTime: 1,
        cookingTime: 5,
        toAvoid: "salt",
        toRecommend: "water",
        type: "NOURRITURE",
        speciality: speciality,
        ingredientQuantityObjects: [ingredientQuantityObject],
        steps: [step]);

    Dio dio = Dio();
    dio.options.headers = {
      //'Accept': 'application/json',
      //'Content-Type': 'multipart/form-data',
    };


    var formData =
        FormData.fromMap({'personalisedDto': jsonEncode(recipePersonnalized)});

    var response = await dio.post(
        '${AppString.SERVER_IP}/ukla/RecipePersonnalised/add',
        data: formData);


    return response.statusCode!;


  }
}
