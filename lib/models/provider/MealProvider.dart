import 'package:flutter/cupertino.dart';
import '../../features/plan_Management/Domain/Entity/Meal.dart';
import '../../features/view_recipe/Domain/Entities/recipe.dart';

class MealProvider extends ChangeNotifier {
  List<Meal> list = [
    Meal(id: 1, dayId: 1, name: "breakfast", recipes: []),
    Meal(id: 1, dayId: 1, name: "lunch", recipes: []),
    Meal(id: 1, dayId: 1, name: "dinner", recipes: [])
  ];
  List<int> mealsids = [];

  void setList(List<Meal> l) {
    list = l;
    notifyListeners();
  }

  List<Meal> getList() {
    return list;
  }

  void setListrecipes(int id, List<Recipe> l) {
    list[id].recipes = l;
    notifyListeners();
  }

  List<Recipe> getListrecipes(int id) {
    return list[id].recipes;
  }

  addrecipelist(int id, Recipe r) {
    list[id].recipes.add(r);
    notifyListeners();
  }

  removerecipe(int id, Recipe r) {
    list[id].recipes.remove(r);
    notifyListeners();
  }
}
