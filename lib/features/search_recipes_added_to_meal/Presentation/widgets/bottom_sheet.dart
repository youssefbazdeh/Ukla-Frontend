import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/analytics/events.dart';
import 'package:ukla_app/features/plan_Management/Domain/Entity/Plan.dart';
import 'package:ukla_app/main.dart';

import '../../../view_recipe/Domain/Entities/recipe.dart';
import '../../Data/recipes_services.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget(
      {required this.recipelist, required this.isRemoved, Key? key})
      : super(key: key);
  final List<Recipe> recipelist;
  final ValueChanged<bool> isRemoved;

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {

  @override
  Widget build(BuildContext context) {
    double lengthdrag;
    double lengthMaxSize;
    var lengthlist = widget.recipelist.length;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    bool pop = false;

    if (lengthlist == 1) {
      lengthdrag = 0.2;
      lengthMaxSize = 0.2;
    }else if (lengthlist == 0){
      lengthdrag = 0;
      lengthMaxSize = 0;
    } else if (lengthlist == 2 || lengthlist == 3){
      lengthdrag = 0.2 + 0.12 * (widget.recipelist.length - 1);
      lengthMaxSize = 0.2 + 0.12 * (widget.recipelist.length - 1);
    }else {
      lengthdrag = 0.5 ;
      lengthMaxSize = 0.5;
    }

      return WillPopScope(
        onWillPop: () async {
          Provider.of<SelectedReceipe>(context, listen: false).clearList();
          return true;
        },
        child: DraggableScrollableSheet(
          expand: false,
          snap: true,
          initialChildSize: lengthdrag,
          minChildSize: 0,
          maxChildSize: lengthMaxSize,
          builder: (BuildContext context, ScrollController scrollController) {
            return GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  // Dragging down
                  scrollController.position.setPixels(
                      scrollController.position.pixels - details.delta.dy);
                } else {
                  // Dragging up
                  if (scrollController.position.pixels == 0) {
                    // Enable scrolling only if the sheet is at the top
                    scrollController.position.setPixels(
                        scrollController.position.pixels - details.delta.dy);
                  }
                }
              },
              child: SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  decoration: const BoxDecoration(
                      color: AppColors.bottomSheetBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30))),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 20,
                                child: Row(
                                  children: [
                                    Padding(
                                        padding:
                                        const EdgeInsets.only(left: 20, top: 5),
                                        child: Text(
                                          widget.recipelist.length == 1?
                                          "${widget.recipelist.length} " + "selected_recipe".tr(context) :
                                          "${widget.recipelist.length} " + "recipes_selected".tr(context),
                                          style:  TextStyle(fontSize: 20.sp),
                                        )

                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                             RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8), // This makes the corners square
                                            ),
                                          ),
                                          backgroundColor: MaterialStateProperty.all(AppColors.secondaryColor),
                                        ),
                                        onPressed: () async {
                                          int indexDay = Provider.of<indexTabBarPlan>(context, listen: false).getIndex();
                                          int indexMeal2 = Provider.of<indexMeal>(context, listen: false).getIndex();
                                          List<Recipe> recipesInMeal = Provider.of<PlanProvider>(context, listen: false).getplan().days[indexDay].meals![indexMeal2].recipes;
                                          Set<int> addedRecipeIds = recipesInMeal.map((r) => r.id!).toSet();

                                          for (var recipe in widget.recipelist) {
                                            if (addedRecipeIds.contains(recipe.id)) {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title:  RichText(
                                                      text: TextSpan(
                                                        children:  [
                                                          ...widget.recipelist.where((recipe) => addedRecipeIds.contains(recipe.id)).map((recipe) {
                                                            return TextSpan(text: "${recipe.name}\n", style:  TextStyle(color: Colors.black, fontSize: 20.sp));
                                                          }).toList(),
                                                          TextSpan(text: "recipeAlreadyExistsTitle".tr(context), style:  TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 20.sp))
                                                        ]
                                                      ),
                                                    ),
                                                    content: Text("recipeAlreadyExistsContent".tr(context)),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text("okButton".tr(context)),
                                                        onPressed: () {
                                                          for (int i = widget.recipelist.length - 1; i >= 0; i--) {
                                                            widget.recipelist.removeAt(i);
                                                            widget.isRemoved(true);
                                                          }
                                                          setState(() {});
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              break;
                                            } else {
                                              setState(() {
                                                pop = true;
                                              });
                                              await ServicesRecipes.addRecipeToMeal(Provider.of<PlanProvider>(context, listen: false).getplan().days[indexDay].meals![indexMeal2].id!, recipe.id!);
                                              PlanApi plan = Provider.of<PlanProvider>(context, listen: false).getplan();
                                              plan.days[indexDay].meals![indexMeal2].recipes.add(recipe);
                                              Provider.of<PlanProvider>(context,listen:false).setPlan(plan);
                                              FireBaseAnalyticsEvents.screenViewed('Plan_of_week');

                                            }
                                          }
                                          if(pop){
                                            int count = 0;
                                            Navigator.popUntil(context, (_) => count++ >= 2);
                                            Provider.of<SelectedReceipe>(context, listen: false).clearList();
                                          }
                                        },
                                        child: Text(
                                          "add".tr(context),
                                          style:  TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height:  widget.recipelist.length * 70,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.recipelist.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Row(
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.of(context).size.width *
                                              0.85,
                                          height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: width / 7,
                                                height: height / 3,
                                                child: ClipRRect(
                                                    child: Image.network(
                                                      "${AppString.SERVER_IP}/ukla/file-system/image/${widget.recipelist[widget.recipelist.length - (index + 1)].image.id}",
                                                      fit: BoxFit.fill,
                                                    )),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                  flex: 3,
                                                  child: Text(widget
                                                      .recipelist[
                                                  widget.recipelist.length -
                                                      (index + 1)]
                                                      .name)),
                                              const Spacer(),
                                              InkWell(
                                                  onTap: () {
                                                    if (mounted) setState(() {});
                                                  widget.recipelist.remove(widget
                                                      .recipelist[
                                                  widget.recipelist.length -
                                                      (index + 1)]);
                                                    widget.isRemoved(true);

                                                    setState(() {});
                                                  },
                                                  child: const Icon(Ionicons
                                                      .close_circle_outline)),
                                            ],
                                          )),
                                      // Checkbox(value: false, onChanged: (value) {}),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );


  }

  bool get wantKeepAlive => true;
}
