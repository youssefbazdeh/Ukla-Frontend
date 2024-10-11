import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Data/storage.dart';

enum Menu { itemOne, itemTwo, itemThree }

class SuggestedRecipeCard extends StatefulWidget {
  const SuggestedRecipeCard(
      {required this.mealTitle,
      required this.onPressed,
      required this.calories,
      required this.cookingtime,
      required this.image,
      required this.selectOrDeselect,
      required this.recipeInList,
      Key? key})
      : super(key: key);
  final String mealTitle;
  final GestureTapCallback onPressed;
  final int cookingtime;
  final int calories;
  final String image;
  final ValueChanged<bool> selectOrDeselect;
  final bool recipeInList;

  @override
  State<SuggestedRecipeCard> createState() => _SuggestedRecipeCardState();
}

class _SuggestedRecipeCardState extends State<SuggestedRecipeCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 120,
                  width: 100,
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
                                fit: BoxFit
                                    .cover, // set fit property to BoxFit.cover
                              );
                            } else {
                              return Container();
                            }
                          })),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.35,
                        child: Text(
                          widget.mealTitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style:  TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      // tags
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Ionicons.timer_outline, size: 13.0),
                              Text(
                                "${widget.cookingtime} " + "min".tr(context),
                                style:  TextStyle(fontSize: 15.sp),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Ionicons.flame_outline,
                                size: 13.0,
                                color: Color(0XFFFFA63E),
                              ),
                              Text(
                                "${widget.calories} " + "Cal".tr(context),
                                style:  TextStyle(fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
