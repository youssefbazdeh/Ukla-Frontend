import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ukla_app/features/groceries/Data/grocery_list_service.dart';

////Ingredient image
class RecipeImage extends StatefulWidget {
  final int recipeImageId;
  const RecipeImage({Key? key, required this.recipeImageId}) : super(key: key);

  @override
  State<RecipeImage> createState() => _RecipeImageState();
}

class _RecipeImageState extends State<RecipeImage> {
  late Future<Uint8List> getImage;

  @override
  void initState() {
    getImage = getRecipeImage(widget.recipeImageId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getImage,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              height: 50,
              width: 50,
            );
          } else if (snapshot.hasData) {
            Uint8List imageBytes = snapshot.data as Uint8List;
            //return the image
            return Container(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              height: 50,
              width: 50,
              child:
                  FittedBox(fit: BoxFit.cover, child: Image.memory(imageBytes)),
            );
          } else {
            return Container(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              height: 50,
              width: 50,
            );
          }
        }));
  }
}
