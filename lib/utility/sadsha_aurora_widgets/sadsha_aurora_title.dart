import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_colors.dart';
import 'package:flutter/material.dart';

Widget sadshaAuroraTitle(){

  return Center(
    child: AnimatedTextKit(
      animatedTexts: [
        ColorizeAnimatedText(
          'SadSha Aurora',
          textStyle:  const TextStyle(
            fontSize: 50,
          ),
          colors: [
            SadShaAuroraColors.red,
            SadShaAuroraColors.pink,
            SadShaAuroraColors.orange,
            SadShaAuroraColors.yellow,
            SadShaAuroraColors.green,
            SadShaAuroraColors.purpleDark,
            SadShaAuroraColors.blue,
            SadShaAuroraColors.cyan,
          ],
        ),
      ],
      isRepeatingAnimation: true,
      repeatForever: true,
    ),
  );
}

