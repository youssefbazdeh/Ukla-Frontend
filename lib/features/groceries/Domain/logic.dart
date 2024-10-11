import 'package:ukla_app/features/groceries/Data/models/grocery_ingredient_model.dart';
import 'Entities/grocery_ingredient.dart';
import 'Entities/grocery_list.dart';

///get the grocery list and creates a new map ordered by ingredient catergory for unpurchased items
List getGroceryByCategory(GroceryList groceryList) {
  int numberIngredients = 0;
  Map<String, List<GroceryIngredient>> map = {
    "Fruits": [],
    "Vegetables": [],
    "Meat": [],
    "Spices_herbs": [],
    "Dairy": [],
    "Starches": [],
    "Fat": [],
    "Other": [],
  };

  int checkIngredientExists(List<GroceryIngredient> l, int ingredientId) {
    for (var ing = 0; ing < l.length; ing++) {
      if (l[ing].ingredientImageID == ingredientId) {
        return ing;
      }
    }
    return -1;
  }

  void removeEmptyCategories(Map<String, List<GroceryIngredient>> map) {
    map.removeWhere((key, value) => value.isEmpty);
  }

  for (var day in groceryList.groceryDays!) {
    for (var recipe in day.recipes!) {
      for (var ingredient in recipe.groceryIngredientQuantityObjects!) {
        if (!ingredient.purchased!) {
          ////check if the ingredient exits in the list of ingredient type e.g tomato exists in map["vegetables"]
          int indexIngredient = checkIngredientExists(
              map[ingredient.type]!, ingredient.ingredientImageID!);
          //if the ingredient doens't exist
          if (indexIngredient != -1) {
            //get the current quantity
            double quantity = map[ingredient.type]![indexIngredient].quantity!;
            quantity += ingredient.quantity!;
            map[ingredient.type]![indexIngredient].quantity = quantity;
          } else {
            numberIngredients += 1;
            GroceryIngredient newIngredient = GroceryIngredient(
                ingredientId: 1,
                ingredientImageID: ingredient.ingredientImageID,
                ingredientName: ingredient.ingredientName,
                purchased: false,
                quantity: ingredient.quantity,
                unit: ingredient.unit,
                type: ingredient.type,
                brandName: ingredient.brandName,
                ingredientAdImageId: ingredient.ingredientAdImageId,
                ingredientAdId: ingredient.ingredientAdId);
            //if does'n t exists just add it
            map[ingredient.type]!.add(newIngredient);
          }
        }
      }
    }
  }
  removeEmptyCategories(map);
  return [map, numberIngredients];
}

List getPurchasedGroceryByCategory(GroceryList groceryList) {
  int numberIngredients = 0;
  Map<String, GroceryIngredient> map = {};
  for (var day in groceryList.groceryDays!) {
    for (var recipe in day.recipes!) {
      for (var ingredient in recipe.groceryIngredientQuantityObjects!) {
        ////check if the ingredient exits in the list of ingredient type e.g tomato exists in map["vegetables"]
        if (ingredient.purchased!) {
          if (!(map.containsKey(ingredient.ingredientName))) {
            numberIngredients += 1;
            GroceryIngredient newIngredient = GroceryIngredient(
                ingredientId: 0,
                ingredientImageID: ingredient.ingredientImageID,
                ingredientName: ingredient.ingredientName,
                purchased: true,
                quantity: ingredient.quantity,
                unit: ingredient.unit,
                type: ingredient.type,
                ingredientAdId: ingredient.ingredientAdId,
                ingredientAdImageId: ingredient.ingredientAdImageId,
                brandName: ingredient.brandName);
            map[ingredient.ingredientName!] = newIngredient;
          } else {
            map[ingredient.ingredientName!]!.quantity = map[ingredient.ingredientName!]!.quantity! + ingredient.quantity!;
          }
        }
      }
    }
  }

  return [map.values.toList(), numberIngredients];
}

List<int> getAllindexes(GroceryList groceryList, String ingredientName,
    [bool? selectpurshased]) {
  //if select pushased=true => select all purshaed element with ingredientName if false select all unpurshased with ingredientName
  //if null select all elements with name== ingredient name
  List<int> purchasedIndexes = [];
  List<int> unpurchasedIndexes = [];
  List<int> indexes = [];
  for (var day in groceryList.groceryDays!) {
    for (int i = 0; i < day.recipes!.length; i++) {
      List<GroceryIngredient> groceryIngredients =
          day.recipes![i].groceryIngredientQuantityObjects!;
      for (GroceryIngredient ingredient in groceryIngredients) {
        if (ingredient.ingredientName == ingredientName) {
          if (selectpurshased == true && ingredient.purchased == true) {
            purchasedIndexes.add(ingredient.ingredientId!);
          } else if (selectpurshased == false &&
              ingredient.purchased == false) {
            unpurchasedIndexes.add(ingredient.ingredientId!);
          } else {
            indexes.add(ingredient.ingredientId!);
          }
        }
      }
    }
  }
  if (selectpurshased == true) {
    return purchasedIndexes;
  } else if (selectpurshased == false) {
    return unpurchasedIndexes;
  }
  return indexes;
}

//for clear all
///get all indexes of  all purchased elements
List<int> getAllPurchasedindexes(GroceryList groceryList) {
  List<int> indexes = [];
  for (var day in groceryList.groceryDays!) {
    for (int i = 0; i < day.recipes!.length; i++) {
      List<GroceryIngredient> groceryIngredients =
          day.recipes![i].groceryIngredientQuantityObjects!;
      for (GroceryIngredient ingredient in groceryIngredients) {
        if (ingredient.purchased!) {
          indexes.add(ingredient.ingredientId!);
        }
      }
    }
  }
  return indexes;
}

int getGroceyListItems(GroceryList groceryList) {
  int groceryListItems = 0;
  for (var day in groceryList.groceryDays!) {
    for (var recipe in day.recipes!) {
      for (var ingredient in recipe.groceryIngredientQuantityObjects!) {
        groceryListItems += 1;
      }
    }
  }
  return groceryListItems;
}

GroceryList purchaseIngredient(GroceryList groceryList,List<int> index){
  for(var day in groceryList.groceryDays!){
    for(var recipe in day.recipes!) {
        for(var ingredient in recipe.groceryIngredientQuantityObjects!) {
          if(index.contains(ingredient.ingredientId)){
            ingredient.purchased=true;
          }
        }
    }
  }
   return groceryList;
}


GroceryList unPurchaseIngredient(GroceryList groceryList,List<int> index){
  for(var day in groceryList.groceryDays!){
    for(var recipe in day.recipes!) {
      for(var ingredient in recipe.groceryIngredientQuantityObjects!) {
        if(index.contains(ingredient.ingredientId)){
          ingredient.purchased=false;
        }
      }
    }
  }
  return groceryList;
}

GroceryList deleteIngredient(GroceryList groceryList,List<int> indexToRemove){
  for(var day in groceryList.groceryDays!){
    for(var recipe in day.recipes!) {
      recipe.groceryIngredientQuantityObjects = recipe.groceryIngredientQuantityObjects!.where((ingredient) =>!indexToRemove.contains(ingredient.ingredientId)).toList();
    }
  }
  return groceryList;
}

class DeletedIngredientInfo {
  final int recipeId;
  final GroceryIngredient groceryIngredient;
  final int index;

  DeletedIngredientInfo(this.recipeId, this.groceryIngredient, this.index);
}

List<DeletedIngredientInfo> collectDeletedIngredientInfo(GroceryList groceryList, List<int> indexToRemove) {
  List<DeletedIngredientInfo> deletedInfoList = [];

  for (var day in groceryList.groceryDays!) {
    for (var recipe in day.recipes!) {
      for (int i = 0; i < recipe.groceryIngredientQuantityObjects!.length; i++) {
        var ingredient = recipe.groceryIngredientQuantityObjects![i];
        if (indexToRemove.contains(ingredient.ingredientId)) {
          deletedInfoList.add(DeletedIngredientInfo(recipe.id!, ingredient, i));
        }
      }
    }
  }

  return deletedInfoList;
}

GroceryList reAddDeletedIngredients(GroceryList groceryList, List<DeletedIngredientInfo> deletedInfoList) {
  for (var info in deletedInfoList) {
    for (var day in groceryList.groceryDays!) {
      for (var recipe in day.recipes!) {
        if (recipe.id == info.recipeId) {
          recipe.groceryIngredientQuantityObjects!.insert(info.index, GroceryIngredientModel(
              ingredientId: info.groceryIngredient.ingredientId,
              ingredientImageID: info.groceryIngredient.ingredientImageID,
              type: info.groceryIngredient.type,
              unit: info.groceryIngredient.unit,
              quantity: info.groceryIngredient.quantity,
              purchased: info.groceryIngredient.purchased,
              ingredientName: info.groceryIngredient.ingredientName
          ));
          break;
        }
      }
    }
  }
  return groceryList;
}




