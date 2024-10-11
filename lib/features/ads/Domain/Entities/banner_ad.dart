import 'package:ukla_app/core/domain/entities/image.dart';
import 'package:ukla_app/core/domain/entities/video.dart';
import 'package:ukla_app/features/ads/Data/models/banner_ad_model.dart';

class BannerAd{
  BannerAd({
    required this.id,
    required this.views,
    required this.active,
    required this.redirectionLink,
    required this.bannerName,
    required this.clicks,
    required this.countryCode,
    this.video,
    this.image,
  });
  int id;
  int views;
  bool active;
  String redirectionLink;
  String bannerName;
  int clicks;
  String countryCode;
  Video? video;
  Image? image;

  factory BannerAd.fromBannerAdModel(BannerAdModel bannerAdModel) =>
      BannerAd(
          id: bannerAdModel.id,
          views: bannerAdModel.views,
          active: bannerAdModel.active,
          redirectionLink: bannerAdModel.redirectionLink,
          bannerName: bannerAdModel.bannerName,
          clicks: bannerAdModel.clicks,
          countryCode: bannerAdModel.countryCode,
          video: bannerAdModel.video,
          image: bannerAdModel.image);

  static List<BannerAd> bannerAdListFromBannerAdModelList(List<BannerAdModel> bannerAdModelList){
    return bannerAdModelList.map((bannerAdModel) => BannerAd.fromBannerAdModel(bannerAdModel)).toList();
  }
}