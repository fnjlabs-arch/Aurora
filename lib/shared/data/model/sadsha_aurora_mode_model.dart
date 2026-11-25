
import 'dart:ui';

import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_colors.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';

part 'sadsha_aurora_mode_model.g.dart';

@Embedded(inheritance: false)
//ignore: must_be_immutable
class SadShaAuroraMode extends Equatable {
   int? mode;
   int? speed;

  @ignore
   Color? color;
   int? colorRad;


   SadShaAuroraMode({this.mode, this.speed, this.color, this.colorRad});

  factory SadShaAuroraMode.copyModel(SadShaAuroraMode model)=>
      SadShaAuroraMode(
        mode: model.mode,
        speed: model.speed,
        color: model.color,
        colorRad: model.colorRad?? model.color!.toARGB32()
      );

  factory SadShaAuroraMode.fromJson(Map<String, dynamic> json){
    int colorInt=int.tryParse(json['color'].replaceAll("Color(0x", "").replaceAll(")", ""), radix: 16)??SadShaAuroraColors.accentColor.toARGB32();

    return SadShaAuroraMode(
        colorRad: colorInt,
        color: Color(colorInt),
        mode: json['mode'],
        speed: json['speed'],
    );
  }

  @override
  @ignore
  List<Object?> get props => [mode, speed, colorRad];

}