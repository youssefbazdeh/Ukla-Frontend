import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/features/plan_Management/Domain/Use_Case/MealService.dart';
import 'package:ukla_app/features/plan_Management/Domain/Entity/Meal.dart';
import 'package:ukla_app/features/plan_Management/Domain/Entity/Plan.dart';
import 'package:ukla_app/features/plan_Management/Domain/Use_Case/PlanService.dart';
import 'package:ukla_app/features/plan_Management/Presentation/widgets/delete_meal_alert.dart';
import 'package:ukla_app/features/plan_Management/Presentation/widgets/meal_empty_card.dart';

import '../../../../main.dart';

class Listmealsperday extends StatefulWidget {
  const Listmealsperday({required this.idday, Key? key}) : super(key: key);
  final int idday;

  @override
  State<Listmealsperday> createState() => _ListmealsperdayState();
}

class _ListmealsperdayState extends State<Listmealsperday> {
  bool test = false;
  late PlanApi plancurent;
  bool allDays = false;
  bool onlyOneDay = false;
  late ScrollController _scrollController;

  void deletemeal(int i, PlanApi plann) {
    Future.delayed(Duration.zero, () {
      setState(() {});
      MealService.deletMeal(plann.days[widget.idday].meals![i].id!);
      plann.days[widget.idday].meals!
          .remove(plann.days[widget.idday].meals![i]);
      Provider.of<PlanProvider>(context,listen: false).setPlan(plann);
    });
  }

  @override
  void initState() {
    test = false;
    _scrollController = ScrollController();
    Provider.of<LanguageProvider>(context, listen: false).loadLanguageCode();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    plancurent = Provider.of<PlanProvider>(context, listen: true).getplan();
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: _scrollController,
      child: Column(
        children: [
          InkWell(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: plancurent.days[widget.idday].meals!.length,
                itemBuilder: (contextlist, index) {
                  return MealEmptyCard(
                      index: index,
                      mealTitle: translateMealTitle(plancurent.days[widget.idday].meals![index].name.capitalize()),
                      onSuggest: () {
                        Provider.of<indexMeal>(context, listen: false)
                            .setIndex(index);
                      },
                      onPressed: () {
                        Provider.of<indexMeal>(context, listen: false)
                            .setIndex(index);
                      },
                      selecteditem: (String value) {
                        if (value == "itemTwo") {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            alertmealdialog1(index, width, (index1) {
                              deletemeal(index, plancurent);
                            }, context);
                          });
                        }
                      },
                      tetsvalue: test,
                      mealtextController: (TextEditingController(
                          text: translateMealTitle(plancurent.days[widget.idday].meals![index].name
                              .replaceAll(RegExp(r'"'), '')
                              .capitalize()))),

                      recipes:
                      plancurent.days[widget.idday].meals![index].recipes,
                      addToDB: (String mealtitle, bool value, bool rename) async {
                        if (value == true && test == true) {
                          showDialog(
                            barrierColor: Colors.black.withOpacity(0.1),
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext dialogContext) {
                              return const AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Adding Meal ..."),
                                    SizedBox(height: 16),
                                    LinearProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryPale),
                                      backgroundColor: Colors.white,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );

                          try {
                            if (allDays == true) {
                              if ((mealtitle.replaceAll(RegExp(r'"'), '')).isNotEmpty) {
                                await MealService.addMealToPlan(
                                  plancurent.id!,
                                  mealtitle.replaceAll(RegExp(r'"'), ''),
                                );
                                Provider.of<PlanProvider>(context, listen: false)
                                    .getplan()
                                    .days[widget.idday]
                                    .meals![index]
                                    .name = mealtitle.replaceAll(RegExp(r'"'), '');
                                allDays = false;
                              } else if (mealtitle == ""){
                                await MealService.addMealToPlan(plancurent.id!, "empty meal");

                                Provider.of<PlanProvider>(context, listen: false)
                                    .getplan()
                                    .days[widget.idday]
                                    .meals![index]
                                    .name = "empty meal ";
                                allDays = false;
                              }
                            }
                            else if (onlyOneDay == true) {
                              if (mealtitle.isNotEmpty) {
                                await MealService.addMealToDay(plancurent.days[widget.idday].id, mealtitle,);
                                Provider.of<PlanProvider>(context, listen: false).getplan().days[widget.idday].meals![index].name = mealtitle;
                                onlyOneDay = false;
                              } else if (mealtitle == ""){
                                await MealService.addMealToDay(plancurent.days[widget.idday].id, "empty meal ",);
                                Provider.of<PlanProvider>(context, listen: false).getplan().days[widget.idday].meals![index].name = "empty meal";
                                onlyOneDay = false;
                              }
                            }

                            PlanApi newplan = await PlanService.retrievePlanById(plancurent.id!);
                            plancurent = newplan;
                            Provider.of<PlanProvider>(context, listen: false).setPlan(newplan);

                          } finally {
                            Navigator.of(context, rootNavigator: true).pop();
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        } else if (rename == true) {
                          if (((mealtitle.replaceAll(RegExp(r'"'), ''))).isNotEmpty) {
                            MealService.editMealName(
                              mealtitle,
                              plancurent.days[widget.idday].meals![index].id!,
                            );

                            Provider.of<PlanProvider>(context, listen: false)
                                .getplan()
                                .days[widget.idday]
                                .meals![index]
                                .name = mealtitle;
                          } else {
                            MealService.editMealName(
                              "empty meal",
                              plancurent.days[widget.idday].meals![index].id!,
                            );

                            Provider.of<PlanProvider>(context, listen: false)
                                .getplan()
                                .days[widget.idday]
                                .meals![index]
                                .name = "empty meal";
                          }
                        }
                      });
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: InkWell(
              onTap: () async {
                if (mounted) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20.0))),
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                                child: Text(
                                  "add this meal to all days of this plan?",
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: width - 100,
                              child: const Text(
                                "By confirming this action this meal will added to all days of the current plan ",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                TextButton(
                                    onPressed: //         onPressed:
                                        () {
                                      onlyOneDay = true;
                                      test = true;
                                      SchedulerBinding.instance
                                          .addPostFrameCallback((_) {
                                        if (mounted) setState(() {});
                                      });

                                      Provider.of<PlanProvider>(context,
                                          listen: false)
                                          .getplan()
                                          .days[widget.idday]
                                          .meals!
                                          .add(Meal(
                                          name: "new meal ", recipes: []));
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    child:  Text(
                                      "Only this day",
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          color: AppColors.secondaryColor),
                                    )),
                              ],
                            ),
                            const Column(
                              children: [
                                Text(
                                  "|",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 181, 181, 181),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      allDays = true;
                                      test = true;
                                      SchedulerBinding.instance
                                          .addPostFrameCallback((_) {
                                        if (mounted) setState(() {});
                                      });
                                      Provider.of<PlanProvider>(context,
                                          listen: false)
                                          .getplan()
                                          .days[widget.idday]
                                          .meals!
                                          .add(Meal(
                                          name: "new meal ", recipes: []));
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    child:  Text(
                                      "All days",
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          color: AppColors.secondaryColor),
                                    ))
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: const Color(0XFFF2F2F2),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    Title(
                        color: Colors.red,
                        child: Text(
                          "add_meal".tr(context),
                          style:  TextStyle(fontSize: 17.sp),
                        )),
                    const Spacer(),
                    const Icon(Ionicons.add_outline)
                  ]),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 33,
          )
        ],
      ),
    );
  }

  Map<String, Map<String, String>> mealTitleTranslations = {
    'Breakfast': {
      'en': 'Breakfast',
      'fr': 'Petit déjeuner',
      'ar': 'الإفطار',
    },
    'Lunch': {
      'en': 'Lunch',
      'fr': 'Déjeuner',
      'ar': 'الغداء',
    },
    'Dinner': {
      'en': 'Dinner',
      'fr': 'Dîner',
      'ar': 'العشاء',
    },
  };

  String translateMealTitle(String mealTitle) {
    String languageCode = Provider.of<LanguageProvider>(context, listen: true).languageCode;
    if (mealTitleTranslations.containsKey(mealTitle)) {
      if (mealTitleTranslations[mealTitle]!.containsKey(languageCode)) {
        return mealTitleTranslations[mealTitle]![languageCode]!;
      }
    }
    return mealTitle;
  }

}