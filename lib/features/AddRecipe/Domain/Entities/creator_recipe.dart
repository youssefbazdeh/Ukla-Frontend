import 'package:ukla_app/core/domain/entities/video.dart';

class CreatorRecipe{
  CreatorRecipe({
    required this.id,
    required this.title,
    required this.description,
    required this.video,
    required this.creator
});
  int id;
  String title;
  String description;
  Video video;
  String creator;
}