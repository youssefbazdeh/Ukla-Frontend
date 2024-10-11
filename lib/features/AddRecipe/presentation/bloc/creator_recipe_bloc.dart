import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukla_app/features/AddRecipe/Data/datasources/creator_recipe_remote_data_source.dart';
import 'package:ukla_app/features/AddRecipe/Domain/Entities/creator_recipe.dart';
import 'package:ukla_app/features/AddRecipe/Domain/usecases/add_creator_recipe.dart';
import 'package:ukla_app/features/AddRecipe/Domain/usecases/delete_creator_recipe.dart';
import 'package:ukla_app/features/AddRecipe/Domain/usecases/get_creator_recipe_list.dart';
import 'package:ukla_app/features/AddRecipe/Domain/usecases/update_creator_recipe.dart';
import 'package:ukla_app/features/AddRecipe/presentation/bloc/creator_recipe_event.dart';
import 'package:ukla_app/features/AddRecipe/presentation/bloc/creator_recipe_state.dart';

class CreatorRecipeBloc extends Bloc<CreatorRecipeEvent, CreatorRecipeState> {
  final GetCreatorRecipeList getCreatorRecipeList;
  final DeleteCreatorRecipe deleteCreatorRecipe;
  final AddCreatorRecipe addCreatorRecipe;
  final UpdateCreatorRecipe updateCreatorRecipe;

  List<CreatorRecipe> _list = [];

  CreatorRecipeBloc({
    required this.getCreatorRecipeList,
    required this.deleteCreatorRecipe,
    required this.addCreatorRecipe,
    required this.updateCreatorRecipe,
  }) : super(CreatorRecipeLoading()) {
    on<CreatorRecipeEvent>((event, emit) async {
      if (event is CreatorRecipeErrorEvent) {
        emit(CreatorRecipeError(event.message, event.statusCode));
      } else if (event is LoadCreatorRecipe) {
        emit(CreatorRecipeLoading());
        try {
          _list = await getCreatorRecipeList();
          emit(CreatorRecipeLoaded(_list));
        } on ServerExceptionForCreatorRecipe catch (e) {
          emit(CreatorRecipeError(e.message, e.statusCode));
        }
      } else if (event is AddCreatorRecipeEvent) {
        try {
          CreatorRecipe newCreatorRecipe = await addCreatorRecipe(
            event.title,
            event.description,
            event.videoId,
          );
          _list.add(newCreatorRecipe);
          emit(AddCreatorRecipeState(_list, newCreatorRecipe.title));
        } catch (e) {
          emit(CreatorRecipeError(e.toString(), 500));
        }
      } else if (event is UpdateCreatorRecipeEvent) {
        try{
          CreatorRecipe updatedCreatorRecipe = await updateCreatorRecipe(
            event.id,
            event.title,
            event.description,
            event.videoId
          );
          _list = _list.map((creatorRecipe) {
            return creatorRecipe.id == event.id ? updatedCreatorRecipe : creatorRecipe;
          }).toList();
          emit(UpdateCreatorRecipeState(_list, updatedCreatorRecipe.title));
        }catch(e){
          emit(CreatorRecipeError(e.toString(), 500));
        }
      } else if (event is DeleteCreatorRecipeEvent) {
        DeletionResult deletionResult = deleteRecipeById(_list, event.id);
        List<CreatorRecipe> updatedRecipes = deletionResult.updatedList;
        emit(DeleteCreatorRecipeState(
          updatedRecipes,
          DateTime.now(),
          deletionResult.deletedRecipe!.title,
        ));
        final response = await deleteCreatorRecipe(event.id);
        await Future.delayed(const Duration(milliseconds: 500));
        if (!response) {
          List<CreatorRecipe> restoredRecipes = undoDeleteRecipe(
            updatedRecipes,
            deletionResult.deletedRecipe,
          );
          emit(UndoDeleteCreatorRecipeState(
            restoredRecipes,
            DateTime.now(),
            deletionResult.deletedRecipe!.title,
          ));
        } else {
          _list = updatedRecipes;
          emit(CreatorRecipeLoaded(_list));
        }
      }
    });
  }
}

class DeletionResult {
  final List<CreatorRecipe> updatedList;
  final CreatorRecipe? deletedRecipe;

  DeletionResult(this.updatedList, this.deletedRecipe);
}

DeletionResult deleteRecipeById(List<CreatorRecipe> recipes, int idToRemove) {
  CreatorRecipe? deletedRecipe;
  List<CreatorRecipe> updatedList = recipes.where((recipe) {
    if (recipe.id == idToRemove) {
      deletedRecipe = recipe;
      return false;
    }
    return true;
  }).toList();
  return DeletionResult(updatedList, deletedRecipe);
}

List<CreatorRecipe> undoDeleteRecipe(List<CreatorRecipe> recipes, CreatorRecipe? recipeToReAdd) {
  if (recipeToReAdd != null) {
    recipes.add(recipeToReAdd);
  }
  return recipes;
}
