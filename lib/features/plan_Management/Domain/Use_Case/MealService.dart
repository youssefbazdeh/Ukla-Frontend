import 'dart:convert';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/domain/api_Service.dart';
import 'package:ukla_app/features/plan_Management/Domain/Entity/Meal.dart';

class MealService {
  static Future<String> addMealToDay(int dayId, String name) async {
    String? url = '${AppString.SERVER_IP}/ukla/Meal/addMealToDay/$dayId';
    var res = await HttpService().post(url, jsonEncode(name));
    return res.body;
  }

  static Future<String> addMealToPlan(int planId, String name) async {
    String? url = '${AppString.SERVER_IP}/ukla/Meal/addMealToPlan/$planId';
    var res = await HttpService().post(url, jsonEncode(name));
    return res.body;
  }

  static Future<List<Meal>> getAllMeals() async {
    String? url = "${AppString.SERVER_IP}/ukla/Meal/findByDayId/16";
    List<Meal> meals = [];
    var resp = await HttpService().get(url);
    if (resp.statusCode == 200) {
      meals = mealListFromJson(resp.body);
    } else {}
    return meals;
  }

  static Future<int> deletMeal(int id) async {
    String? url = '${AppString.SERVER_IP}/ukla/Meal/deleteByID/$id';
    var res = await HttpService().delete(url);
    return (res.statusCode);
  }

  static Future<int> editMealName(String name, int id) async {
    String? url = '${AppString.SERVER_IP}/ukla/Meal/editMealName/$id';
    var res = await HttpService().put(url, name);
    return (res.statusCode);
  }
}