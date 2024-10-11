import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/features/intake_estimation/Domain/entities/estimation_ingredient.dart';
import '../../../../injection_container.dart';
import '../../Domain/entities/estimation_ingredient_quantity.dart';
import '../../Domain/entities/estimation_meal.dart';
import '../bloc/intake_estimation_bloc.dart';
import '../widgets/ingredient_searched_card.dart';

class SearchIngredient extends StatefulWidget {
  final EstimationMeal estimationMeal;
  final int index;
  final List<List<EstimationIngredient>> estimationIngredientList;
  final List<List<EstimationIngredientQuantity>>
      estimationIngredientQuantityList;
  const SearchIngredient({
    super.key,
    required this.estimationMeal,
    required this.index,
    required this.estimationIngredientList,
    required this.estimationIngredientQuantityList,
  });

  @override
  State<SearchIngredient> createState() => _SearchIngredientState();
}

class _SearchIngredientState extends State<SearchIngredient> {
  final IntakeEstimationBloc bloc = sl<IntakeEstimationBloc>();
  //var items;
  @override
  initState() {
    bloc.add(const GetEstimationIngredientsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var controller = TextEditingController();

    return BlocProvider(
      create: (_) => bloc,
      child: BlocBuilder<IntakeEstimationBloc, IntakeEstimationState>(
          builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundGrey,
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      right: width / 15, left: width / 15, top: height / 15),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: width / 20,
                            left: width / 20,
                            top: height / 30),
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 5),
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                    offset: Offset(0, 2),
                                    blurRadius: 3.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0XFFFDFDFD),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  hintText: "Search for Ingredient",
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    if (value.isEmpty) {
                                      bloc.add(
                                          const GetEstimationIngredientsEvent());
                                    } else {
                                      bloc.add(SearchEstimationIngredientsEvent(
                                          value));
                                    }
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: height / 30,
                            ),
                            if (state is EstimationIngredientsLoaded)
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.estimationIngredients.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return IngredientSearchedCard(
                                      ingredient:
                                          state.estimationIngredients[index],
                                      estimationMeal: widget.estimationMeal,
                                      index: widget.index,
                                      estimationIngredientList:
                                          widget.estimationIngredientList,
                                      estimationIngredientQuantityList: widget
                                          .estimationIngredientQuantityList);
                                },
                              ),
                            SizedBox(
                              height: height / 30,
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          )),
        );
      }),
    );
  }
}
