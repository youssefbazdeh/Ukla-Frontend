import 'dart:convert';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/domain/api_Service.dart';
import 'package:ukla_app/features/plan_Management/Domain/Entity/Plan.dart';
import 'package:ukla_app/features/view_recipe/Domain/Entities/recipe.dart';

class PlanService {
  //add plan :
  static Future<PlanApi> createPlan(
    String date,
  ) async {
    var res = await HttpService()
        .post('${AppString.SERVER_IP}/ukla/Plan/addPLan', jsonEncode(date));

    return planApiFromJson(res.body);
  }

  //delete plan  :
  static Future<int> deletPlan(int id) async {
    final res = await HttpService()
        .delete('${AppString.SERVER_IP}/ukla/Plan/delete/$id');

    return (res.statusCode);
  }

  //get all plans  :
  static Future<List<PlanApi>> getAll(int offset, int limit) async {
    String? url =
        "${AppString.SERVER_IP}/ukla/Plan/retrieveAllByUser/$offset/$limit";
    List<PlanApi> plans = [];
    final resp = await HttpService().get(url);
    if (resp.statusCode == 200) {
      plans = planApiListFromJson(resp.body);
    }
    return plans;
  }

  static Future<PlanApi> retrievePlanById(int id) async {
    String? url = "${AppString.SERVER_IP}/ukla/Plan/retrieveById/$id";

    final resp = await HttpService().get(url);

    var plan = planApiFromJson(resp.body);
    return plan;
  }

  static Future<List<Recipe>> getReceipesByMealTag(String mealname) async {
    String? baseUrl =
        "${AppString.SERVER_IP}/ukla/Recipe/getReceipesByMealTag/$mealname";
    List<Recipe> recipes = [];
    final resp = await HttpService().get(baseUrl);

    if (resp.statusCode == 200) {
      recipes = recipelistFromJson(resp.body);
    }
    return recipes;
  }

  static Future<String> renamePlan(String planName, int? planId) async {
    String? baseUrl =
        "${AppString.SERVER_IP}/ukla/Plan/renamePlan/$planName/$planId";
    final resp = await HttpService().put(baseUrl, "");

    return resp.body;
  }

  static Future<String> followPlan(int? planId) async {
    String? baseUrl = "${AppString.SERVER_IP}/ukla/Plan/follow-plan/$planId";
    final resp = await HttpService().post(baseUrl, "");

    return resp.body;
  }

  //get all plans  :
  static Future<List<PlanApi>> getFollowedPlan() async {
    String? url = "${AppString.SERVER_IP}/ukla/Plan/getFollowedPlan";
    List<PlanApi> plans = [];
    final resp = await HttpService().get(url);
    if (resp.statusCode == 200 || resp.statusCode == 204) {
      if (resp.body.isNotEmpty) {
        plans = planApiListFromJson(resp.body);
      }else{
        return plans;
      }
    }else{
      throw Exception('server error: ${resp.statusCode}');
    }
    return plans;
  }

  static Future<bool> changePlanDate(int planId, String date) async {
    var res = await HttpService().put(
        '${AppString.SERVER_IP}/ukla/Plan/changeTheDateOfThePlan/$planId',
        date);
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
