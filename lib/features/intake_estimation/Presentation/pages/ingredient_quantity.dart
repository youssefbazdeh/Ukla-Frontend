import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_ingredient.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_ingredient_quantity.dart';
import 'package:ukla_app/features/intake_estimation/Presentation/widgets/estimation_ingredient_quantity_list_card.dart';

import '../../../../injection_container.dart';
import '../../Domain/entities/estimation_meal.dart';
import '../bloc/intake_estimation_bloc.dart';

class IngredientQuantity extends StatefulWidget {
  final EstimationIngredient ingredient;
  final EstimationMeal estimationMeal;
  final int index;
  final List<List<EstimationIngredient>> estimationIngredientList;
  final List<List<EstimationIngredientQuantity>>
      estimationIngredientQuantityList;

  const IngredientQuantity({
    Key? key,
    required this.ingredient,
    required this.estimationMeal,
    required this.index,
    required this.estimationIngredientList,
    required this.estimationIngredientQuantityList,
  }) : super(key: key);

  @override
  State<IngredientQuantity> createState() => _IngredientQuantityState();
}

class _IngredientQuantityState extends State<IngredientQuantity> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => sl<IntakeEstimationBloc>(),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: AppColors.backgroundGrey.withOpacity(0.8),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.backgroundGrey,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.only(
                        right: width / 15,
                        left: width / 15,
                        top: 10,
                        bottom: 8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            widget.ingredient.name!,
                            style:  TextStyle(
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 20.sp),
                          ),
                        ),
                        FutureBuilder<List<EstimationIngredientQuantity>>(
                            future:
                                BlocProvider.of<IntakeEstimationBloc>(context)
                                    .getEstimationIngredientsQuantites(
                                        estimationIngredientId:
                                            widget.ingredient.id!),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: width / 4.5,
                                            mainAxisExtent: height / 9,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 20),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext ctx, index) {
                                      return EstimationIngredientQuantityListCard(
                                          index: widget.index,
                                          estimationIngredientQuantity:
                                              snapshot.data![index],
                                          estimationMeal: widget.estimationMeal,
                                          estimationIngredient:
                                              widget.ingredient,
                                          estimationIngredientList:
                                              widget.estimationIngredientList,
                                          estimationIngredientQuantityList: widget
                                              .estimationIngredientQuantityList);
                                    });
                              }
                              return const CircularProgressIndicator();
                            }),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}



/*
GridView.count(
                                  primary: false,
                                  padding: const EdgeInsets.all(10),
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 3,
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    IngredientQuantityCard(
                                        ingredient: widget.ingredient),
                                    IngredientQuantityCard(
                                        ingredient: widget.ingredient),
                                    IngredientQuantityCard(
                                        ingredient: widget.ingredient),
                                    IngredientQuantityCard(
                                        ingredient: widget.ingredient),
                                    IngredientQuantityCard(
                                        ingredient: widget.ingredient),
                                    IngredientQuantityCard(
                                        ingredient: widget.ingredient),
                                  ],
                                );*/