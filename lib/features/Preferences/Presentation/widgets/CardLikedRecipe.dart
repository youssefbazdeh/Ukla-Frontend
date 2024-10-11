import 'package:flutter/material.dart';
import 'package:ukla_app/models/ItemAllegies.dart';

class LikedRecipeCard extends StatefulWidget {
  final Key key;
  final Item item;
  final ValueChanged<bool> isSelected;
  LikedRecipeCard(
      {required this.item, required this.isSelected, required this.key});

  @override
  State<LikedRecipeCard> createState() => _LikedRecipeCardState();
}

class _LikedRecipeCardState extends State<LikedRecipeCard> {
  bool isSelected = false;
  double op = 1;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var containercolor = isSelected
        ? const Color.fromARGB(255, 169, 167, 167)
        : const Color.fromARGB(255, 255, 255, 255);
    return InkWell(
        onTap: () {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
          // isSelected ? op = 0.1 : op = 0;
        },
        child: Container(
          // height: 100,
          // color: Colors.white,
          decoration: BoxDecoration(
              color: containercolor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black)),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(width / 45),
                child: Container(
                  height: width / 4,
                  width: width / 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                    image: DecorationImage(
                      image: AssetImage(widget.item.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: width / 13,
              ),
              Container(
                alignment: AlignmentDirectional.center,
                // height: 80,
                width: width / 4,
                // color: Colors.amberAccent,
                child: Text(
                  widget.item.title,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ));
  }
}
