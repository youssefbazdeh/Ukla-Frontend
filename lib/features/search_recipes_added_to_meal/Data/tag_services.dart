import 'dart:convert';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/domain/api_service.dart';
import 'package:ukla_app/features/view_recipe/Domain/Entities/tag.dart';

class TagService {
  static Future<List<Tag>> getAllTags() async {
    String? url = '${AppString.SERVER_IP}/ukla/tag/getAllT';
    List<Tag> tags = [];
    var res = await HttpService().get(url);
    if (res.statusCode == 200) {
      for (var item in json.decode(res.body)) {
        tags.add(Tag.fromJson(item));
      }
    }
    return tags;
  }
}