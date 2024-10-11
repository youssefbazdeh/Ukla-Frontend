import 'package:ukla_app/core/domain/entities/video.dart';
import 'package:ukla_app/features/view_recipe/Domain/Entities/ingredient_quantity_object.dart';

class Step {
  Step(
      {required this.instruction,
      required this.tip,
      required this.ingredientQuantityObjects,
      this.video});
  int? id;
  String instruction;
  String tip;
  Video? video;

  List<IngredientQuantityObject> ingredientQuantityObjects;
factory Step.fromJson(Map<String, dynamic>? json) {
  if (json == null) {
    throw const FormatException("Invalid JSON");
  }

  return Step(
    instruction: json["instruction"] ?? "", 
    tip: json["tip"] ?? "", 
    ingredientQuantityObjects: (json["ingredientQuantityObjects"] as List<dynamic>?)
            ?.map((x) => IngredientQuantityObject.fromJson(x))
            .toList() ??
        [],
    video: json["video"] != null ? Video.fromJson(json["video"]) : null,
  );
}


  Map<String, dynamic> toJson() => {
        "instruction": instruction,
        "tip": tip,
        "ingredientQuantityObjects": ingredientQuantityObjects
      };
}
