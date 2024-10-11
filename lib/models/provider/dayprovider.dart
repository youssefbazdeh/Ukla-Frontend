import 'package:flutter/material.dart';
import 'package:ukla_app/features/plan_Management/Domain/Entity/Meal.dart';

import '../../features/plan_Management/Domain/Entity/Plan.dart';
import '../../features/view_recipe/Domain/Entities/recipe.dart';

class DayProvider extends ChangeNotifier {
  List<Day> listsays = [
    Day(id: 0, name: "day", date: DateTime.now(), meals: [
      Meal(id: 1, dayId: 1, name: "breakfast", recipes: []),
      Meal(id: 1, dayId: 1, name: "lunch", recipes: []),
      Meal(id: 1, dayId: 1, name: "dinner", recipes: [])
    ]),
    Day(id: 1, name: "day", date: DateTime.now(), meals: [
      Meal(id: 1, dayId: 1, name: "breakfast", recipes: []),
      Meal(id: 1, dayId: 1, name: "lunch", recipes: []),
      Meal(id: 1, dayId: 1, name: "dinner", recipes: [])
    ]),
    Day(id: 2, name: "day", date: DateTime.now(), meals: [
      Meal(id: 1, dayId: 1, name: "breakfast", recipes: []),
      Meal(id: 1, dayId: 1, name: "lunch", recipes: []),
      Meal(id: 1, dayId: 1, name: "dinner", recipes: [])
    ]),
    Day(id: 3, name: "day", date: DateTime.now(), meals: [
      Meal(id: 1, dayId: 1, name: "breakfast", recipes: []),
      Meal(id: 1, dayId: 1, name: "lunch", recipes: []),
      Meal(id: 1, dayId: 1, name: "dinner", recipes: [])
    ]),
    Day(id: 4, name: "day", date: DateTime.now(), meals: [
      Meal(id: 1, dayId: 1, name: "breakfast", recipes: []),
      Meal(id: 1, dayId: 1, name: "lunch", recipes: []),
      Meal(id: 1, dayId: 1, name: "dinner", recipes: [])
    ]),
    Day(id: 5, name: "day", date: DateTime.now(), meals: [
      Meal(id: 1, dayId: 1, name: "breakfast", recipes: []),
      Meal(id: 1, dayId: 1, name: "lunch", recipes: []),
      Meal(id: 1, dayId: 1, name: "dinner", recipes: [])
    ]),
    Day(id: 6, name: "day", date: DateTime.now(), meals: [
      Meal(id: 1, dayId: 1, name: "breakfast", recipes: []),
      Meal(id: 1, dayId: 1, name: "lunch", recipes: []),
      Meal(id: 1, dayId: 1, name: "dinner", recipes: [])
    ])
  ];

  int getLengthMeals(int idday) {
    return listsays[idday].meals!.length;
  }

  List<Meal> getMeallist(int idday) {
    return listsays[idday].meals!;
  }

  addday(int id, String name, DateTime date, List<Meal> l) {
    listsays.add(Day(id: id, name: name, date: date, meals: []));
  }

  void setPlanListrecipes(int idday, int idmeal, List<Recipe> l) {
    listsays[idday].meals![idmeal].recipes = l;
    notifyListeners();
  }

  List<Recipe> getPlanListrecipes(int idday, int idmeal) {
    return listsays[idday].meals![idmeal].recipes;
  }

  addrecipePlanList(int idday, int idmeal, Recipe r) {
    listsays[idday].meals![idmeal].recipes.add(r);
    notifyListeners();
  }

  removerecipe(int idday, int idmeal, Recipe r) {
    listsays[idday].meals![idmeal].recipes.remove(r);
    notifyListeners();
  }

  addMeal(int idday) {
    listsays[idday]
        .meals!
        .add(Meal(dayId: idday, name: "Untitled meal", recipes: []));
  }
}
