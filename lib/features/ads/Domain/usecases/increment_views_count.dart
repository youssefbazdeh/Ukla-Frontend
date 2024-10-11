import '../repositories/banner_ad_repository.dart';

class IncrementViewsCount{
  final BannerAdRepository bannerAdRepository;
  IncrementViewsCount({required this.bannerAdRepository});

  Future<bool> call(int id) async {
    return await bannerAdRepository.incrementViewsCount(id);
  }
}