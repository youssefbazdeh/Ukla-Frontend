import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/Presentation/resources/colors_manager.dart';

// ignore: must_be_immutable
class EstimationListMealCard extends StatefulWidget {
  String mealTitle;
  EstimationListMealCard({
    Key? key,
    required this.mealTitle,
  }) : super(key: key);

  @override
  State<EstimationListMealCard> createState() => _EstimationListMealCardState();
}

class _EstimationListMealCardState extends State<EstimationListMealCard> {
  FocusNode myFocusNode = FocusNode();
  bool completeTypingMealTitle = false;
  final myController = TextEditingController();

  @override
  void initState() {
    myController.text = widget.mealTitle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int selectedValue = 0;

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
              focusNode: myFocusNode,
              onEditingComplete: () {
                widget.mealTitle = myController.text;
                myFocusNode.unfocus();
              },
              enableInteractiveSelection: false,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              style:  TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
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
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.more_horiz,
                size: 30,
              ),
              items: const [
                DropdownMenuItem(child: Text("Edit"), value: 0),
                DropdownMenuItem(child: Text("Delete"), value: 1),
              ],
              value: selectedValue,
              onChanged: (int? value) {
                setState(() {
                  selectedValue = value!;
                  if (selectedValue == 0) {
                    myFocusNode.requestFocus();
                  }
                });
              },
              dropdownStyleData: DropdownStyleData(
                width: 140,
                offset: Offset(-width / 3.8, -12),
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black26,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
