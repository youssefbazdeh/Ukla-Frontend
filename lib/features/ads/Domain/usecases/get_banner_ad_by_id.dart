import 'package:ukla_app/features/ads/Domain/repositories/banner_ad_repository.dart';

import '../Entities/banner_ad.dart';

class GetBannerAdById{
  final BannerAdRepository bannerAdRepository;
  GetBannerAdById({required this.bannerAdRepository});

  Future<BannerAd> call(int id) async {
    return await bannerAdRepository.getBannerAdById(id);
  }
}