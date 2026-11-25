import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_colors.dart';
import 'package:flutter/material.dart';

class SadShaAuroraCheckbox extends StatelessWidget{

   const SadShaAuroraCheckbox({
    required this.text,
    required this.isSelected,
    required this.onChange,
    super.key,
  });

  final String text;
  final bool isSelected;
  final Function onChange;

   WidgetStateProperty<Color> getMaterialColor(Color color)=>
      WidgetStateProperty.all<Color>(color);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          checkboxTheme: CheckboxThemeData(
            fillColor: getMaterialColor(isSelected?SadShaAuroraColors.red:SadShaAuroraColors.transparent),
            checkColor:  getMaterialColor(SadShaAuroraColors.white),
            overlayColor:  getMaterialColor(SadShaAuroraColors.orange),
            side: const BorderSide(
              color: SadShaAuroraColors.red,
              width: 1,
            ),
          )
      ),
      child: CheckboxListTile(
        title: Text(text),
        value: isSelected,
        onChanged: (value)=> onChange(value),
      ),
    );
  }

}