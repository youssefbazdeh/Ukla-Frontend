import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/core/Presentation/resources/assets_manager.dart';
import 'package:ukla_app/features/Splash_Screen/Presentation/splashScreen_error_widget.dart';
import 'package:ukla_app/core/analytics/events.dart';
import 'package:ukla_app/pages/HomePage.dart';
import '../../../core/Presentation/resources/routes_manager.dart';
import '../../../main.dart';
import '../../plan_Management/Domain/Entity/Plan.dart';
import '../../plan_Management/Domain/Use_Case/PlanService.dart';
import '../../plan_Management/Presentation/pages/already_created_plan.dart';
import '../Domain/usecase/splash_usecase.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  late List<PlanApi> futureGetFollowedPlan;

  _startDelay() async {
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

  _goNext() async {
    String nextPage = await SplashUsecase().loginOrSignup();
    if (nextPage == "home") {
      //Navigator.pushReplacementNamed(context, Routes.homeRoute);
      try {
        futureGetFollowedPlan = await PlanService.getFollowedPlan();
        if (futureGetFollowedPlan.isNotEmpty) {
          PlanApi plan = futureGetFollowedPlan.first;
          Provider.of<PlanProvider>(context, listen: false).setPlan(plan);
          FireBaseAnalyticsEvents.screenViewed('Plan_of_week');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AlreadyCreatedPlan(
                    index: getCurrentDayIndex(plan),
                    fromPlanList: false,
                  )));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
        }
      } catch (e) {
        if ((e is Exception && e.toString().contains('server error')) ||
            e.toString() == "Connection failed" ||
            e is TimeoutException) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const SplashErrorWidget()));
        }
      }
    } else {
      Navigator.pushReplacementNamed(context, Routes.loginRoute);
    }
  }

  @override
  void initState() {
    _startDelay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white, // replace it with colors manager
      body: Center(
          child: Image(
              image: AssetImage(ImageAssets.splashLogo),
              height: 150,
              width: 150)),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
