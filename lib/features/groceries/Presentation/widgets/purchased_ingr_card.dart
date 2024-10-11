import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ukla_app/core/Presentation/components/ingredient_quantity_object_text.dart';
import '../../../../main.dart';
import '../../../view_recipe/Presentation/Widgets/ingredient_image.dart';
import '../../Domain/Entities/grocery_ingredient.dart';
import '../../Domain/Entities/grocery_list.dart';
import '../../Domain/logic.dart';
import '../bloc/grocery_bloc.dart';
import '../bloc/grocery_event.dart';

class PurchasedIngredientCard extends StatefulWidget {
  final GroceryIngredient ingredient;
  final bool groceryByCategory;
  final GroceryList groceryList;

  const PurchasedIngredientCard(
      {super.key,
      required this.ingredient,
      required this.groceryByCategory,
      required this.groceryList});

  @override
  State<PurchasedIngredientCard> createState() =>
      _PurchasedIngredientCardState();
}

class _PurchasedIngredientCardState extends State<PurchasedIngredientCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    String contentLanguageCode =
        Provider.of<SelectedContentLanguage>(context, listen: false)
            .contentLanguageCode;
    String quantity;
    if (widget.ingredient.quantity ==
        widget.ingredient.quantity!.truncateToDouble()) {
      quantity = widget.ingredient.quantity!.truncate().toStringAsFixed(0);
    } else {
      quantity = widget.ingredient.quantity.toString();
    }
    String ingredientAdDisplayText = widget.ingredient.brandName!= null? " ${widget.ingredient.brandName} " : "";
    String fullIngredientName = "${widget.ingredient.ingredientName} $ingredientAdDisplayText";
    int? imageIdToPass = widget.ingredient.ingredientAdImageId ?? widget.ingredient.ingredientImageID!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0X80F6F6F6),
        ),
        child: Row(children: [
          GestureDetector(
            onTap: () {
              if (widget.groceryByCategory == true) {
                BlocProvider.of<GroceryBloc>(context).add(
                    UnpurchaseIngredient(
                        getAllindexes(widget.groceryList, widget.ingredient.ingredientName!),
                        Provider.of<SelectedContentLanguage>(context, listen: false).contentLanguageCode,
                        widget.ingredient.ingredientName!
                    )
                );

              } else {
                BlocProvider.of<GroceryBloc>(context).add(
                    UnpurchaseIngredient(
                        [widget.ingredient.ingredientId!],
                        Provider.of<SelectedContentLanguage>(context, listen: false).contentLanguageCode,
                        widget.ingredient.ingredientName!
                    )
                );
              }
            },
            child: Container(
              height: 25,
              width: 25,
              child: const Icon(Ionicons.checkmark_outline),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IngredientImage(ingredientId:imageIdToPass),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: width * 0.35,
            child: ingredientQuantityObjectText(contentLanguageCode, quantity,widget.ingredient.unit!,fullIngredientName),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {
                if (widget.groceryByCategory == true) {
                  BlocProvider.of<GroceryBloc>(context).add(RemoveIngredient(getAllindexes(widget.groceryList, widget.ingredient.ingredientName!, true), Provider.of<SelectedContentLanguage>(context, listen: false).contentLanguageCode,widget.ingredient));
                } else {
                  BlocProvider.of<GroceryBloc>(context).add(RemoveIngredient([widget.ingredient.ingredientId!], Provider.of<SelectedContentLanguage>(context, listen: false).contentLanguageCode,widget.ingredient));
                }
              },
              icon:
                  const Icon(Ionicons.close_outline, color: Color(0xFF989898)))
        ]),
      ),
    );
  }
}
