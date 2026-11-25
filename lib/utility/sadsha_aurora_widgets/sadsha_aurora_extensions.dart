import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/cubits/color_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension SadShaAuroraContextExt on BuildContext{
  Color get selectedColor=>  watch<SadShaAuroraColorCubit>().selectedColor;
  Color get selectedColorWithAlpha=>  watch<SadShaAuroraColorCubit>().selectedColorWithAlpha;
  Color get invertedColor=>  watch<SadShaAuroraColorCubit>().invertedColor;
}