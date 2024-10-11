import 'dart:convert';

import '../../../view_recipe/Domain/Entities/recipe.dart';

List<Meal> mealListFromJson(String str) =>
    List<Meal>.from(json.decode(str).map((x) => Meal.fromJson(x)));

Meal mealFromJson(String str) => Meal.fromJson(json.decode(str));

String mealToJson(Meal data) => json.encode(data.toJson());

class Meal {
  Meal({
    this.id,
    this.dayId,
    required this.name,
    required this.recipes,
  });

  int? id;

  int? dayId;

  String name;
  List<Recipe> recipes;

  @override
  String toString() {
    return "name : $name \n id meal : $id \n dayid : $dayId   "
        "";
  }

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        id: json["id"],
        dayId: json["day_id"],
        name: json["name"],
        recipes: json["recipes"] != null
            ? List<Recipe>.from(json["recipes"].map((x) => Recipe.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day_id": dayId,
        "name": name,
        "recipes": List<dynamic>.from(recipes.map((x) => x.toJson())),
      };
}
