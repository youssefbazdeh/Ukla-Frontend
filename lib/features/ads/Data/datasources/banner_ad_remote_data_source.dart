import 'dart:convert';
import 'package:ukla_app/core/domain/api_Service.dart';
import 'package:ukla_app/features/ads/Data/models/banner_ad_model.dart';
import '../../../../core/Presentation/resources/strings_manager.dart';
import '../../Domain/Entities/banner_ad.dart';

abstract class BannerAdRemoteDataSource {
  Future<BannerAd> getBannerAdById(int id);
  Future<bool> incrementViewsCount(int id);
}

class BannerAdRemoteDataSourceImpl implements BannerAdRemoteDataSource{
  final HttpService client;
  BannerAdRemoteDataSourceImpl({required this.client});

  @override
  Future<BannerAd> getBannerAdById(int id) async {
    String? url = '${AppString.SERVER_IP}/ukla/bannerAd/getById/$id';
    final response = await client.get(url);
    if(response.statusCode == 200){
      return BannerAd.fromBannerAdModel(BannerAdModel.fromJson(jsonDecode(response.body)));
    }else if(response.statusCode == 404){
      throw Exception(response.body);
    }
    throw Exception("failed to load banner");
  }

  @override
  Future<bool> incrementViewsCount(int id) async {
    String? url = '${AppString.SERVER_IP}/ukla/bannerAd/incrementView/$id';
    var res = await HttpService().post(url,"");
    if(res.statusCode == 200){
      return true;
    }
    else {
      return false;
    }
  }

}