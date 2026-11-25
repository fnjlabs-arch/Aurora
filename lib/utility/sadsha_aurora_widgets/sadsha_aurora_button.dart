import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SadShaAuroraButton extends StatefulWidget {
  const SadShaAuroraButton({
    super.key,
    required this.title,
    required this.action,
    this.isSelected = false,
    this.isEnabled = true,
    this.isLoading = false,
    this.animate = true,
    this.edgeInsets
  });

  final String title;
  final Function action;
  final bool isSelected;
  final bool isEnabled;
  final bool isLoading;
  final bool animate;
  final EdgeInsetsGeometry? edgeInsets;

  @override
  State<SadShaAuroraButton> createState() {
    return _ArButtonState();
  }
}

class _ArButtonState extends State<SadShaAuroraButton> {
  late double height;
  late double width;

  @override
  void initState() {
    super.initState();
  }

  void _setBounds(){
    height = widget.isSelected ? 7.h : 6.h;
    width = widget.isSelected ? 11.w : 10.w;
  }

  @override
  Widget build(BuildContext context) {
    _setBounds();
    return BlocProvider(
      create: (BuildContext context) => SadShaAuroraButtonHoverCubit(),
      child: BlocBuilder<SadShaAuroraButtonHoverCubit,bool>(
        builder: (BuildContext context, hover)=>
         Container(
          margin: widget.edgeInsets,
          padding: EdgeInsets.symmetric(vertical: 1.5.h,horizontal: .5.w),
          child: widget.isLoading && widget.isSelected
              ? SizedBox(
                  height: height,
                  width: width,
                  child: LinearProgressIndicator(
                    color: context.read<SadShaAuroraColorCubit>().selectedColor,
                  ))
              : InkWell(
                  onHover: context.read<SadShaAuroraButtonHoverCubit>().setHover,
                  onTap: () async {
                    if (widget.isEnabled) {
                      await widget.action();
                    }
                  },
                  child: animationHandler(
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: widget.isEnabled
                              ? widget.isSelected || hover
                              ? context.selectedColor
                              : SadShaAuroraColors.greyDisabled!
                              : SadShaAuroraColors.grey,),
                            color: widget.isEnabled
                              ? widget.isSelected
                              ? context.selectedColorWithAlpha
                              : null
                              : SadShaAuroraColors.grey,
                        ),
                        child: Center(
                            child:
                             Text(
                               widget.title,
                               textAlign: TextAlign.center,
                             )),
                      ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget animationHandler({required Widget child}){
    return widget.animate?
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: width,
          height: height,
          child: child,
        ):
        FittedBox(child: child,);

  }
}

class ButtonAttribute<T> {
  String title;
  T? value;

  ButtonAttribute({required this.title, this.value});
}
