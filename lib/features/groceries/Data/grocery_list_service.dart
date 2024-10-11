import 'dart:typed_data';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/domain/api_Service.dart';

Future<Uint8List> getRecipeImage(int recipeImageId) async {
    String? url = '${AppString.SERVER_IP}/ukla/file-system/image/$recipeImageId';
    var res = await HttpService().get(url);
    return res.bodyBytes;
  }