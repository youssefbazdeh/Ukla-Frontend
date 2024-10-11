import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/features/groceries/Presentation/groceries_by_category.dart';
import 'package:ukla_app/features/groceries/Presentation/grocery_by_plan.dart';
import 'package:ukla_app/main.dart';

class GroceryManager extends StatefulWidget {
  const GroceryManager({super.key});

  @override
  _GroceryManagerState createState() => _GroceryManagerState();
}

class _GroceryManagerState extends State<GroceryManager> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child:Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text("Groceries".tr(context),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Consumer<GroceryListLengthState>(
                        builder: (context,state,child){
                          return Text(
                            "${state.loadedListLength} " + "items".tr(context),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          );
                        },
                      ),
                      SizedBox(width: width*0.3),
                      Text(
                        "Sort By".tr(context),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Ionicons.calendar_clear_outline,
                              color: _selectedIndex == 0
                                  ? const Color(0xFFFA6375)
                                  : Colors.black,
                            ),
                            Text(
                              "Plan",
                              style: TextStyle(
                                color: _selectedIndex == 0
                                    ? const Color(0xFFFA6375)
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: width/40),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Ionicons.grid_outline,
                              color: _selectedIndex == 1
                                  ? const Color(0xFFFA6375)
                                  : Colors.black,
                            ),
                            Text(
                              "Category",
                              style: TextStyle(
                                color: _selectedIndex == 1
                                    ? const Color(0xFFFA6375)
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _selectedIndex == 0 ?  const GroceryByPlan() : const GroceriesByCategoryInterface(),
                )
              ],
            ),
          ),
      ),
    );
  }
}