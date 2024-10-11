import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/female_body_info.dart';
import 'package:ukla_app/features/body_needs_estimation/presentation/widgets/legend_item.dart';
import 'package:ukla_app/pages/HomePage.dart';
import '../../domain/entities/male_body_info.dart';

// ignore: must_be_immutable
class ActivityResults extends StatelessWidget {
  ActivityResults({super.key, this.malebodyInfo, this.femalebodyInfo});
  MaleBodyInfo? malebodyInfo;
  FemaleBodyInfo? femalebodyInfo;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Color grey = const Color(0XFFF4F4F4);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: width / 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Body results".tr(context),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0XFFFA6375),
                          letterSpacing: 0),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: width / 15, left: width / 15),
              child: Container(
                width: width,
                decoration: BoxDecoration(
                    color: grey,
                    borderRadius: BorderRadius.circular(26)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: maleOrFemale(width, height, context),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: width / 9, left: width / 9, bottom: height / 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Readjust activities".tr(context),
                        style:TextStyle(
                          fontSize: 14.sp,
                          decoration: TextDecoration.underline,
                        ),
                      )),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(246, 45, 166, 57),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                    },
                    child: Text(
                      "Looks good".tr(context),
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget maleOrFemale(width, height, BuildContext context) {
    List<Color> listColors = [
      const Color.fromARGB(222, 109, 144, 241),
      AppColors.secondaryColor.withOpacity(0.9),
      const Color(0XFFfdfd96),
      const Color.fromARGB(202, 162, 112, 237),
      const Color.fromARGB(233, 97, 235, 226),
      const Color(0XFFffb347),
    ];
    if (malebodyInfo != null) {
      Map<String, double> dataMapMaleBody = {
        "Lying".tr(context): malebodyInfo!.physicalActivityLevelA!,
        "Sitting".tr(context): malebodyInfo!.physicalActivityLevelB!,
        "Standing".tr(context): malebodyInfo!.physicalActivityLevelC!,
        "Moderate".tr(context): malebodyInfo!.physicalActivityLevelD!,
        "High intensity".tr(context): malebodyInfo!.physicalActivityLevelE!,
        "Intense".tr(context): malebodyInfo!.physicalActivityLevelF!,
      };
     
      return Column(
          children: [
        Row(
          children: [
            Flexible(
              child: RichText(
                text: TextSpan(
                  text: "Your daily needs in calories : ".tr(context),
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                  children: <InlineSpan>[
                    TextSpan(
                      text: "${malebodyInfo!.calorieNeed}",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[800]),
                    ),
                    WidgetSpan(
                      child: Transform.translate(
                        offset: Offset(0, -2), // Adjust the y-axis value as needed
                        child: Icon(
                          Ionicons.flame_outline,
                          size: 16.0,
                          color: Colors.orange[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: height / 31,
        ),
        Row(
          children: [
            Text(
              "Doing theses activies : ".tr(context),
              style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
            SizedBox(height:height*0.03),
            PieChart(
          dataMap: dataMapMaleBody,
          animationDuration: const Duration(milliseconds: 800),
          chartLegendSpacing: 25,
          chartRadius: width / 1.65,
          colorList: listColors,
          initialAngleInDegree: 0,
          legendOptions: const LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.bottom,
            legendShape: BoxShape.circle,
            showLegends: false,
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValueBackground: false,
            showChartValues: true,
            showChartValuesInPercentage: false,
            showChartValuesOutside: false,
            decimalPlaces: 1,
          ),
        ),
            SizedBox(height:height*0.03),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LegendItem(
                      title: dataMapMaleBody.keys.elementAt(0),
                      color: listColors[0]),
                  LegendItem(
                      title: dataMapMaleBody.keys.elementAt(1),
                      color: listColors[1]),
                  LegendItem(
                      title: dataMapMaleBody.keys.elementAt(2),
                      color: listColors[2])
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LegendItem(
                      title: dataMapMaleBody.keys.elementAt(3),
                      color: listColors[3]),
                  LegendItem(
                      title: dataMapMaleBody.keys.elementAt(4),
                      color: listColors[4]),
                  LegendItem(
                      title: dataMapMaleBody.keys.elementAt(5),
                      color: listColors[5]),
                ],
              ),
            ],
          ),
        )
      ]);
    } else if (femalebodyInfo != null) {
      Map<String, double> dataMapFemaleBody = {
        "Lying".tr(context): femalebodyInfo!.physicalActivityLevelA!,
        "Sitting".tr(context): femalebodyInfo!.physicalActivityLevelB!,
        "Standing".tr(context): femalebodyInfo!.physicalActivityLevelC!,
        "Moderate".tr(context): femalebodyInfo!.physicalActivityLevelD!,
        "High intensity".tr(context): femalebodyInfo!.physicalActivityLevelE!,
      };
  
      return Column(children: [
        Row(
          children: [
            Flexible(
              child: RichText(
                text: TextSpan(
                  text: "Your daily needs in calories : ".tr(context),
                  style: TextStyle(
                      fontSize: 19.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                  children: <TextSpan>[
                    TextSpan(
                        text: "${femalebodyInfo!.calorieNeed}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[800])),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: height / 30,
        ),
        Row(
          children: [
            Text(
              "Doing these activies : ".tr(context),
              style: TextStyle(
                  fontSize: 18.sp, color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 15),
        PieChart(
          dataMap: dataMapFemaleBody,
          animationDuration: const Duration(milliseconds: 800),
          chartLegendSpacing: 25,
          chartRadius: width / 1.65,
          colorList: listColors,
          initialAngleInDegree: 0,
          legendOptions: const LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.bottom,
            legendShape: BoxShape.circle,
            showLegends: false,
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValueBackground: false,
            showChartValues: true,
            showChartValuesInPercentage: false,
            showChartValuesOutside: false,
            decimalPlaces: 0,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LegendItem(
                      title: dataMapFemaleBody.keys.elementAt(0),
                      color: listColors[0]),
                  LegendItem(
                      title: dataMapFemaleBody.keys.elementAt(1),
                      color: listColors[1]),
                  LegendItem(
                      title: dataMapFemaleBody.keys.elementAt(2),
                      color: listColors[2])
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LegendItem(
                      title: dataMapFemaleBody.keys.elementAt(3),
                      color: listColors[3]),
                  LegendItem(
                      title: dataMapFemaleBody.keys.elementAt(4),
                      color: listColors[4]),
                ],
              ),
            ],
          ),
        )
      ]);
    } else {
      return Text("no object passed ".tr(context));
    }
  }
}
