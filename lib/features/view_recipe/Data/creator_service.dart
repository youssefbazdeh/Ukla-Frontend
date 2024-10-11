import 'dart:convert';

import 'package:ukla_app/features/view_recipe/Domain/Entities/creator.dart';

import '../../../core/Presentation/resources/strings_manager.dart';
import '../../../core/domain/api_service.dart';

class CreatorService {
  Future<Creator> getCreatorById(int id) async {
    String? url = '${AppString.SERVER_IP}/ukla/creator/getById/$id';
    var res = await HttpService().get(url);
    if(res.statusCode == 200){
      return Creator.fromJson(jsonDecode(res.body));
    }else{
      throw Exception("unable to load creator profile");

    }
  }
  Future<String> followCreator(int id) async {
    String? url = '${AppString.SERVER_IP}/ukla/creator/followCreator/$id';
    var res = await HttpService().put(url,"");
    if(res.statusCode == 200){
      return res.body;
    }else{
      throw Exception("unable to load creator profile");

    }
  }
  Future<String> unFollowCreator(int id) async {
    String? url = '${AppString.SERVER_IP}/ukla/creator/unfollowCreator/$id';
    var res = await HttpService().put(url,"");
    if(res.statusCode == 200){
      return res.body;
    }else{
      throw Exception("unable to load creator profile");

    }
  }
}