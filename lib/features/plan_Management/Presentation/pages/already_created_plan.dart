import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/components/custom_error_widget.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/features/plan_Management/Domain/Use_Case/PlanService.dart';
import 'package:ukla_app/features/plan_Management/Presentation/widgets/list_meals.dart';
import 'package:ukla_app/core/Presentation/tabBar/tab_card.dart';
import 'package:ukla_app/features/plan_Management/Presentation/widgets/calorie-widget.dart';
import 'package:ukla_app/main.dart';
import 'package:ukla_app/pages/HomePage.dart';
import '../../../../core/Presentation/components/translate_day_logic.dart';
import '../../Domain/Entity/Plan.dart';

class AlreadyCreatedPlan extends StatefulWidget {
  AlreadyCreatedPlan({required this.index, Key? key, this.plandId, this.fromPlanList}) : super(key: key);
  int index;
  final int? plandId;
  final bool? fromPlanList;
  @override
  State<AlreadyCreatedPlan> createState() => _AlreadyCreatedPlanState();
}

class _AlreadyCreatedPlanState extends State<AlreadyCreatedPlan> with TickerProviderStateMixin {
  bool isLoading = true;
  String? errorMessage;
  bool dateChanged = false;

  fetchPlanData() async {
    try {
      if (widget.plandId != null) {
        var plan = await PlanService.retrievePlanById(widget.plandId!);
        Provider.of<PlanProvider>(context, listen: false).setPlan(plan);
        isFollowing = Provider.of<PlanProvider>(context, listen: false).getplan().followed;
      }
    } catch (e) {
      errorMessage = 'Failed to load plan data';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void refreshData() {
    errorMessage = null;
    fetchPlanData();
    setState(() {});
  }

  late final TabController _tabController = TabController(vsync: this, length: 7, initialIndex: widget.index);
  late bool? isFollowing = true;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    fetchPlanData();
    Provider.of<LanguageProvider>(context, listen: false).loadLanguageCode();
    _tabController.animation?.addListener(() {
      setState(() {
        _currentIndex = (_tabController.animation?.value)!.round();
        Provider.of<indexTabBarPlan>(context, listen: false).setIndex(_currentIndex);
      });
    });
  }

  calcumClaories() {
    var indexDay = Provider.of<indexTabBarPlan>(context, listen: false).getIndex();
    var meals = Provider.of<PlanProvider>(context, listen: true).getplan().days[indexDay].meals;
    var sumCal = 0.0;

    for (var element in meals!) {
      for (var recipe in element.recipes) {
        sumCal += recipe.nbrCalories;
      }
    }

    return sumCal;
  }

  List<Day> generateDaysForNextSevenDays() {
    List<Day> days = [];

    DateTime startDate = DateTime.now();

    for (int i = 0; i < 7; i++) {
      DateTime date = startDate.add(Duration(days: i));

      Day day = Day(
        id: i,
        name: DateFormat('EEEE').format(date),
        date: date,
        meals: [],
      );

      days.add(day);
    }

    return days;
  }

  // Future<int?> bodyNeedsCalByUser() async {
  //   int? caloriesneeds = -1;

  //   var calories = await NutritionService.getCalorieNeeds();
  //   caloriesneeds = calories;

  //   return caloriesneeds;
  // }

  bool lockTextField = false;
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      var width = MediaQuery.of(context).size.width; // width of the screen
      List months = ['Jan'.tr(context), 'Feb'.tr(context), 'Mar'.tr(context), 'April'.tr(context), 'May'.tr(context), 'Jun'.tr(context), 'July'.tr(context), 'Aug'.tr(context), 'Sep'.tr(context), 'Oct'.tr(context), 'Nov'.tr(context), 'Dec'.tr(context)];

      var date1 = DateTime.now();

      var date2 = DateTime.now().add(const Duration(days: 7));

      String day1 = DateFormat('dd').format(date1);

      String day2 = DateFormat('dd').format(date2);

      var endWeekDateDay = int.parse(day2);
      var beginWeekDateDay = int.parse(day1);
      var month = date1.month;
      var mon = months[month - 1];
      var weekdays = [];
      var days = generateDaysForNextSevenDays();
      for (var element in days) {
        String dayName = DateFormat('EEEE').format(element.date);
        String translatedDayName = translateDay(dayName.toUpperCase(), Provider.of<LanguageProvider>(context, listen: false).languageCode);
        if (Provider.of<LanguageProvider>(context, listen: false).languageCode == "ar") {
          weekdays.add(translatedDayName.substring(2));
        } else
          weekdays.add(translatedDayName.substring(0, 1).toUpperCase() + translatedDayName.substring(1, 3).toLowerCase());
      }

      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(
              Ionicons.arrow_back,
              color: Colors.black,
              size: 25,
            ),
            onPressed: () {},
          ),
          title: InkWell(
            onTap: () async {},
            child: Row(
              children: [
                SizedBox(
                  width: width / 4,
                ),
                Text('$mon $beginWeekDateDay - $endWeekDateDay', style: TextStyle(fontSize: 20.sp, color: Colors.black), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          color: AppColors.primaryColor,
          child: Column(children: [
            TabBar(
                tabAlignment: TabAlignment.center,
                dividerColor: Colors.white,
                indicatorPadding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                indicator: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorWeight: 0,
                automaticIndicatorColorAdjustment: false,
                isScrollable: true,
                splashBorderRadius: BorderRadius.circular(20),
                labelColor: AppColors.primaryColor,
                controller: _tabController,
                unselectedLabelColor: const Color.fromARGB(255, 0, 0, 0),
                onTap: (value) {},
                tabs: [
                  TabCard(title: weekdays[0]),
                  TabCard(title: weekdays[1]),
                  TabCard(title: weekdays[2]),
                  TabCard(title: weekdays[3]),
                  TabCard(title: weekdays[4]),
                  TabCard(title: weekdays[5]),
                  TabCard(title: weekdays[6]),
                ]),
            if (isLoading) ...[
              const SizedBox(height: 200),
              const CircularProgressIndicator(
                color: AppColors.secondaryColor,
                strokeWidth: 2.0,
              ),
            ] else if (errorMessage != null) ...[
              CustomErrorWidget(onRefresh: refreshData, messgae: "error_text".tr(context))
            ]
          ]),
        )),
      );
    } else {
      var width = MediaQuery.of(context).size.width; // width of the screen
      var height = MediaQuery.of(context).size.height; // height of the screen

      double paddingFllowing;
      width > 350 ? paddingFllowing = 20 : paddingFllowing = 10;

      List months = ['Jan'.tr(context), 'Feb'.tr(context), 'Mar'.tr(context), 'April'.tr(context), 'May'.tr(context), 'Jun'.tr(context), 'July'.tr(context), 'Aug'.tr(context), 'Sep'.tr(context), 'Oct'.tr(context), 'Nov'.tr(context), 'Dec'.tr(context)];

      var date1 = Provider.of<PlanProvider>(context, listen: false).getplan().days[0].date;
      String day1 = DateFormat('dd').format(date1);
      var date2 = Provider.of<PlanProvider>(context, listen: false).getplan().days[6].date;
      String day2 = DateFormat('dd').format(date2);

      var endWeekDateDay = int.parse(day2);
      var beginWeekDateDay = int.parse(day1);
      var month = date1.month;
      var mon = months[month - 1];
      var weekdays = [];
      var days = Provider.of<PlanProvider>(context, listen: false).getplan().days;
      for (var element in days) {
        String dayName = DateFormat('EEEE').format(element.date);
        String translatedDayName = translateDay(dayName.toUpperCase(), Provider.of<SelectedContentLanguage>(context, listen: false).locale.languageCode);
        if (Provider.of<SelectedContentLanguage>(context, listen: false).locale.languageCode == "ar") {
          weekdays.add(translatedDayName.substring(2));
        } else {
          weekdays.add(translatedDayName.substring(0, 1).toUpperCase() + translatedDayName.substring(1, 3).toLowerCase());
        }
      }

      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: AppColors.primaryColor,
            titleSpacing: 0,
            leading: IconButton(
              icon: const Icon(
                Ionicons.arrow_back,
                color: Colors.black,
                size: 25,
              ),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
              },
            ),
            centerTitle: true,
            title: InkWell(
              onTap: () async {
                DateTime? date = await showDatePicker(
                    context: context,
                    helpText: "Change the date of your plan then confirm it .",
                    confirmText: "CONFIRM",
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2050),
                    currentDate: DateTime.now(),
                    initialEntryMode: DatePickerEntryMode.calendar,
                    initialDatePickerMode: DatePickerMode.day,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.fromSwatch(
                          primarySwatch: Colors.blueGrey,
                          accentColor: Colors.blueGrey,
                          backgroundColor: Colors.lightBlue,
                          cardColor: Colors.white,
                        )),
                        child: child!,
                      );
                    });

                var result = await PlanService.changePlanDate(Provider.of<PlanProvider>(context, listen: false).getplan().id!, date.toString().split(' ').first);
                if (result) {
                  PlanApi plan = await PlanService.retrievePlanById(Provider.of<PlanProvider>(context, listen: false).getplan().id!);
                  Provider.of<PlanProvider>(context, listen: false).setPlan(plan);
                  setState(() {});
                }
              },
              child: Text('$mon $beginWeekDateDay - $endWeekDateDay', style: TextStyle(fontSize: 20.sp, color: Colors.black), textAlign: TextAlign.center),
            ),
          ),
          body: Container(
              color: AppColors.primaryColor,
              child: Column(children: [
              TabBar(
                  tabAlignment: TabAlignment.center,
                  dividerColor: Colors.white,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  indicator: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorWeight: 0,
                  automaticIndicatorColorAdjustment: false,
                  isScrollable: true,
                  splashBorderRadius: BorderRadius.circular(20),
                  labelColor: AppColors.primaryColor,
                  controller: _tabController,
                  unselectedLabelColor: const Color.fromARGB(255, 0, 0, 0),
                  onTap: (value) {
                    if (mounted) setState(() {});

                    Provider.of<indexTabBarPlan>(context, listen: false).setIndex(value);
                  },
                  tabs: [
                    TabCard(title: weekdays[0]),
                    TabCard(title: weekdays[1]),
                    TabCard(title: weekdays[2]),
                    TabCard(title: weekdays[3]),
                    TabCard(title: weekdays[4]),
                    TabCard(title: weekdays[5]),
                    TabCard(title: weekdays[6]),
                  ]),
              if (isLoading) ...[
                const SizedBox(height: 200),
                const CircularProgressIndicator(
                  color: AppColors.secondaryColor,
                  strokeWidth: 2.0,
                ),
              ] else if (errorMessage != null) ...[
                CustomErrorWidget(onRefresh: refreshData, messgae: "error_text".tr(context))
              ] else ...[
                Container(
                  color: AppColors.primaryColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: paddingFllowing),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: width / 2.3,
                              child: GestureDetector(
                                onLongPress: () {
                                  setState(() {
                                    lockTextField = true;
                                  });
                                },
                                child: TextFormField(
                                  initialValue: Provider.of<PlanProvider>(context, listen: false).getplan().name,
                                  enabled: lockTextField,
                                  decoration: InputDecoration(
                                    hintText: 'Enter plan name'.tr(context),
                                            hintStyle:  TextStyle(
                                              color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.w500,
                                              fontSize: 18.sp,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                          style:  TextStyle(
                                            color: const Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w500,
                                            fontSize: 18.sp,
                                  ),
                                  onChanged: (value) {
                                    // update the plan name in the provider here
                                  },
                                  onFieldSubmitted: (value) {
                                    PlanApi plan = Provider.of<PlanProvider>(context, listen: false).getplan();

                                    PlanService.renamePlan(value, plan.id);
                                    Provider.of<PlanProvider>(context, listen: false).setPlanName(value);
                                    setState(() {
                                      lockTextField = false;
                                    });
                                  },
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (mounted) {
                                  if (isFollowing!) {
                                    //followed is already clicked
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                  child: Text(
                                                "Follow this Plan?".tr(context),
                                                textAlign: TextAlign.center,
                                                            style:  TextStyle(fontSize: 17.sp,fontWeight: FontWeight.bold),
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
                                                child: Text(
                                                          "By confirming this action the grocery list will be replaced by a new one and your purchased ingredients will be lost."
                                                              .tr(context),
                                                          textAlign: TextAlign.center,style:  TextStyle(fontSize: 16.sp),
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
                                                        Navigator.of(context, rootNavigator: true).pop();
                                                      },
                                                      style: ButtonStyle(
                                                          shape: MaterialStateProperty.all<OutlinedBorder>(
                                                        const RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.zero,
                                                        ),
                                                      )),
                                                      child: Text(
                                                        "Cancel".tr(context),
                                                                style:  TextStyle(
                                                                    fontSize: 16.sp,
                                                                    color: AppColors.textColor),
                                                      )),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  TextButton(
                                                      //         onPressed:
                                                      onPressed: () async {
                                                        int? idPlan = Provider.of<PlanProvider>(context, listen: false).getplan().id;
                                                        PlanService.followPlan(idPlan);
                                                        // update the plan provider :
                                                        PlanApi planApi = await PlanService.retrievePlanById(idPlan!);
                                                        Provider.of<PlanProvider>(context, listen: false).setPlan(planApi);
                                                        if (mounted) {
                                                          setState(() {
                                                            isFollowing = true;
                                                          });
                                                        }
                                                        Navigator.of(context, rootNavigator: true).pop();
                                                      },
                                                      style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(AppColors.buttonTextColor),
                                                          shape: MaterialStateProperty.all<OutlinedBorder>(
                                                            const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.zero,
                                                            ),
                                                                  )
                                                              ),
                                                              child:  Text(
                                                        "Confirm",
                                                                style: TextStyle(
                                                                    fontSize: 16.sp,
                                                                    color:AppColors.primaryColor),
                                                      ))
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 100,
                                height: 37,
                                decoration: BoxDecoration(
                                  border: !isFollowing! ? Border.all(color: const Color(0XFF7EACAB), width: 1.0) : null,
                                  color: isFollowing! ? const Color(0XFF7EACAB) : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  isFollowing! ? "Followed".tr(context) : "Follow".tr(context),
                                  style: TextStyle(
                                    color: isFollowing! ? Colors.white : const Color(0XFF7EACAB),
                                    fontWeight: FontWeight.w600,
                                            fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 10, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              height: 35,
                              decoration: BoxDecoration(
                                color: const Color(0XFFF2F2F2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                const Icon(
                                  Ionicons.flame_outline,
                                  color: Colors.orange,
                                  size: 18,
                                ),
                                CaloriesNeeds(
                                  calorieNeeds: Provider.of<PlanProvider>(context, listen: false).getplan().calories,
                                  calcumClaories: calcumClaories(),
                                )
                              ]),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(controller: _tabController, children: const [
                    Listmealsperday(
                      idday: 0,
                    ),
                    Listmealsperday(
                      idday: 1,
                    ),
                    Listmealsperday(
                      idday: 2,
                    ),
                    Listmealsperday(
                      idday: 3,
                    ),
                    Listmealsperday(
                      idday: 4,
                    ),
                    Listmealsperday(
                      idday: 5,
                    ),
                    Listmealsperday(
                      idday: 6,
                    )
                  ]),
                ),
              ],
            ]),
          ));
    }
  }
}
