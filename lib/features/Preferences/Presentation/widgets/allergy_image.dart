import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import '../../../../core/Data/storage.dart';


class AllergyImage extends StatefulWidget {
  final int imageAllergyId;
  final double height;
  const AllergyImage({
    Key? key,
    required this.imageAllergyId,
    required this.height,
  }) : super(key: key);

  @override
  State<AllergyImage> createState() => _AllergyImageState();
}

class _AllergyImageState extends State<AllergyImage> {
  late Future<Uint8List> getIngredient;
  late Future<String?> getJwt;
  @override
  void initState() {
    getJwt = getjwt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getJwt,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(color: AppColors.secondaryColor, strokeWidth: 2.0,);
          }
          if (snapshot.hasData) {
            return Container(
                height: (widget.height * 0.2),
                width: widget.height * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(
                  "${AppString.SERVER_IP}/ukla/file-system/image/${widget.imageAllergyId}",
                  headers: {
                    'authorization': 'Bearer ${snapshot.data}',
                  },
                  fit: BoxFit.cover,
                ));
          } else {
            return const CircularProgressIndicator(color: AppColors.secondaryColor, strokeWidth: 2.0,);
          }
        }));
  }
}
