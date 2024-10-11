// To parse this JSON data, do
//
//     final recipePersonnalised = recipePersonnalisedFromJson(jsonString);

import 'dart:convert';

RecipePersonnalised recipePersonnalisedFromJson(String str) => RecipePersonnalised.fromJson(json.decode(str));

String recipePersonnalisedToJson(RecipePersonnalised data) => json.encode(data.toJson());

class RecipePersonnalised {
    RecipePersonnalised({
        required this.recipeSeparations,
        required this.name,
        required this.description,
        required this.preparationTime,
        required this.cookingTime,
        required this.toAvoid,
        required this.toRecommend,
        required this.type,
        required this.speciality,
        required this.ingredientQuantityObjects,
        required this.steps,
    });

    List<String> recipeSeparations;
    String name;
    String description;
    int preparationTime;
    int cookingTime;
    String toAvoid;
    String toRecommend;
    String type;
    Speciality speciality;
    List<IngredientQuantityObject> ingredientQuantityObjects;
    List<Step> steps;

    factory RecipePersonnalised.fromJson(Map<String, dynamic> json) => RecipePersonnalised(
        recipeSeparations: List<String>.from(json["recipeSeparations"].map((x) => x)),
        name: json["name"],
        description: json["description"],
        preparationTime: json["preparationTime"],
        cookingTime: json["cookingTime"],
        toAvoid: json["toAvoid"],
        toRecommend: json["toRecommend"],
        type: json["type"],
        speciality: Speciality.fromJson(json["speciality"]),
        ingredientQuantityObjects: List<IngredientQuantityObject>.from(json["ingredientQuantityObjects"].map((x) => IngredientQuantityObject.fromJson(x))),
        steps: List<Step>.from(json["steps"].map((x) => Step.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "recipeSeparations": List<dynamic>.from(recipeSeparations.map((x) => x)),
        "name": name,
        "description": description,
        "preparationTime": preparationTime,
        "cookingTime": cookingTime,
        "toAvoid": toAvoid,
        "toRecommend": toRecommend,
        "type": type,
        "speciality": speciality.toJson(),
        "ingredientQuantityObjects": List<dynamic>.from(ingredientQuantityObjects.map((x) => x.toJson())),
        "steps": List<dynamic>.from(steps.map((x) => x.toJson())),
    };
}

class IngredientQuantityObject {
    IngredientQuantityObject({
        required this.ingredient,
        required this.quantity,
        required this.unit,
    });

    Ingredient ingredient;
    String quantity;
    String unit;

    factory IngredientQuantityObject.fromJson(Map<String, dynamic> json) => IngredientQuantityObject(
        ingredient: Ingredient.fromJson(json["ingredient"]),
        quantity: json["quantity"],
        unit: json["unit"],
    );

    Map<String, dynamic> toJson() => {
        "ingredient": ingredient.toJson(),
        "quantity": quantity,
        "unit": unit,
    };
}

class Ingredient {
    Ingredient({
        required this.name,
        required this.type,
        required this.nbrCalories100Gr,
    });

    String name;
    String type;
    int nbrCalories100Gr;

    factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        name: json["name"],
        type: json["type"],
        nbrCalories100Gr: json["nbrCalories100gr"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "nbrCalories100gr": nbrCalories100Gr,
    };
}

class Speciality {
    Speciality({
        required this.name,
    });

    String name;

    factory Speciality.fromJson(Map<String, dynamic> json) => Speciality(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}

class Step {
    Step({
        required this.instruction,
        required this.tip,
    });

    String instruction;
    String tip;

    factory Step.fromJson(Map<String, dynamic> json) => Step(
        instruction: json["instruction"],
        tip: json["tip"],
    );

    Map<String, dynamic> toJson() => {
        "instruction": instruction,
        "tip": tip,
    };

}