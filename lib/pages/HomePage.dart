import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/analytics/events.dart';
import 'package:ukla_app/features/AddRecipe/presentation/pages/creator_recipe_list.dart';
import 'package:ukla_app/features/Settings/settings_interface.dart';
import 'package:ukla_app/features/groceries/Presentation/grocery_manager.dart';
import 'package:ukla_app/features/plan_Management/Presentation/pages/plan_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  bool showAddRecipe = false;

  @override
  void initState() {
    super.initState();
    isUserCreator();
  }

  void isUserCreator () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if(prefs.getString('user_role') == 'CREATOR'){
        showAddRecipe = true;
      }
    });

  }


  void _onItemTapped(int index) {
    if(showAddRecipe){
      setState(() {
        _selectedIndex = index;
        switch (_selectedIndex) {
          case 0:
            FireBaseAnalyticsEvents.screenViewed('Grocery_list');
            break;
          case 1:
            FireBaseAnalyticsEvents.screenViewed('Plan_list');
            break;
          case 3:
            FireBaseAnalyticsEvents.screenViewed('Profile');
            break;
        }
      });
    }else{
      setState(() {
        _selectedIndex = index;
        switch (_selectedIndex) {
          case 0:
            FireBaseAnalyticsEvents.screenViewed('Grocery_list');
            break;
          case 1:
            FireBaseAnalyticsEvents.screenViewed('Plan_list');
            break;
          case 2:
            FireBaseAnalyticsEvents.screenViewed('Profile');
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      const GroceryManager(),
      const PlanList(),
      if(showAddRecipe) const CreatorRecipeList(),
      const Settings()
    ];
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        items:  <BottomNavigationBarItem>[
           BottomNavigationBarItem(
            icon: const Icon(Ionicons.cart_outline),
            label: 'Shop list'.tr(context),
          ),
           BottomNavigationBarItem(
            icon: const Icon(Ionicons.list_outline),
            label: 'Plan'.tr(context),
          ),
          if (showAddRecipe)
            BottomNavigationBarItem(
              icon: const Icon(Ionicons.add_circle_outline),
              label: 'add_recipe'.tr(context),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Ionicons.person_outline),
              label: 'Profile'.tr(context),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0XFFFA6375),
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        showUnselectedLabels: true,
        enableFeedback: false,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
