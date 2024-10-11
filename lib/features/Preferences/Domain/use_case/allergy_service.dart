import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/features/Preferences/Domain/entities/allergy.dart';
import 'package:ukla_app/main.dart';

class AllergyService {
  static Future<List<Allergy>> getAllAllergies() async {
    String? baseUrl = "${AppString.SERVER_IP}/ukla/Allergies/All";
    List<Allergy> allergies = [];
    final response =
        await http.get(Uri.parse(baseUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': 'Bearer ${await storage.read(key: "jwt")}',
    });

    if (response.statusCode == 200) {
      for (var item in json.decode(response.body)) {
        allergies.add(Allergy.fromJson(item));
      }
    }
    return allergies;
  }

  static Future<List<Allergy>> getSelectedAllergies() async {
    String? baseUrl = "${AppString.SERVER_IP}/ukla/Allergies/AllByUser";
    List<Allergy> allergies = [];
    final response =
        await http.get(Uri.parse(baseUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': 'Bearer ${await storage.read(key: "jwt")}',
    });

    if (response.statusCode == 200) {
      for (var item in json.decode(response.body)) {
        allergies.add(Allergy.fromJson(item));
      }
    }
    return allergies;
  }

  static Future<bool> addAllergies(List<int> allergiesId) async {
    var res = await http.post(
        Uri.parse('${AppString.SERVER_IP}/ukla/Allergies/addForUser'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${await storage.read(key: "jwt")}',
        },
        body: jsonEncode(allergiesId));
    if ((res.statusCode == 201)) {
      return true;
    }
    return false;
  }
}
