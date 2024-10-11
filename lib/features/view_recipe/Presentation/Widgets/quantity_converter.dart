import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ukla_app/features/view_recipe/Domain/Entities/unit_alternatives.dart';

class QuantityConverter extends StatefulWidget {
  final List<UnitAlternative> list;
  final String unit;
  final double quantity;
  final bool update;
  const QuantityConverter({Key? key, required this.list, required this.unit, required this.quantity, required this.update})
      : super(key: key);

  @override
  State<QuantityConverter> createState() => _QuantityConverterState();
}

class _QuantityConverterState extends State<QuantityConverter> {
  late UnitAlternative selectedUnit;
  late String quantityValue;
  late double q;
  @override
  void initState() {
    super.initState();
    selectedUnit = widget.list.firstWhere((item) => item.unit == widget.unit); //todo  this line is causing en erreur 
//       selectedUnit = widget.list.firstWhere(  //todo we can replace it with this line to remove the error but logic won't be fixed the units be will be completely wrong. the basic unit must be selected first the logic of this widget needs to be checked.   
//   (item) => item.unit == widget.unit,
//   orElse: () => widget.list.first, // Fallback to the first element if no match is found
// );
    if (widget.quantity == widget.quantity.truncateToDouble()) {
      quantityValue = widget.quantity.truncate().toStringAsFixed(0);
    } else {
      quantityValue = widget.quantity.toStringAsFixed(2);
    }
    q = selectedUnit.conversionRate * widget.quantity;
  }

  @override
  void didUpdateWidget(covariant QuantityConverter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.update) {
      setState(() {
        selectedUnit = widget.list.firstWhere((item) => item.unit == widget.unit);
        if (widget.quantity == widget.quantity.truncateToDouble()) {
          quantityValue = widget.quantity.truncate().toStringAsFixed(0);
        } else {
          quantityValue = widget.quantity.toStringAsFixed(2);
        }
        q = selectedUnit.conversionRate * widget.quantity;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(quantityValue, style: const TextStyle(
            fontSize: 17,
            fontWeight:
            FontWeight.w600)),
        const SizedBox(width: 5),
        DropdownButtonHideUnderline(
          child: DropdownButton2<UnitAlternative>(
            value: selectedUnit,
            customButton: Center(child: Text(selectedUnit.unit)),
            openWithLongPress: true,
            items: widget.list
                .map((item) {
              final isSelected = item.unit == selectedUnit.unit;
              return DropdownMenuItem<UnitAlternative>(
                value: item,
                child: Text(item.unit,style: TextStyle(color: isSelected ? Colors.red : Colors.black,)),
              );
            }
            )
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedUnit = value as UnitAlternative;
                if(value.conversionRate == 1){
                  if(q == q.truncateToDouble()){
                    quantityValue = q.truncate().toStringAsFixed(0);
                  }else{
                    quantityValue = q.truncate().toStringAsFixed(2);
                  }
                }else{
                  double x = q / value.conversionRate;
                  if(x == x.truncateToDouble()){
                    quantityValue = x.truncate().toStringAsFixed(0);
                  }else{
                    quantityValue = x.truncate().toStringAsFixed(2);
                  }
                }
              });
            },
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              width: 100,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              customHeights: List<double>.filled(widget.list.length, 48),
              padding: const EdgeInsets.only(left: 16, right: 16),
            ),
          ),
        ),
      ]
    );
  }
}
