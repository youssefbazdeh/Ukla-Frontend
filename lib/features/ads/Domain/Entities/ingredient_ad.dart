import 'package:ukla_app/core/domain/entities/image.dart';
import 'package:ukla_app/features/ads/Data/models/ingredient_ad_model.dart';

enum CountryCode {
  DZ, EG, LY, MA, TN,

  AE, BH, IQ, IR, JO, KW, LB, OM, QA, SA, SY,

  TR, YE, BE, DE, ES, FI, FR, GB, IT, NL, PT,

  US, CA;
}

class IngredientAd {
  IngredientAd({
    required this.id,
    required this.brandName,
    required this.active,
    required this.views,
    required this.ingredientId,
    required this.countryCode,
    this.image
  });

  final int id;
  final String brandName;
  final bool active;
  final int views;
  final int ingredientId;
  final String countryCode;
  Image? image;

  factory IngredientAd.fromIngredientAdModel(
          IngredientAdModel ingredientAdModel) =>
      IngredientAd(
          id: ingredientAdModel.id,
          brandName: ingredientAdModel.brandName,
          active: ingredientAdModel.active,
          views: ingredientAdModel.views,
          ingredientId: ingredientAdModel.ingredientId,
          countryCode: ingredientAdModel.countryCode,
          image: ingredientAdModel.image);

  static List<IngredientAd> ingredientAdListFromIngredientAdModelList(List<IngredientAdModel> ingredientModelList){
    return ingredientModelList.map((ingredientAdModel) => IngredientAd.fromIngredientAdModel(ingredientAdModel)).toList();
  }

}
