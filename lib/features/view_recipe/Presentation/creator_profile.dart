import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Data/storage.dart';
import 'package:ukla_app/core/Presentation/components/custom_error_widget.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/features/view_recipe/Data/creator_service.dart';
import 'package:ukla_app/features/view_recipe/Domain/Entities/creator.dart';
import 'package:ukla_app/features/view_recipe/Domain/Entities/recipe.dart';
import 'package:ukla_app/features/view_recipe/Presentation/Widgets/creator_recipe_card.dart';

class CreatorProfile extends StatefulWidget {
  final int creatorId;
  const CreatorProfile({
    Key? key,
    required this.creatorId,
  }) : super(key: key);

  @override
  State<CreatorProfile> createState() => _CreatorProfileState();
}

class _CreatorProfileState extends State<CreatorProfile> {
  late Future<Creator> futureCreator;
  bool? isFollowed;
  int followersNumber = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    setState(() {
      futureCreator = CreatorService().getCreatorById(widget.creatorId);
      futureCreator.then((creator){
        setState(() {
          isFollowed = creator.followed;
          followersNumber = creator.followersNumber!;
        });
      });
    });
  }

  void toggleFollowStatus() async {
    if (isFollowed != null) {
      if (isFollowed!) {
        await CreatorService().unFollowCreator(widget.creatorId);
        setState(() {
          followersNumber -= 1;
        });
      } else {
        await CreatorService().followCreator(widget.creatorId);
        setState(() {
          followersNumber += 1;
        });
      }
      setState(() {
        isFollowed = !isFollowed!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: futureCreator,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.secondaryColor,
                  strokeWidth: 2.0,
                ),
              );
            } else if (snapshot.hasData) {
              Creator creator = snapshot.data as Creator;
              if (isFollowed == null) {
                isFollowed = creator.followed;
              }
              List<Recipe> creatorRecipes = creator.createdRecipe!;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 0.5.sh, // Use .sh for height based on screen size
                    pinned: true,
                    flexibleSpace: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        var top = constraints.biggest.height;
                        return FlexibleSpaceBar(
                          title: AnimatedOpacity(
                            duration: const Duration(milliseconds: 50),
                            opacity: top <= 110 ? 1.0 : 0.0,
                            child: Text(
                              creator.firstname + " " + creator.lastname,
                              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: AppColors.textColor),
                            ),
                          ),
                          background: Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: 0.25.sh, // Use .sh for height based on screen size
                                    width: 1.sw, // Use .sw for width based on screen size
                                    decoration: const BoxDecoration(
                                      color: AppColors.secondaryColor,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 50.h),
                                      child: Text(
                                        creator.description,
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 16.sp,
                                          height: 1.5.h,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -70.h,
                                    left: 0.5.sw - 60.w,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 5.0.w,
                                        ),
                                      ),
                                      child: FutureBuilder(
                                        future: getjwt(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return CircleAvatar(
                                              radius: 60.r,
                                              backgroundColor: Colors.transparent,
                                              child: ClipOval(
                                                child: Container(
                                                  width: 140.w,
                                                  height: 140.h,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        "${AppString.SERVER_IP}/ukla/file-system/image/${creator.image!.id}",
                                                        headers: {
                                                          'authorization': 'Bearer ${snapshot.data}',
                                                        },
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return CircularProgressIndicator(
                                              color: AppColors.secondaryColor,
                                              strokeWidth: 2.0.w,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 70.h),
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 50),
                                opacity: top > 110 ? 1.0 : 0.0,
                                child: Text(
                                  creator.firstname + " " + creator.lastname,
                                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: AppColors.textColor),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        followersNumber.toString(),
                                        style: TextStyle(
                                          fontSize: 36.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("Followers", style: TextStyle(fontSize: 10.sp)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50.h,
                                    child: const VerticalDivider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        creatorRecipes.length.toString(),
                                        style: TextStyle(
                                          fontSize: 36.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("Recipes", style: TextStyle(fontSize: 10.sp)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.34.sw),
                        child: ElevatedButton(
                          onPressed: () {
                            toggleFollowStatus();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFollowed! ? AppColors.primaryColor : AppColors.followButtonColor,
                            foregroundColor: isFollowed! ? AppColors.followButtonColor : Colors.white,
                            side: isFollowed! ? BorderSide(color: AppColors.followButtonColor) : BorderSide.none,
                            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isFollowed! ? Ionicons.person_remove : Ionicons.person_add_sharp,
                                size: 15.sp,
                                color: isFollowed! ? AppColors.followButtonColor : Colors.white,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                isFollowed! ? "Unfollow" : "Follow",
                                style: TextStyle(fontSize: 14.sp, color: isFollowed! ? AppColors.followButtonColor : Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ...creatorRecipes.map((recipe) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: CreatorRecipeCard(
                            recipeId: recipe.id!,
                            title: recipe.name,
                            isFavorite: recipe.recipeInUserFavorites!,
                            calories: recipe.nbrCalories.toInt(),
                            cookingTime: recipe.cookingTime,
                            prepTime: recipe.preparationTime,
                            imageId: recipe.image.id,
                            tagsList: recipe.tags,
                          ),
                        );
                      }).toList(),
                    ]),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  SizedBox(height: 100.h),
                  Center(
                    child: CustomErrorWidget(onRefresh: loadData, messgae: "error_text".tr(context)),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
