import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/core/Presentation/components/custom_error_widget.dart';
import 'package:ukla_app/pages/HomePage.dart';
import '../../../main.dart';
import '../../plan_Management/Domain/Entity/Plan.dart';
import '../../plan_Management/Domain/Use_Case/PlanService.dart';
import '../../plan_Management/Presentation/pages/already_created_plan.dart';

class SplashErrorWidget extends StatefulWidget {
  const SplashErrorWidget({Key? key}) : super(key: key);

  @override
  State<SplashErrorWidget> createState() => _SplashErrorWidgetState();
}

class _SplashErrorWidgetState extends State<SplashErrorWidget> {
  late List<PlanApi> futureGetFollowedPlan;

  void loadData()async{
    futureGetFollowedPlan = await PlanService.getFollowedPlan();
    if (futureGetFollowedPlan.isNotEmpty) {
      PlanApi plan = futureGetFollowedPlan.first;
      Provider.of<PlanProvider>(context, listen: false).setPlan(plan);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AlreadyCreatedPlan(
                index: getCurrentDayIndex(plan),
              )));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(child: Column(
        children: [
          SizedBox(height: height/5),
          CustomErrorWidget(onRefresh: loadData , messgae: "")
        ],
      )),
    );
  }
}
