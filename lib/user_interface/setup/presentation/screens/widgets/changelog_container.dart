import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_colors.dart';
import 'package:flutter/material.dart';

Widget changelogContainer({required String changelog}){
  return Expanded(child: Container(
      margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      decoration:  BoxDecoration(
          border: Border.all(color: SadShaAuroraColors.accentColor)
      ),
      child: SingleChildScrollView(child: Text(changelog))));
}