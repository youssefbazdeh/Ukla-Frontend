import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Data/storage.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/features/view_recipe/Data/favorites_service.dart';
import 'package:ukla_app/features/view_recipe/Domain/Entities/tag.dart';
import 'package:ukla_app/features/view_recipe/Presentation/Widgets/tags_builder.dart';
import 'package:ukla_app/features/view_recipe/Presentation/heart_widget.dart';
import 'package:ukla_app/main.dart';

class CreatorRecipeCard extends StatelessWidget {
  final int recipeId;
  final int imageId;
  final String title;
  final List<Tag> tagsList;
  final int cookingTime;
  final int prepTime;
  final int calories;
  final bool isFavorite;

  const CreatorRecipeCard({
    Key? key,
    required this.recipeId,
    required this.imageId,
    required this.title,
    required this.tagsList,
    required this.cookingTime,
    required this.prepTime,
    required this.calories,
    required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? contentLanguageCode = Provider.of<SelectedContentLanguage>(context,listen: false).contentLanguageCode;
    final width = MediaQuery.of(context).size.width;
    List<Tag> tags = [];
    for (var element in tagsList) {
      tags.add(Tag(title: element.title));
    }
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
    return Padding(
       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.start,
         children: [
           Container(
             height: 140,
             width:  width / 1.12,
             decoration: BoxDecoration(
               boxShadow: const [
                 BoxShadow(
                   color: Color.fromRGBO(0, 0, 0, 0.25),
                   offset: Offset(0, 2), //(x,y)
                   blurRadius: 6.0,
                 )
               ],
             borderRadius: BorderRadius.circular(10),
             color: const Color(0XFFFDFDFD)
             ),
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
                               "${AppString.SERVER_IP}/ukla/file-system/image/$imageId",
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
                               title,
                               overflow: TextOverflow.fade,
                               maxLines: 2,
                               style:  TextStyle(
                                   fontSize: 16.sp, fontWeight: FontWeight.w500),
                             ),
                           ),
                           SizedBox(width: 30.w),
                           Column(
                             children: [
                               customHeartFavoris(
                                 isSelected: isFavorite,
                                 isChecked: (check) async {
                                   if (check) {
                                     await FavoritesServices.addRecipeToFavorites(recipeId);
                                   } else {
                                     await FavoritesServices.removeRecipeFromFavorites(recipeId);
                                   }
                                 },
                               ),
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
                               "${cookingTime + prepTime}" +
                                   "min".tr(context),
                               style:  TextStyle(fontSize: 15.sp),
                             ),
                             SizedBox(
                               width: leftdistance,
                             ),
                             const Icon(Ionicons.flame_outline,
                                 size: 15.0, color: Color(0XFFFFA63E)),
                             Text(
                               "$calories "+"Cal".tr(context),
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
           )
         ],
       ),
     );
  }
}