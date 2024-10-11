import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/core/Data/storage.dart';
import 'package:ukla_app/core/Presentation/checkBox/check_boxes.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';

import '../../../../main.dart';
import '../../../view_recipe/Domain/Entities/tag.dart';
import '../../../view_recipe/Presentation/Widgets/tags_builder.dart';

enum Menu { itemOne, itemTwo, itemThree }

class SearchedRecipeCard extends StatefulWidget {
  const SearchedRecipeCard(
      {required this.recipeTitle,
      required this.onPressed,
      required this.calories,
      required this.cookingTime,
      required this.preparationTime,
      required this.image,
      required this.selectOrDeselect,
      required this.recipeInList,
      required this.tags,
      Key? key})
      : super(key: key);
  final String recipeTitle;
  final GestureTapCallback onPressed;
  final int cookingTime;
  final int preparationTime;
  final int calories;
  final String image;
  final ValueChanged<bool> selectOrDeselect;
  final bool recipeInList;
  final List<Tag> tags;

  @override
  State<SearchedRecipeCard> createState() => _SearchedRecipeCardState();
}

class _SearchedRecipeCardState extends State<SearchedRecipeCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    String? contentLanguageCode = Provider.of<SelectedContentLanguage>(context,listen: false).contentLanguageCode;
    final width = MediaQuery.of(context).size.width;

    double spacerRow;
    double widthValue;

    if (width < 360) {
      spacerRow = 10;
      widthValue = width / 2.5;
    } else {
      spacerRow = 20;
      widthValue = width / 2.25;
    }

    return InkWell(
        onTap: widget.onPressed,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: 135,
                width: width / 1.1,
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
                      height: 135,
                      width: 120,
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
                                      'authorization':
                                          'Bearer ${snapshot.data}',
                                    },
                                    fit: BoxFit.cover,
                                  );
                                } else {
                                  return const CircularProgressIndicator(
                                    color: AppColors.secondaryColor,
                                    strokeWidth: 2.0,
                                  );
                                }
                              })),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: widthValue,
                                child: Text(
                                  widget.recipeTitle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style:  TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Column(
                                  children: [
                                    CustomCheckBox(
                                      size: 20,
                                      raduisBorder: 3,
                                      isSelected: widget
                                          .recipeInList, // default value of the check box
                                      isChecked: (value) {
                                        widget.selectOrDeselect(
                                            value); // isChecked is a onValue function when the checkbox is checked or unchecked
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          tagsBuilder(widget.tags,contentLanguageCode),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Ionicons.timer_outline, size: 15.0),
                                const SizedBox(width: 2),
                                Text(
                                  "${widget.cookingTime + widget.preparationTime} min",
                                  style:  TextStyle(fontSize: 15.sp),
                                ),
                            
                                SizedBox(
                                  width: spacerRow,
                                ),
                                const Icon(
                                  Ionicons.flame_outline,
                                  size: 15.0,
                                  color: Color(0XFFFFA63E),
                                ),
                                Text(
                                  "${widget.calories} Cal",
                                  style:  TextStyle(fontSize: 15.sp),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //const Spacer(),
                  ],
                ),
              ),
            ])));
  }
}
