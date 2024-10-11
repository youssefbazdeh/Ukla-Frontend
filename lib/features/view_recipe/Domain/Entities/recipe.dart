import 'package:ukla_app/core/domain/entities/video.dart';
import 'package:ukla_app/features/view_recipe/Domain/Entities/step.dart';
import 'package:ukla_app/core/domain/entities/image.dart';
import 'package:ukla_app/features/view_recipe/Domain/Entities/tag.dart';
import 'package:ukla_app/features/view_recipe/Domain/Entities/creator.dart';
import 'dart:convert';

Recipe recipeFromJson(String str) => Recipe.fromJson(json.decode(str));

String recipeToJson(Recipe data) => json.encode(data.toJson());
List<Recipe> recipelistFromJson(String str) =>
    List<Recipe>.from(json.decode(str).map((x) => Recipe.fromJson(x)));

class Recipe {

  Recipe({
    this.id,
    required this.name,
    required this.description,
    required this.preparationTime,
    required this.cookingTime,
    required this.nbrCalories,
    required this.steps,
    required this.tags,
    required this.image,
    this.video,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.favorite,
    required this.portions,
    this.creator,
    this.recipeInUserFavorites
  });

  int? id;
  String name;
  String description;
  int preparationTime;
  int cookingTime;
  double nbrCalories;
  List<Step> steps;
  List<Tag> tags;
  Image image;
  Video? video;
  double protein;
  double fat;
  double carbs;
  double fiber;
  double sugar;
  Creator? creator;
  bool? recipeInUserFavorites;
  bool favorite;
  int portions;

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json["id"],
        name: json["name"],
        description: json["description"] ?? "",
        preparationTime: json["preparationTime"] ?? 0,
        nbrCalories: json["calories"] ?? 0,
        cookingTime: json["cookingTime"] ?? 0,
        steps: json["steps"] != null ? List<Step>.from(json["steps"].map((x) => Step.fromJson(x))) : [],
        tags: json["tags"] != null ? List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))) : [],
        image: Image.fromJson(json["image"]),
        video: json["video"] != null ? Video.fromJson(json["video"]) : null,
        protein: json["protein"] ?? 0.0,
        carbs: json["carbs"] ?? 0.0,
        fat: json["fat"] ?? 0.0,
        fiber: json["fiber"] ?? 0.0,
        sugar: json["sugar"] ?? 0.0,
        favorite: json["favorite"] ?? false,
        creator: json["creator"] != null ? Creator.fromJson(json["creator"]) : null,
        portions: json["portions"] ?? 0,
        recipeInUserFavorites: json["recipeInUserFavorites"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "preparationTime": preparationTime,
        "cookingTime": cookingTime,
        "nbrCalories": nbrCalories,
        "steps": List<dynamic>.from(steps.map((x) => x.toJson())),
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
        "protein": protein,
        "carbs": carbs,
        "fat": fat,
        "fiber": fiber,
        "sugar": sugar,
        "favorite": favorite,
        "portions": portions,
        "creator": creator?.toJson(),
        "recipeInUserFavorites" : recipeInUserFavorites,
      };
}
