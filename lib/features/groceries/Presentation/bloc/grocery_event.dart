import 'package:equatable/equatable.dart';

import '../../Domain/Entities/grocery_ingredient.dart';

abstract class GroceryEvent extends Equatable {
  const GroceryEvent();

  @override
  List<Object> get props => [];
}

class LoadGroceryList extends GroceryEvent{
  final String languageCode;
  const LoadGroceryList(this.languageCode);
}

class PurchaseIngredient extends GroceryEvent {
  final List<int> ingredientIDS;
  final String languageCode;
  final String ingredientName;
  const PurchaseIngredient(this.ingredientIDS, this.languageCode, this.ingredientName);
}

class UnpurchaseIngredient extends GroceryEvent {
  final List<int> ingredientIDS;
  final String languageCode;
  final String ingredientName;
  const UnpurchaseIngredient(this.ingredientIDS, this.languageCode, this.ingredientName);
}

class RemoveIngredient extends GroceryEvent {
  final List<int> ingredientIDS;
  final String languageCode;
  final GroceryIngredient groceryIngredient;
  const RemoveIngredient(this.ingredientIDS, this.languageCode, this.groceryIngredient);
}

class RemoveAllIngredients extends GroceryEvent {
  final List<int> ingredientIDS;
  final String languageCode;
  final List<GroceryIngredient> groceryIngredient;
  const RemoveAllIngredients(this.ingredientIDS, this.languageCode, this.groceryIngredient);
}

class GroceryErrorEvent extends GroceryEvent {
  final String message;
  final int statusCode;

  const GroceryErrorEvent(this.message, this.statusCode);
}
