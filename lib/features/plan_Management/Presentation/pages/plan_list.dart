import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/components/custom_error_widget.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/Presentation/titles/inputTitle.dart';
import 'package:ukla_app/features/plan_Management/Presentation/widgets/delete_plan_dialog.dart';
import '../../../../core/analytics/events.dart';
import '../../Domain/Use_Case/PlanService.dart';
import 'package:ukla_app/main.dart';
import '../../Domain/Entity/Plan.dart';
import '../../Domain/Entity/PlanModel.dart';
import 'already_created_plan.dart';

class PlanList extends StatefulWidget {
  const PlanList({Key? key}) : super(key: key);
  @override
  State<PlanList> createState() => _PlanListState();
}

class _PlanListState extends State<PlanList> {
  List<PlanApi> planList = [];
  List<Plan>? selectedList;
  bool showCustomErrorWidget = false;
  static const _pageSize = 7;
  int page = 1;
  bool hasMore = true;
  int numItems = 0;
  final controller = ScrollController();

  @override
  void initState() {
    fetch();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void setstate() {
    if (mounted) setState(() {});
  }

  Future fetch() async {
    try {
      var localPlanList = await PlanService.getAll(page, _pageSize);
      setState(() {
        planList.addAll(localPlanList);
        page++;
        numItems = planList.length;
        if (localPlanList.length < _pageSize) {
          hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        showCustomErrorWidget = true;
      });
    }
  }

  createplan() async {
    PlanApi planOfWeek = await PlanService.createPlan(
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString());
    return planOfWeek;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    void loadList() async {
      setState(() {
        page = 1;
        hasMore = true;
        planList.clear();
        showCustomErrorWidget = false;
      });
      fetch();

      if (mounted) setState(() {});
    }

    return SafeArea(
      child: Material(
        child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: inputTitle(
                    AppLocalizations.of(context)!.translate("my_plans")),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate("created_plans"),
                      textAlign: TextAlign.center,
                        style:  TextStyle(
                          fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "$numItems  ",
                          textAlign: TextAlign.center,
                            style:  TextStyle(
                              fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        Text(
                          "plans".tr(context),
                          textAlign: TextAlign.center,
                            style:  TextStyle(
                              fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (showCustomErrorWidget) ...[
                CustomErrorWidget(onRefresh: loadList, messgae: "error_text".tr(context))
              ] else ...[
                SizedBox(
                  height: height / 1.8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: planList.length + 1,
                        controller: controller,
                        itemBuilder: (context, int index) {
                          if (planList.isNotEmpty && index < planList.length) {
                            return InkWell(
                              onTap: () async {
                                int? planid = planList[index].id;
                                FireBaseAnalyticsEvents.screenViewed('Plan_of_week');
                                Provider.of<indexTabBarPlan>(context, listen: false).setIndex(getCurrentDayIndex(planList[index]));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AlreadyCreatedPlan(
                                          index: Provider.of<indexTabBarPlan>(context, listen: false).index,
                                          plandId: planid,
                                          fromPlanList: true,
                                        )));
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, right: 20, left: 20, bottom: 10),
                                    child: Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            width: 0.7,
                                            color: AppColors.borderPlanList),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    height: 50,
                                                    width: width / 3.5,
                                                    child: TextFormField(
                                                      // controller: PlanController,
                                                      // textAlignVertical: TextAlignVertical.top,
                                                        textAlign: TextAlign.start,
                                                        autofocus: false,
                                                        // focusNode: myFocusNode,
                                                        //readOnly: true,
                                                        enabled: false,
                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                          focusedBorder:
                                                          InputBorder.none,
                                                          enabledBorder:
                                                          InputBorder.none,
                                                          errorBorder:
                                                          InputBorder.none,
                                                          disabledBorder:
                                                          InputBorder.none,
                                                          floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .never,
                                                          labelText:
                                                          (planList[index].name),
                                                          hintText:
                                                          (planList[index].name),
                                                          labelStyle: const TextStyle(
                                                              color: Color.fromARGB(
                                                                  255, 0, 0, 0)),
                                                        )),
                                                  ),
                                                  if (planList[index].followed!)
                                                    Container(
                                                      alignment: Alignment.center,
                                                      width: 85,
                                                      //height: 45,
                                                      padding:
                                                      const EdgeInsets.all(3),
                                                      decoration: BoxDecoration(
                                                        color:
                                                        const Color(0XFF7EACAB),
                                                        borderRadius:
                                                        BorderRadius.circular(10),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "Followed".tr(context),
                                                              style:  TextStyle(
                                                              color: Colors.white,
                                                              fontWeight:
                                                              FontWeight.w400,
                                                                fontSize: 16.sp,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 8, right: 8),
                                                  child: Row(
                                                    children: [
                                                      const SizedBox(width: 3),
                                                      GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) =>
                                                                  DeletePlanDialog(
                                                                    planId: planList[index].id!,
                                                                    onDeleteSuccess: loadList,
                                                                  ),
                                                            );
                                                          },
                                                          child: const Icon(
                                                            Ionicons
                                                                .close_circle_outline,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: hasMore
                                      ? const CircularProgressIndicator(color: AppColors.secondaryColor, strokeWidth: 2.0,)
                                      : const SizedBox(
                                    height: 5,
                                  )),
                            );
                          }
                        }),
                  ),
                ),
                const SizedBox(height: 23),
                SizedBox(
                  height: 45,
                  width: width / 1.8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFFFA6375),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () async {
                      Future<PlanApi> getPlan() async {
                        return PlanService.createPlan(DateFormat('yyyy-MM-dd')
                            .format(DateTime.now())
                            .toString());
                      }

                      PlanApi plann = await getPlan();
                      setState(() {
                        planList.add(plann);
                      });
                      Provider.of<PlanProvider>(context, listen: false).setPlan(plann);
                      FireBaseAnalyticsEvents.screenViewed('Plan_of_week');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AlreadyCreatedPlan(
                                index: getCurrentDayIndex(plann),
                                fromPlanList: true,
                              )));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .translate("create_plan")
                              .capitalize(),
                            style:  TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: 20.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(Ionicons.add_circle, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ]

            ]),
      ),
    );
  }
}


