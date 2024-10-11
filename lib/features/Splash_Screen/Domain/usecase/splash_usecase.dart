import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukla_app/core/analytics/events.dart';
import 'package:ukla_app/features/Get_started/Presentation/start_the_journey.dart';
import 'package:ukla_app/pages/HomePage.dart';
import '../../../../main.dart';
import '../../../ads/Data/banner_ad_service.dart';
import '../../../plan_Management/Domain/Entity/Plan.dart';
import '../../../plan_Management/Domain/Use_Case/PlanService.dart';
import '../../../plan_Management/Presentation/pages/already_created_plan.dart';

const storage = FlutterSecureStorage();

class SplashUsecase {

  Future<String> jwtOrEmpty() async {
    var jwt = await storage.read(key: "jwt");

    if (jwt == null) return "";
    return jwt;
  }

  Future<String> loginOrSignup() async {
    var token = await jwtOrEmpty();

    if (token == "") {
      return "login";
    }
    var jwt = token.toString().split(".");
    if (jwt.length != 3) {
      return "login";
    } else {
      var payload =
      json.decode(utf8.decode(base64.decode(base64.normalize(jwt[1]))));
      if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
          .isAfter(DateTime.now())) {
        return "home";
      } else {
        return "login";
      }
    }
  }

  Future checkFirstSeen(BuildContext context, bool onBoardingScreen) async {
    late List<PlanApi> futureGetFollowedPlan;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String countryCode = await getCountryCode();
    await prefs.setString('country_code', countryCode);
    List<int> bannerAdList = await getActiveBannerAdsByCountryCode();
    await getActiveBannerAdsIdsByCountry(bannerAdList);
    if(onBoardingScreen){
      Future.wait([
        precacheImage(
            const AssetImage('assets/images/getstarted.jpg'), context),
      ]).then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const StartJourney()));
      });
    }
    else {
      futureGetFollowedPlan = await PlanService.getFollowedPlan();
      if (futureGetFollowedPlan.isNotEmpty) {
        PlanApi plan = futureGetFollowedPlan.first;
        Provider.of<PlanProvider>(context, listen: false).setPlan(plan);
        FireBaseAnalyticsEvents.screenViewed('Plan_of_week');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AlreadyCreatedPlan(
                      index: getCurrentDayIndex(plan),
                      fromPlanList: false,
                    )));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomePage()));
      }
    }
  }

  Future<String> getCountryCode() async {
    const apiKey = '9h6bnop2sptawztz';
    final apiUrl = Uri.parse('https://api.ipregistry.co/?key=$apiKey');
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final countryCode = jsonResponse['location']['country']['code'];
      return countryCode;
    } else {
      throw Exception('Failed to load country code');
    }
  }
}
