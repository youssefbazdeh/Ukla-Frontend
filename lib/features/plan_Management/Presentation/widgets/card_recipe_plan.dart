import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Data/storage.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/features/view_recipe/Domain/Entities/tag.dart';
import 'package:ukla_app/features/view_recipe/Presentation/Widgets/tags_builder.dart';

import '../../../../main.dart';

enum Menu { itemOne, itemTwo, itemThree }

class CardRecipePlan extends StatefulWidget {
  const CardRecipePlan(
      {required this.recipeTitle,
      required this.onPressed,
      required this.calories,
      required this.cookingtime,
      required this.image,
      required this.isChecked,
      required this.preparationTime,
      required this.tags,
      Key? key})
      : super(key: key);
  final String recipeTitle;
  final GestureTapCallback onPressed;
  final int cookingtime;
  final int calories;
  final String image;
  final ValueChanged<bool> isChecked;
  final int preparationTime;
  final List<Tag> tags;

  @override
  State<CardRecipePlan> createState() => _CardRecipePlanState();
}

class _CardRecipePlanState extends State<CardRecipePlan> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    String? contentLanguageCode = Provider.of<SelectedContentLanguage>(context,listen: false).contentLanguageCode;
    List<Tag> tags = [];
    for (var element in widget.tags) {
      tags.add(Tag(title: element.title));
    }

    final width = MediaQuery.of(context).size.width;
    var cross = CrossAxisAlignment.start;
    double leftdistance;

    if (width >= 600) {
      cross = CrossAxisAlignment.center;
      leftdistance = 20;
    } else if (width >= 360) {
      leftdistance = width / 20;
    } else {
      leftdistance = 10;
    }

    return InkWell(
      onTap: widget.onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: width / 1.18,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0, 2), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0XFFFDFDFD)),
              child: Row(
                children: [
                  Container(
                    height: width / 3,
                    width: width / 3,
                    decoration: const BoxDecoration(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FutureBuilder(
                          future: getjwt(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Image.network(
                                widget.image,
                                headers: {
                                  'authorization': 'Bearer ${snapshot.data}',
                                },
                                fit: BoxFit.cover,
                              );
                            } else {
                              return const CircularProgressIndicator(color: AppColors.secondaryColor, strokeWidth: 2.0,);
                            }
                          }),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 1, left: leftdistance),
                    child: Column(
                      crossAxisAlignment: cross,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: width * 0.35,
                              child: Text(
                                widget.recipeTitle,
                                overflow: TextOverflow.fade,
                                maxLines: 2,
                                style:  TextStyle(
                                    fontSize: 16.sp, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Column(
                              children: [
                                InkWell(
                                    onTap: () {
                                      widget.isChecked(true);

                                      setState(() {});
                                    },
                                    child: const Icon(
                                        Ionicons.close_circle_outline)),
                              ],
                            ),
                          ],
                        ),
                        tagsBuilder(tags,contentLanguageCode),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(Ionicons.timer_outline, size: 15.0),
                              const SizedBox(width: 2),
                              Text(
                                "${widget.cookingtime + widget.preparationTime}" +
                                    "min".tr(context),
                                style:  TextStyle(fontSize: 15.sp),
                              ),
                              SizedBox(
                                width: leftdistance,
                              ),
                              const Icon(Ionicons.flame_outline,
                                  size: 15.0, color: Color(0XFFFFA63E)),
                              Text(
                                "${widget.calories}" + "Cal".tr(context),
                                style:  TextStyle(fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
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
}
