import 'dart:convert';

import 'package:ukla_app/core/domain/entities/video.dart';
import 'package:ukla_app/features/AddRecipe/Domain/Entities/creator_recipe.dart';

class CreatorRecipeModel extends CreatorRecipe {
  CreatorRecipeModel({
    required super.id,
    required super.title,
    required super.description,
    required super.video,
    required super.creator,
  });

  factory CreatorRecipeModel.fromJson(Map<String, dynamic> json) => CreatorRecipeModel(id: json["id"], title: json["title"], description: json["description"], video: Video.fromJson(json["video"]), creator: json["creator"]);

  List<CreatorRecipeModel> listCreatorRecipeFromJson(String str) => List<CreatorRecipeModel>.from(json.decode(str).map((x) => CreatorRecipeModel.fromJson(x)));
}
