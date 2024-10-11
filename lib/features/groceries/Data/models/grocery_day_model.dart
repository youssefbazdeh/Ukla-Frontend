import 'package:ukla_app/features/groceries/Data/models/grocery_recipe_model.dart';
import 'package:ukla_app/features/groceries/Domain/Entities/grocery_day.dart';

class GroceryDayModel extends GroceryDay {

  GroceryDayModel({ super.day,  super.recipes});

  factory GroceryDayModel.fromJson(Map<String, dynamic> json) => GroceryDayModel(
      day: json["name"],
      recipes: (json["recipes"] as List).map((recipe) => GroceryRecipeModel.fromJson(recipe as Map<String, dynamic>)).toList(),
  );
}
