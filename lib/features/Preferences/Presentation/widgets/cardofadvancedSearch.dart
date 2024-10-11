import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdvancedSearchedCard extends StatefulWidget {
  const AdvancedSearchedCard({
    required this.cardTitle,
    required this.onTagSelected,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  final String cardTitle;
  final Function(bool) onTagSelected;
  final bool isSelected;

  @override
  State<AdvancedSearchedCard> createState() => _AdvancedSearchedCardState();
}

class _AdvancedSearchedCardState extends State<AdvancedSearchedCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onTagSelected(!widget.isSelected);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            border: Border.all(
              color: const Color(0XFF8B8B8B),
              width: 1,
            ),
            color: widget.isSelected ? Colors.red : null,
          ),
            child: Text(
              widget.cardTitle,
              style: TextStyle(
                fontSize: 15.sp,
            ),
          ),
        ),
      ),
    );
  }
}
