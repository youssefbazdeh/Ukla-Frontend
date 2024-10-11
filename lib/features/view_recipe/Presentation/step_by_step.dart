import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/features/view_recipe/Presentation/one_recipe_interface.dart';
import '../../../core/Presentation/components/tranlatedIngredientQuantityObject.dart';
import '../../../main.dart';
import '../../ads/Presentation/banner_ad_custom_widget.dart';
import '../../ads/Domain/usecases/ingredient_ad_service.dart';
import '../Domain/Entities/recipe.dart';
import 'Widgets/cooking_tip.dart';
import 'Widgets/step_by_step_top_bar.dart';

class StepByStep extends StatefulWidget {
  final Recipe recipe;
  const StepByStep({Key? key, required this.recipe}) : super(key: key);

  @override
  State<StepByStep> createState() => _StepByStepState();
}

EdgeInsetsGeometry titlePadding = const EdgeInsets.only(left: 12);
EdgeInsetsGeometry descrTip = const EdgeInsets.symmetric(horizontal: 11);
Color primary = const Color(0xFFFA6375);

class _StepByStepState extends State<StepByStep> {
  String? contentLanguageCode;
  PageController stepPageController = PageController(initialPage: 0);
  StepByStepPageChanged pageNumber = StepByStepPageChanged(1);
  @override
  void initState() {
    super.initState();
    pageNumber.addListener(() {});
    setState(() {
      _fetchContentLanguageCode();
    });
  }

  Future<void> _fetchContentLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('contentLanguageCode');
    setState(() {
      contentLanguageCode = code;
    });
  }

  bool shouldShowAd() {
    final adDisplayCount = Provider.of<AdDisplayCountModel>(context, listen: false).countForSteps;
    return (adDisplayCount % 3) == 0;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    return WillPopScope(
      onWillPop: () async {
        incrementIngredientAdViewCount(Provider.of<ViewedIngredientAdProvider>(context,listen: false).idsList);
        Provider.of<ViewedIngredientAdProvider>(context,listen: false).idsList.clear();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OneRecipeInterface()));
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight:
              orientation == Orientation.landscape ? 30 : kToolbarHeight,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: ValueListenableBuilder(
            builder: (context, value, child) {
              return Text(
                "Step".tr(context) + " $value/${widget.recipe.steps.length}",
                style: TextStyle(
                    color: primary,
                  fontSize: orientation == Orientation.portrait ? 20.sp : 15.sp,
                    fontWeight: FontWeight.bold),
              );
            },
            valueListenable: pageNumber,
          ),
          leading: IconButton(
              onPressed: () {
                incrementIngredientAdViewCount(Provider.of<ViewedIngredientAdProvider>(context,listen: false).idsList);
                Provider.of<ViewedIngredientAdProvider>(context,listen: false).idsList.clear();
                Navigator.pop(context);
              },
              icon: const Icon(
                Ionicons.arrow_back,
                color: Colors.black,
              )),
        ),
        body: Column(
          children: [
            ValueListenableBuilder(
              builder: (context, value, child) {
                return topBarStepByStep(
                    widget.recipe.steps.length, pageNumber.value);
              },
              valueListenable: pageNumber,
            ),
            const SizedBox(
              height: 2,
            ),
            Expanded(
                child: PageView.builder(
                    onPageChanged: (int newValue) {
                      pageNumber.setPage(newValue + 1);
                    },
                    itemCount: widget.recipe.steps.length,
                    controller: stepPageController,
                    itemBuilder: ((context, index) {
                      return SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Center(
                              child:BannerAdCustomWidget(videoUrl: widget.recipe.steps[index].video!.sasUrl!,height: height,shouldShow: shouldShowAd()),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: descrTip,
                                child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                        widget.recipe.steps[index]
                                            .instruction,
                                        style: descriptionStepsStyle),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: const Color(0x80F6F6F6))),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: descrTip,
                                child: CookingTip(
                                    cookingTip: widget.recipe.steps[index].tip),
                              ),
                              if(widget.recipe.steps[index].ingredientQuantityObjects.isEmpty)...[
                                Container()
                              ]else ...[
                                Padding(
                                  padding: titlePadding,
                                  child: Text(
                                    'Ingredients for this step'.tr(context),
                                  style:  TextStyle(
                                      fontSize: 16.sp, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TranlatedIngredientQuantityObject(recipe: widget.recipe,height: height,index: index,contentLanguageCode: contentLanguageCode)

                              ]
                            ]),
                      );
                    }))),

            //bottom buttons
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: orientation == Orientation.portrait ? 12 : 8),
              child: Row(
                children: [
                  SizedBox(
                    child: ValueListenableBuilder(
                        valueListenable: pageNumber,
                        builder: (context, value, child) {
                          return Visibility(
                            maintainAnimation: true,
                            visible: value == 1 ? false : true,
                            maintainSize: true,
                            maintainState: true,
                            child: OutlinedButton(
                                onPressed: () {
                                  stepPageController.previousPage(
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: BorderSide(color: primary),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  textStyle: TextStyle(
                                      fontSize:
                                          orientation == Orientation.portrait
                                            ? 16.sp
                                            : 14.sp),
                                ),
                                child: Text('Previous'.tr(context))),
                          );
                        }),
                  ),
                  const Spacer(),
                  SizedBox(
                    child: ValueListenableBuilder(
                        valueListenable: pageNumber,
                        builder: (context, value, child) {
                          return Visibility(
                            maintainAnimation: true,
                            visible: true,
                            maintainSize: true,
                            maintainState: true,
                            child: ElevatedButton(
                              onPressed: () async {
                                  if (value == widget.recipe.steps.length) {
                                    incrementIngredientAdViewCount(Provider.of<ViewedIngredientAdProvider>(context,listen: false).idsList);
                                    Provider.of<ViewedIngredientAdProvider>(context,listen: false).idsList.clear();
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => const OneRecipeInterface()));
                                  }
                                Provider.of<AdDisplayCountModel>(context, listen: false).incrementAndLoad(true);
                                  stepPageController.nextPage(
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  backgroundColor: primary,
                                  textStyle: TextStyle(
                                      fontSize:
                                          orientation == Orientation.portrait
                                            ? 16.sp
                                            : 14.sp),
                                ),
                                child: value != widget.recipe.steps.length
                                    ? Text('Next'.tr(context))
                                    : Text(('Finish'.tr(context)))),
                          );
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }



}

class StepByStepPageChanged extends ValueNotifier {
  StepByStepPageChanged(super.value);

  void setPage(int newPage) {
    value = newPage;
  }
}
