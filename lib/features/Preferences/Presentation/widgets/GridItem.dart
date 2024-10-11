import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../models/item_allergies.dart';
import 'allergy_image.dart';

class GridItem extends StatefulWidget {
  
  final Key key;
  final ItemAllergies item;
  final ValueChanged<bool> isSelected;
  final bool initallySelected;

  // ignore: use_key_in_widget_constructors
  const GridItem(
      { required this.item,
      required this.isSelected,
      required this.key,
      required this.initallySelected});

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool isSelected = false;
  double op = 0.45;

  @override
  void initState() {
    setState(() {
      widget.initallySelected ? op = 0.5 : op = 0.2;
      if (widget.initallySelected) {
        isSelected = !isSelected;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    // Color grey = const Color(0XFFF4F4F4);
    double height2;
    var width2 = (height * 0.2);
    /*  i made this condition to ensure that text will fit the shadow container   */
    widget.item.title.length >= 20
        ? height2 = (height * 0.2)
        : height2 = (height * 0.2) / 2;

    if (widget.item.title != "") {
      return Stack(alignment: AlignmentDirectional.bottomStart, children: [
        Container(
          decoration: isSelected
              ? BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 96, 97, 100),
                    width: 2.8,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                )
              : const BoxDecoration(),
          child: InkWell(
            onTap: () {
              setState(() {
                isSelected = !isSelected;
                widget.isSelected(isSelected);
                isSelected ? op = 0.5 : op = 0.2;
              });
            },
            child: Stack(fit: StackFit.expand, children: [
              AllergyImage(
                imageAllergyId: widget.item.imageId,
                height: height,
              ),
              Positioned(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected = !isSelected;
                      widget.isSelected(isSelected);
                      isSelected ? op = 0.5 : op = 0.2;
                    });
                  },
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 121, 118, 118)
                                .withOpacity(0)),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              isSelected = !isSelected;
              widget.isSelected(isSelected);
              isSelected ? op = 0.5 : op = 0.2;
            });
          },
          child: Container(
            alignment: AlignmentDirectional.bottomCenter,
            height: height2,
            width: width2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: <Color>[
                  const Color.fromARGB(255, 23, 22, 22).withOpacity(op),
                  const Color(0xff000000).withOpacity(0),
                ], // Gradient from ht
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: width / 30, right: 2, left: 2),
              child: Text(
                widget.item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color(0XFFfFFFFF),
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ]);
    } else {
      return InkWell(
        onTap: (() {
     
        }),
        child: Stack(alignment: AlignmentDirectional.center, children: [
          Stack(fit: StackFit.expand, children: [
            Container(
              width: height * 0.2,
              height: height * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0XFFE1E1E1),
              ),
            ),
            Positioned(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0)),
                  ),
                ),
              ),
            ),
          ]),
          Container(
            alignment: AlignmentDirectional.center,
            child: Icon(
              Icons.add_circle,
              size: (height * 0.2) / 2.5,
              color: const Color(0XFF5E5E5E),
            ),
          ),
        ]),
      );
    }
  }
}
