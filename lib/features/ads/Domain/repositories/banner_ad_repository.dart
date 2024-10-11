import '../Entities/banner_ad.dart';

abstract class BannerAdRepository{
  Future<BannerAd> getBannerAdById(int id);
  Future<bool> incrementViewsCount(int id);
}