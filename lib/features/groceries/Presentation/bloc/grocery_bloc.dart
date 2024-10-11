import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukla_app/features/groceries/Domain/Entities/grocery_list.dart';
import 'package:ukla_app/features/groceries/Domain/usecases/delete_ingredient.dart';
import 'package:ukla_app/features/groceries/Domain/usecases/purchase_ingredient.dart';
import 'package:ukla_app/features/groceries/Domain/usecases/unpurchase_ingredient.dart';
import 'package:ukla_app/features/groceries/Presentation/bloc/grocery_event.dart';
import 'package:ukla_app/features/groceries/Presentation/bloc/grocery_state.dart';
import '../../Data/datasources/grocery_remote_data_source.dart';
import '../../Domain/logic.dart';
import '../../Domain/usecases/get_groceries_list.dart';

class GroceryBloc extends Bloc<GroceryEvent,GroceryState>{
  final GetGroceriesList getGroceriesList;
  final PurchaseGroceriesListIngredient purchaseGroceryListIngredient;
  final UnpurchaseGroceriesListIngredient unpurchaseGroceryListIngredient;
  final DeleteGroceriesListIngredient deleteGroceryListIngredient;

  GroceryList _groceryList = GroceryList();

  GroceryBloc({
    required this.getGroceriesList,
    required this.purchaseGroceryListIngredient,
    required this.unpurchaseGroceryListIngredient,
    required this.deleteGroceryListIngredient
  }) : super(GroceryListLoading()) {
    on<GroceryEvent> ((event,emit) async {
      if(event is GroceryErrorEvent){
        emit(ServerError(event.message, event.statusCode));
      }
      if (event is LoadGroceryList) {
        emit(GroceryListLoading());
        try{
          _groceryList = await getGroceriesList(event.languageCode);
          emit(GroceryListLoaded(_groceryList));
        } on ServerExceptionForGroceryList catch (e){
          emit(ServerError(e.message, e.statusCode));
        }
      }
      else if (event is PurchaseIngredient){
          GroceryList groceryList = purchaseIngredient(_groceryList, event.ingredientIDS);
          emit(GroceryListPurchaseIngredient(groceryList,DateTime.now()));
          final response = await purchaseGroceryListIngredient(event.ingredientIDS);
          await Future.delayed(const Duration(milliseconds: 500));
          if(response == false){
            GroceryList undoGroceryListChanges = unPurchaseIngredient(groceryList, event.ingredientIDS);
            emit(GroceryUndoPurchase(undoGroceryListChanges,event.ingredientName,DateTime.now()));
          }
      }
      else if (event is UnpurchaseIngredient){
        GroceryList groceryList = unPurchaseIngredient(_groceryList, event.ingredientIDS);
        emit(GroceryUnpurchaseIngredient(groceryList,DateTime.now()));
        final response = await unpurchaseGroceryListIngredient(event.ingredientIDS);
        await Future.delayed(const Duration(milliseconds: 500));
        if(response == false){
          GroceryList undoGroceryListChanges = purchaseIngredient(groceryList, event.ingredientIDS);
          emit(GroceryUndoUnPurchase(undoGroceryListChanges,event.ingredientName,DateTime.now()));
        }

      }
      else if (event is RemoveIngredient){
        List<DeletedIngredientInfo> deletedIngredientInfo = collectDeletedIngredientInfo(_groceryList,event.ingredientIDS);
        GroceryList groceryList = deleteIngredient(_groceryList,event.ingredientIDS);
        emit(GroceryDeleteIngredient(groceryList,DateTime.now()));
        final response = await deleteGroceryListIngredient(event.ingredientIDS);
        await Future.delayed(const Duration(milliseconds: 500));
        if(response == false){
          GroceryList undoGroceryListChanges = reAddDeletedIngredients(groceryList,deletedIngredientInfo);
          emit(GroceryUndoDeleteIngredient(undoGroceryListChanges,event.groceryIngredient.ingredientName!,DateTime.now()));
        }
      }
      else if (event is RemoveAllIngredients){
        List<DeletedIngredientInfo> deletedIngredientInfo = collectDeletedIngredientInfo(_groceryList, event.ingredientIDS);
        GroceryList groceryList = deleteIngredient(_groceryList,event.ingredientIDS);
        emit(GroceryDeleteIngredient(groceryList,DateTime.now()));
        final response = await deleteGroceryListIngredient(event.ingredientIDS);
        await Future.delayed(const Duration(milliseconds: 500));
        if(response == false){
          GroceryList undoGroceryListChanges = reAddDeletedIngredients(groceryList,deletedIngredientInfo);
          emit(GroceryUndoDeleteAllIngredient(undoGroceryListChanges,DateTime.now()));
        }
      }
    });
  }
}
