import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/domain/api_service.dart';



Future<String> updateVideoUrl(String url) async {
  const String apiUrl = '${AppString.SERVER_IP}/ukla/file-system-video/update-video-url';
  Map<String, String> urlMap ={"url":url} ;
  final response = await HttpService().put(apiUrl, urlMap );
    if (response.statusCode == 200) {
      String newUrl = response.body;
      return newUrl;
    } else {
      return "error";
    }

}


Future<bool> incrementViewsCount(int recipeId) async {
    String apiUrl = '${AppString.SERVER_IP}/ukla/Recipe/incrementView/$recipeId';
    final response = await HttpService().post(apiUrl,"");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
}

