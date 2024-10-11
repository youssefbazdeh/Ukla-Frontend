import 'package:flutter/material.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/features/view_recipe/Domain/Entities/nutritive_fact.dart';
import 'package:ukla_app/features/view_recipe/Presentation/Widgets/nutritive_fact/nutritive_factCercle.dart';



///nutritive fact whole part

class NutritiveFactsContainer extends StatelessWidget {
  final Map<String, NutritiveFact> nutritivefactvalues;
  const NutritiveFactsContainer({Key? key, required this.nutritivefactvalues})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry nutritiveInfo =
        const EdgeInsets.symmetric(horizontal: 10);
    return Padding(
      padding: nutritiveInfo,
      child: Container(
        color: const Color(0XFFF6F6F6),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NutritiveFactCercle(
                    quantity: '${nutritivefactvalues["Calories"]!.quantity} ',
                    category: "Calories".tr(context),
                    color: const Color(0XFF5CA56A)),
                NutritiveFactCercle(
                    quantity: '${nutritivefactvalues["Proteins"]!.quantity} ${"g".tr(context)}',
                    category: "Proteins".tr(context),
                    pourcentage: nutritivefactvalues["Proteins"]!.pourcentage,
                    color: const Color(0XFFAAD471)),
                NutritiveFactCercle(
                    quantity: '${nutritivefactvalues["Carbs"]!.quantity} ${"g".tr(context)}',
                    category: "Carbs".tr(context),
                    pourcentage: nutritivefactvalues["Carbs"]!.pourcentage,
                    color: const Color(0XFFFEC544))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NutritiveFactCercle(
                    quantity: '${nutritivefactvalues["Fiber"]!.quantity} ${"g".tr(context)}',
                    category: "Fiber".tr(context),
                    pourcentage: nutritivefactvalues["Fiber"]!.pourcentage,
                    color: const Color.fromARGB(255, 92, 165, 143)),
                NutritiveFactCercle(
                    quantity: '${nutritivefactvalues["Sugar"]!.quantity} ${"g".tr(context)}',
                    category: "Sugar".tr(context),
                    pourcentage: nutritivefactvalues["Sugar"]!.pourcentage,
                    color: const Color(0XFFF1975A)),
                NutritiveFactCercle(
                    quantity: '${nutritivefactvalues["Fat"]!.quantity} ${"g".tr(context)}',
                    category: "Fat".tr(context),
                    pourcentage: nutritivefactvalues["Fat"]!.pourcentage,
                    color: const Color(0XFFE44453))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
