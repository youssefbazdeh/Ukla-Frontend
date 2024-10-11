import 'package:equatable/equatable.dart';

class CreatorRecipeEvent extends Equatable {
  const CreatorRecipeEvent();
  @override
  List<Object> get props => [];
}

class LoadCreatorRecipe extends CreatorRecipeEvent {}

class DeleteCreatorRecipeEvent extends CreatorRecipeEvent {
  final int id;
  const DeleteCreatorRecipeEvent(this.id);

  @override
  List<Object> get props => [id];
}

class AddCreatorRecipeEvent extends CreatorRecipeEvent {
  final String title;
  final String description;
  final int videoId;
  const AddCreatorRecipeEvent(this.title,this.description,this.videoId);
  @override
  List<Object> get props => [title,description,videoId];
}

class UpdateCreatorRecipeEvent extends CreatorRecipeEvent {
  final int id;
  final String title;
  final String description;
  final int videoId;
  const UpdateCreatorRecipeEvent(this.title,this.description,this.videoId,this.id);
  @override
  List<Object> get props => [title,description,videoId,id];
}


class CreatorRecipeErrorEvent extends CreatorRecipeEvent{
  final String message;
  final int statusCode;
  const CreatorRecipeErrorEvent(this.message,this.statusCode);
}