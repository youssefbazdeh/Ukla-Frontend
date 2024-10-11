import 'package:equatable/equatable.dart';
import 'package:ukla_app/features/AddRecipe/Domain/Entities/creator_recipe.dart';

abstract class CreatorRecipeState extends Equatable {
  const CreatorRecipeState();
  @override
  List<Object> get props => [];
}

class CreatorRecipeLoading extends CreatorRecipeState {}

class CreatorRecipeLoaded extends CreatorRecipeState {
  final List<CreatorRecipe> list;
  const CreatorRecipeLoaded(this.list);
  @override
  List<Object> get props => [list];
}

class DeleteCreatorRecipeState extends CreatorRecipeState {
  final String creatorRecipeTitle;
  final List<CreatorRecipe> list;
  final DateTime timeStamp;
  const DeleteCreatorRecipeState(this.list,this.timeStamp,this.creatorRecipeTitle) : super();
  @override
  List<Object> get props => [list,timeStamp,creatorRecipeTitle];
}

class UndoDeleteCreatorRecipeState extends CreatorRecipeState{
  final List<CreatorRecipe> list;
  final DateTime timeStamp;
  final String creatorRecipeTitle;
  const UndoDeleteCreatorRecipeState(this.list,this.timeStamp,this.creatorRecipeTitle) : super();
  @override
  List<Object> get props => [creatorRecipeTitle,list,timeStamp];
}

class AddCreatorRecipeState extends CreatorRecipeState {
  final List<CreatorRecipe> list;
  final String addedCreatorRecipeTitle;
  const AddCreatorRecipeState(this.list,this.addedCreatorRecipeTitle) : super();
  @override
  List<Object> get props => [list,addedCreatorRecipeTitle];
}

class UpdateCreatorRecipeState extends CreatorRecipeState {
  final List<CreatorRecipe> list;
  final String updateCreatorRecipeTitle;
  const UpdateCreatorRecipeState(this.list,this.updateCreatorRecipeTitle) : super();
  @override
  List<Object> get props => [list,updateCreatorRecipeTitle];
}

class CreatorRecipeError extends CreatorRecipeState {
  final String message;
  final int statusCode;
  const CreatorRecipeError(this.message, this.statusCode) : super();
  @override
  List<Object> get props => [message,statusCode];
}

