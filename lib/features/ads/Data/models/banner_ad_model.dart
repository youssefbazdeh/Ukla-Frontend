import 'dart:convert';

import 'package:ukla_app/core/domain/entities/image.dart';
import 'package:ukla_app/core/domain/entities/video.dart';
import 'package:ukla_app/features/ads/Domain/Entities/banner_ad.dart';

class BannerAdModel extends BannerAd{
  BannerAdModel({
    required super.id,
    super.image,
    required super.countryCode,
    required super.active,
    super.video,
    required super.bannerName,
    required super.clicks,
    required super.redirectionLink,
    required super.views,
    });

  factory BannerAdModel.fromJson(Map<String, dynamic> json) =>
      BannerAdModel(id: json["id"],
          image: json["image"]!= null? Image.fromJson(json["image"]) : null,
          countryCode: json["countryCode"],
          active: json["active"],
          video: json["video"]!= null? Video.fromJson(json["video"]) : null,
          bannerName: json["bannerName"],
          clicks: json["clicks"],
          redirectionLink: json["redirectionLink"],
          views: json["views"]);

  static List<BannerAdModel> bannerAdModelList(String str){
    return List<BannerAdModel>.from(json.decode(str).map((x)=> BannerAdModel.fromJson(x)));
  }
}