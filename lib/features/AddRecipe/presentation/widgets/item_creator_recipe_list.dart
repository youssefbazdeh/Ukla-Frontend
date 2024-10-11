import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/features/AddRecipe/Domain/Entities/creator_recipe.dart';
import 'package:ukla_app/features/AddRecipe/presentation/pages/add_recipe.dart';
import 'package:ukla_app/main.dart';

class ItemCreatorRecipeList extends StatelessWidget {
  final CreatorRecipe recipe;
  final VoidCallback onDelete;

  const ItemCreatorRecipeList({required this.recipe, required this.onDelete, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Provider.of<CreatorRecipePorvider>(context,listen: false).setTitle(recipe.title);
        Provider.of<CreatorRecipePorvider>(context,listen: false).setDescription(recipe.description);
        Provider.of<CreatorRecipePorvider>(context,listen: false).setVideoUrl(recipe.video.sasUrl!);
        Provider.of<CreatorRecipePorvider>(context,listen: false).setId(recipe.id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddRecipePage()),
        );      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 10,right: 10),
            title: Text(recipe.title),
            trailing: IconButton(
              icon: const Icon(Ionicons.close_circle_outline),
              onPressed: onDelete,
            ),
          ),
        ),
      ),
    );
  }
}
