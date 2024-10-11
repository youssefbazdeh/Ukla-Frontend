import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import '../../../../core/Data/storage.dart';


class IngredientImage extends StatefulWidget {
  final int ingredientId;
  const IngredientImage({Key? key, required this.ingredientId})
      : super(key: key);

  @override
  State<IngredientImage> createState() => _IngredientImageState();
}

class _IngredientImageState extends State<IngredientImage> {
  late Future<Uint8List> getIngredient;
  late Future<String?> getJwt;
  @override
  void initState() {
    //getting images from database will be suspended do nnot delete
    //getIngredient = SqliteService.getIngredient(widget.ingredientId);
    getJwt = getjwt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getJwt,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const  CircularProgressIndicator(color: AppColors.secondaryColor, strokeWidth: 2.0,);
          }
          if (snapshot.hasData) {
            return Container(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                height: 40,
                width: 40,
                child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.network(
                        "${AppString.SERVER_IP}/ukla/file-system/image/${widget.ingredientId}",
                        headers: {
                          'authorization': 'Bearer ${snapshot.data}',
                        },
                        fit: BoxFit.cover)));
          } else {
            return const  CircularProgressIndicator(color: AppColors.secondaryColor, strokeWidth: 2.0,);
          }

          //getting images from database will be suspended, shouldn't be deleted
          /*     return FutureBuilder(
              future: getjwt(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0),
                      child: ClipOval(
                          child: Image.network(
                        "${AppString.SERVER_IP}/ukla/file-system/image/${widget.ingredientId}",
                        headers: {
                          'authorization': 'Bearer ${snapshot.data}',
                        },
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                      )));
                } else {
                  return const CircularProgressIndicator();
                }
              });*/
          /*      if (snapshot.hasData) {
            Uint8List imageBytes = snapshot.data as Uint8List;
            //return the image
            return CircleAvatar(
                backgroundColor:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0),
                child: ClipOval(
                    child: Image.memory(
                  imageBytes,
                  fit: BoxFit.cover,
                  height: 80,
                  width: 80,
                )));
        
          }*/
        }));
  }
}
