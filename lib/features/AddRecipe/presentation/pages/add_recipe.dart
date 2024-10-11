import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/core/Presentation/titles/inputTitle.dart';
import 'package:ukla_app/features/AddRecipe/presentation/bloc/creator_recipe_bloc.dart';
import 'package:ukla_app/features/AddRecipe/presentation/widgets/videoPickerWidget.dart';
import 'package:ukla_app/injection_container.dart';
import 'package:ukla_app/main.dart';

class AddRecipePage extends StatefulWidget {

  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final CreatorRecipeBloc bloc = sl<CreatorRecipeBloc>();
  bool update = false;
  @override
  Widget build(BuildContext context) {
    if(Provider.of<CreatorRecipePorvider>(context,listen: false).description!=null
    && Provider.of<CreatorRecipePorvider>(context,listen: false).title!=null){
      update = true;
    }
    return WillPopScope(
      onWillPop: () async {
        Provider.of<CreatorRecipePorvider>(context,listen: false).clear();
        return true;
      },
      child: Scaffold(
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
                Provider.of<CreatorRecipePorvider>(context,listen: false).clear();
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: inputTitle(
              update ? "Update Recipe".tr(context):"add_recipe".tr(context),
            ),
          ),
          body: const Padding(
              padding: EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 15),
              child: VideoPickerWidget()
          )
      ),
    );
  }
}
