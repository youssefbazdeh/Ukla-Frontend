import 'package:http/http.dart' as http;
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/main.dart';

class NutritionService {
  static Future<int> getCalorieNeeds() async {
    String? url = "${AppString.SERVER_IP}/ukla/nutrition/getBodyInfo";

    final resp = await http.get(Uri.parse(url), headers: <String, String>{
      // ignore: unnecessary_this
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': 'Bearer ${await storage.read(key: "jwt")}',
    });
    var calories = int.parse(resp.body);
    return calories;
  }
}
