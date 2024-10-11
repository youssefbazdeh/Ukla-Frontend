import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/components/custom_circular_progress_indicator.dart';
import 'package:ukla_app/core/Presentation/components/snack_bar.dart';
import 'package:ukla_app/features/groceries/Presentation/bloc/grocery_bloc.dart';
import 'package:ukla_app/features/groceries/Presentation/bloc/grocery_state.dart';
import 'package:ukla_app/features/groceries/Presentation/widgets/grocery_list_widget.dart';
import 'package:ukla_app/main.dart';
import '../../../../injection_container.dart';
import '../../../core/Presentation/components/custom_error_widget.dart';
import '../../ads/Domain/usecases/ingredient_ad_service.dart';
import 'bloc/grocery_event.dart';

class GroceryByPlan extends StatefulWidget {
  const GroceryByPlan({Key? key,}) : super(key: key);

  @override
  State<GroceryByPlan> createState() => _GroceryByPlanState();
}

class _GroceryByPlanState extends State<GroceryByPlan> {
  final GroceryBloc bloc = sl<GroceryBloc>();
  var loadedListLength = 0;


  @override
  void initState() {
    bloc.add(LoadGroceryList(Provider.of<SelectedContentLanguage>(context, listen: false).contentLanguageCode));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var viewedIngredientAdIdsProvider = Provider.of<ViewedIngredientAdIdsProvider>(context);

    return WillPopScope(
        onWillPop: () async {
          if (viewedIngredientAdIdsProvider.viewedIngredientAdIds.isNotEmpty) {
            incrementIngredientAdViewCount(viewedIngredientAdIdsProvider.viewedIngredientAdIds);
            viewedIngredientAdIdsProvider.clearViewedIngredientAdIds();
          }
          return true;
        },
      child: Scaffold(
        body: BlocProvider.value(
          value: bloc,
        child: BlocConsumer<GroceryBloc,GroceryState>(
          listener: (context,state){
            if(state is GroceryListLoaded || state is GroceryListPurchaseIngredient || state is GroceryUnpurchaseIngredient || state is GroceryDeleteIngredient){
              setState(() {});
            }
            if (state is GroceryUndoPurchase) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                var snackbar = CustomSnackBar(message: "failed to purchase".tr(context) + state.ingredientName);
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              });
            }
            if (state is GroceryUndoUnPurchase) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                var snackbar = CustomSnackBar(message: "failed to unpurchase".tr(context) + state.ingredientName);
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              });
            }
              if (state is GroceryListLoaded) {
                loadedListLength = state.groceryList.groceryDays!.fold(0, (sum, day) => sum + (day.recipes?.length ?? 0));
              Provider.of<GroceryListLengthState>(context, listen: false).setLoadedListLength(loadedListLength); // Update the state
              }
            if(state is GroceryUndoDeleteIngredient){
              SchedulerBinding.instance.addPostFrameCallback((_) {
                var snackbar = CustomSnackBar(message: "failed to delete".tr(context) + state.ingredientName);
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              });
            }
            if (state is GroceryUndoDeleteAllIngredient) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                var snackbar = CustomSnackBar(message: "failed to delete ingredients".tr(context));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              });
            }
          },
            builder: (context,state) {
                return SafeArea(
              child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (state is GroceryListLoaded)...[GroceryListWidget(groceryList: state.groceryList, bloc: bloc,byCategory: false)]
                                  else if (state is GroceryListPurchaseIngredient)...[GroceryListWidget(groceryList: state.groceryList, bloc: bloc,byCategory: false)]
                                  else if (state is GroceryUndoPurchase)...[GroceryListWidget(groceryList: state.groceryList, bloc: bloc,byCategory: false)]
                                  else if (state is GroceryUndoUnPurchase)...[GroceryListWidget(groceryList: state.groceryList, bloc: bloc,byCategory: false)]
                                  else if (state is GroceryUnpurchaseIngredient)...[GroceryListWidget(groceryList: state.groceryList, bloc: bloc,byCategory: false)]
                                  else if (state is GroceryDeleteIngredient)...[GroceryListWidget(groceryList: state.groceryList, bloc: bloc,byCategory: false)]
                                  else if (state is GroceryUndoDeleteIngredient)...[GroceryListWidget(groceryList: state.groceryList, bloc: bloc,byCategory: false)]
                                  else if (state is GroceryUndoDeleteAllIngredient)...[GroceryListWidget(groceryList: state.groceryList, bloc: bloc,byCategory: false)]
                                  else if (state is ServerError)...[
                                    if(state.statusCode == 404) ... [
                                      const Center(child: Text("add recipes to plan to generate the groceries list"))
                                    ]else if (state.statusCode == 500)...[
                                       Center(
                                           child:CustomErrorWidget(
                                             onRefresh: () {
                                               bloc.add(LoadGroceryList(Provider.of<SelectedContentLanguage>(context, listen: false).contentLanguageCode));
                                             },
                                             messgae: "error_text".tr(context),
                                          ),
                                        ),
                                    ]
                                    ]
                                    else if (state is GroceryListLoading) ...[const Center(child: CustomCircularProgressIndicator())],
                    ],
                  ),
                              ),
            );
          },
        ),
      ),
      ),
    );
  }
}
