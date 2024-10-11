import 'dart:convert';

import 'package:ukla_app/core/domain/entities/image.dart';
import 'package:ukla_app/features/ads/Domain/Entities/ingredient_ad.dart';

class IngredientAdModel extends IngredientAd{
  IngredientAdModel({
    required super.id, 
    required super.brandName, 
    required super.active, 
    required super.views, 
    required super.ingredientId, 
    required super.countryCode,
    super.image
  });

  factory IngredientAdModel.fromJson(Map<String, dynamic> json) {
    return IngredientAdModel(
      id: json['id'],
      brandName: json['brandName'],
      active: json['active'],
      views: json['views'],
      ingredientId: json['ingredientId'],
      countryCode: json['countryCode'],
      image: Image.fromJson(json["image"]),
    );
  }

  static List<IngredientAdModel> ingredientAdModelList(String str){
    return List<IngredientAdModel>.from(json.decode(str).map((x) => IngredientAdModel.fromJson(x)));
  }

}