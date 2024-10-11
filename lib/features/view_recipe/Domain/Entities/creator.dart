import 'package:ukla_app/features/view_recipe/Domain/Entities/recipe.dart';
import 'package:ukla_app/core/domain/entities/image.dart';

class Creator {
  Creator({
    required this.id,
    required this.firstname,
    required this.description,
    required this.lastname,
    this.followersNumber,
    this.image,
    this.createdRecipe,
    this.followed,
  });

  final int id;
  final String firstname;
  final String description;
  final String lastname;
  final Image? image;
  final List<Recipe>? createdRecipe;
  final int? followersNumber;
  final bool? followed;

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json["id"],
      firstname: json['firstName'] ?? "",
      description: json['description'] ?? "",
      lastname: json['lastName'] ?? "",
      image: json['image'] != null ? Image.fromJson(json['image']) : null,
      createdRecipe: json['createdRecipe'] != null ? (json['createdRecipe'] as List)
          .map((i) => Recipe.fromJson(i))
          .toList() : null,
      followersNumber: json['followersNumber'] ?? 0,
      followed: json['followed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'firstName': firstname,
      'lastName' : lastname,
      'description': description,
      'image': image?.toJson(),
      'createdRecipe': createdRecipe?.map((i) => i.toJson()).toList(),
      'followersNumber': followersNumber,
      'followed' : followed,
    };
  }
}
