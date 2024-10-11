import 'package:flutter/material.dart';
import '../resources/colors_manager.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator
({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(color: AppColors.secondaryColor,strokeWidth: 2.0);
  }
}