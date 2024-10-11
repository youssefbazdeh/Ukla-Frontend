import 'package:equatable/equatable.dart';
import '../../Domain/Entities/grocery_list.dart';

abstract class GroceryState extends Equatable{
  const GroceryState();

  @override
  List<Object> get props => [];
}

  class GroceryListLoading extends GroceryState {}

  class GroceryListLoaded extends GroceryState {
    final GroceryList groceryList;

    const GroceryListLoaded(this.groceryList) : super();

    @override
    List<Object> get props => [groceryList];
  }

  class GroceryListPurchaseIngredient extends GroceryState {
  final GroceryList groceryList;
  final DateTime timeStamp;
  const GroceryListPurchaseIngredient(this.groceryList, this.timeStamp) : super();

  @override
  List<Object> get props => [groceryList,timeStamp];

}

class GroceryUndoPurchase extends GroceryState {
  final GroceryList groceryList;
  final String ingredientName;
  final DateTime timeStamp;
  const GroceryUndoPurchase(this.groceryList, this.ingredientName, this.timeStamp) : super();

  @override
  List<Object> get props => [groceryList,ingredientName,timeStamp];

}

class GroceryUndoUnPurchase extends GroceryState {
  final GroceryList groceryList;
  final String ingredientName;
  final DateTime timeStamp;
  const GroceryUndoUnPurchase(this.groceryList, this.ingredientName, this.timeStamp) : super();

  @override
  List<Object> get props => [groceryList,ingredientName,timeStamp];

}

class GroceryUnpurchaseIngredient extends GroceryState {
  final GroceryList groceryList;
  final DateTime timeStamp;
  const GroceryUnpurchaseIngredient(this.groceryList, this.timeStamp) : super();

  @override
  List<Object> get props => [groceryList,timeStamp];

}

class GroceryDeleteIngredient extends GroceryState {
  final GroceryList groceryList;
  final DateTime timeStamp;
  const GroceryDeleteIngredient(this.groceryList, this.timeStamp) : super();

  @override
  List<Object> get props => [groceryList,timeStamp];

}

class GroceryUndoDeleteIngredient extends GroceryState {
  final GroceryList groceryList;
  final String ingredientName;
  final DateTime timeStamp;
  const GroceryUndoDeleteIngredient(this.groceryList, this.ingredientName, this.timeStamp) : super();

  @override
  List<Object> get props => [groceryList,ingredientName,timeStamp];

}

class GroceryUndoDeleteAllIngredient extends GroceryState {
  final GroceryList groceryList;
  final DateTime timeStamp;
  const GroceryUndoDeleteAllIngredient(this.groceryList, this.timeStamp) : super();

  @override
  List<Object> get props => [groceryList,timeStamp];

}

  class ServerError extends GroceryState {
    final String message;
    final int statusCode;

    const ServerError(this.message, this.statusCode) : super();

    @override
    List<Object> get props => [message,statusCode];
  }