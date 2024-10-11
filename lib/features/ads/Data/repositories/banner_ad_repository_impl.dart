import 'package:ukla_app/features/ads/Data/datasources/banner_ad_remote_data_source.dart';
import 'package:ukla_app/features/ads/Domain/Entities/banner_ad.dart';
import 'package:ukla_app/features/ads/Domain/repositories/banner_ad_repository.dart';

class BannerAdRepositoryImpl implements BannerAdRepository{
  final BannerAdRemoteDataSource remoteDataSource;

  BannerAdRepositoryImpl({required this.remoteDataSource});

  @override
  Future<BannerAd> getBannerAdById(int id) async {
    return await remoteDataSource.getBannerAdById(id);
  }

  @override
  Future<bool> incrementViewsCount(int id) async {
    return await remoteDataSource.incrementViewsCount(id);
  }
}