import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/Presentation/resources/strings_manager.dart';
import '../../../core/domain/api_Service.dart';

Future<Uint8List> getBannerAddImage(int bannerAdImageId) async {
  String? url = '${AppString.SERVER_IP}/ukla/file-system/image/$bannerAdImageId';
  var res = await HttpService().get(url);
  return res.bodyBytes;
}

Future<List<int>> getActiveBannerAdsByCountryCode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? countryCode = prefs.getString('country_code');
  String? url ='${AppString.SERVER_IP}/ukla/bannerAd/getAll/$countryCode';
  final response = await HttpService().get(url);
  if(response.statusCode == 200){
    return List<int>.from(jsonDecode(response.body).map((item) => item as int));
  }else if(response.statusCode == 204){
    return [];
  }
  throw Exception("failed to load banner ads");
}

Future<List<String>> getActiveBannerAdsIdsByCountry(List<int> list) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> ids = [];
  for(var item in list){
    ids.add(item.toString());
  }
  prefs.setStringList('banner_ad_list', ids);
  return ids;
}