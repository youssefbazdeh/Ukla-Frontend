import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/Presentation/resources/colors_manager.dart';
import '../../Domain/entities/estimation_meal.dart';
import '../bloc/intake_estimation_bloc.dart';

class EstimationFinalAddMealCard extends StatefulWidget {
  final String mealTitle;
  final IntakeEstimationBloc bloc;
  const EstimationFinalAddMealCard(
      {Key? key, required this.mealTitle, required this.bloc})
      : super(key: key);

  @override
  State<EstimationFinalAddMealCard> createState() =>
      _EstimationFinalAddMealCardState();
}

class _EstimationFinalAddMealCardState
    extends State<EstimationFinalAddMealCard> {
  final myController = TextEditingController();
  @override
  void initState() {
    myController.text = widget.mealTitle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderQuestion),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SizedBox(
            width: width / 1.5,
            child: TextField(
              controller: myController,
              enableInteractiveSelection: false,
              style:  TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400),
              decoration:  InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          IconButton(
            iconSize: 35,
            icon: const Icon(
              Icons.check_circle,
              color: AppColors.secondaryColor,
            ),
            onPressed: () {
              List<EstimationMeal> estimationMeals = [];
              EstimationMeal estimationMeal = EstimationMeal();
              estimationMeal.name = myController.text;
              estimationMeal.filled = false;
              estimationMeals.add(estimationMeal);

              widget.bloc.add(AddEstimationMealsEvent(estimationMeals));
              widget.bloc.add(const GetEstimationMealsEvent());
            },
          ),
        ],
      ),
    );
  }
}
