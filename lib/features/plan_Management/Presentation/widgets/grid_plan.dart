import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ukla_app/features/plan_Management/Domain/Entity/PlanModel.dart';

class GridPlan extends StatefulWidget {
  @override
  final Key key;
  final Plan plan;
  final ValueChanged<bool> isSelected;
  final ValueChanged<bool> deleteIsSelected;
  final ValueChanged<TextEditingController> planController;
  final ValueChanged<bool> renameisSelected;

  const GridPlan(
      {required this.plan,
      required this.isSelected,
      required this.deleteIsSelected,
      required this.planController,
      required this.renameisSelected,
      required this.key});

  @override
  _GridPlanState createState() => _GridPlanState();
}

class _GridPlanState extends State<GridPlan> {
  bool isSelected = false;
  bool deleteisselected = false;
  var planController = TextEditingController();
  bool renameisSelected = false;

  late FocusNode myFocusNode;
  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int rank = widget.plan.rank;
    planController.text = 'plan $rank';
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(width: 1, color: const Color.fromARGB(255, 0, 0, 0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text("Plan $rank "),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: TextFormField(
                    controller: planController,
                    // textAlignVertical: TextAlignVertical.top,
                    textAlign: TextAlign.start,
                    autofocus: false,
                    focusNode: myFocusNode,
                    //readOnly: false,
                    //enabled: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: ("Plan $rank "),
                        hintText: ("Plan $rank ")),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: (() {
                                myFocusNode.requestFocus();
                                renameisSelected = true;
                                widget.renameisSelected(renameisSelected);
                                widget.planController(planController);
                              }),
                              child: const Icon(Ionicons.create_outline)),
                          const SizedBox(width: 3),
                          InkWell(
                              onTap: () {
                                setState(() {});
                              },
                              child: const Icon(
                                Ionicons.close_circle_outline,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
