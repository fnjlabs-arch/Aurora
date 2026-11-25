import 'package:sadsha_aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:sadsha_aurora/user_interface/home/presentation/state/home_state.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_extensions.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_top_buttons.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_colors.dart';
import 'package:sadsha_aurora/utility/constants.dart';
import 'package:sadsha_aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeTopBar extends StatelessWidget with GlobalMixin {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
   return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: SadShaAuroraWindowButtons()),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Text("SadSha Aurora",style: Theme.of(context).textTheme.headlineLarge!.apply(color: context.selectedColor),),
              Text("\tv${Constants.globalConfig.sadshaAuroraVersion}",style: TextStyle(fontSize: 1.5.w,fontWeight: FontWeight.bold),),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: context.selectedColorWithAlpha,
                        width: 3.0
                    ),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(15.0)
                    ),
                    color: context.selectedColorWithAlpha
                ),
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                child: Text(super.isMainLine()?"Mainline":"Faustus"),
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Constants.globalConfig.deviceName,textAlign: TextAlign.end,),
                BlocBuilder<HomeBloc, HomeState>(builder: (context,state){
                  if(state.loggingEnabled) {
                    return const Text("logging enabled", style: TextStyle(color: SadShaAuroraColors.orange,fontWeight: FontWeight.bold),textAlign: TextAlign.end,);
                  }
                  return const SizedBox();
                },)
            ],
          ),
        )
      ],);
  }
}
