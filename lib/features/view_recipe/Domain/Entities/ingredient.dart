import 'package:ukla_app/core/domain/entities/image.dart';
import 'package:ukla_app/features/view_recipe/Domain/Entities/unit_alternatives.dart';
import 'package:ukla_app/features/ads/Data/models/ingredient_ad_model.dart';

import '../../../ads/Domain/Entities/ingredient_ad.dart';

class Ingredient {
  Ingredient(
      {required this.name,
      this.type,
      this.nbrCalories100Gr,
      this.fat,
      this.protein,
      this.carbs,
      this.fiber,
      this.sugar,
      this.image,
      this.unitAlternatives,
      this.ingredientAd});
  double? fat;
  double? protein;
  double? carbs;
  double? sugar;
  double? fiber;
  String? name;
  String? type;
  double? nbrCalories100Gr;
  Image? image;
  IngredientAd? ingredientAd;
  List<UnitAlternative>? unitAlternatives;

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
      name: json["name"],
      type: json["type"],
      nbrCalories100Gr: json["nbrCalories100gr"],
      fat: json["fat"],
      protein: json["protein"],
      carbs: json["carbs"],
      sugar: json["sugar"],
      fiber: json["fiber"],
      image: Image.fromJson(json["image"]),
      unitAlternatives: (json["unitAlternatives"] as List<dynamic>?)
        ?.map((x) => UnitAlternative.fromJson(x))
        .toList() ??
        [],
      ingredientAd: json["ingredientAd"]!= null? IngredientAd.fromIngredientAdModel(IngredientAdModel.fromJson(json["ingredientAd"])) : null,
  );


  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "nbrCalories100gr": nbrCalories100Gr,
      };
}
