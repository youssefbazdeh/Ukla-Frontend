import 'package:flutter/material.dart';

import '../resources/colors_manager.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({super.key, 
    required String message,
    // we can add action Label if when needed
  }) : super(
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.only(right: 10,left: 10,bottom: 10),
    backgroundColor: AppColors.buttonTextColor,
    content: Text(
      message,
    ),
  );
}
