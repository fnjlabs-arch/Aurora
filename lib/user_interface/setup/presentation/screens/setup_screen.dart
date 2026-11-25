
import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:sadsha_aurora/user_interface/setup/presentation/screens/widgets/sadsha_aurora_request_dialog.dart';
import 'package:sadsha_aurora/user_interface/setup/presentation/screens/widgets/stepper_widget.dart';
import 'package:sadsha_aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:sadsha_aurora/user_interface/setup/presentation/state/setup_event.dart';
import 'package:sadsha_aurora/user_interface/setup/presentation/state/setup_state.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext ctx) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: BlocBuilder<SetupBloc,SetupState>(
        builder: (BuildContext context, state) {
          
          void configureFaustus(){
            context.read<SetupBloc>().add(SetupEventConfigure(allow: true)); 
          }

          if(state is SetupPermissionState){
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("SadSha Aurora wants to configure your system"),
                SadShaAuroraButton(title: "Allow",
                    action: ()=> configureFaustus()
                )
              ],
            );
          }

          if(state is SetupBatteryManagerCompatibleState){
            return sadshaAuroraRequestDialog(
                title: "Faustus Module is missing. Proceed anyway??",
              buttonTitle2: "Configure Faustus",
              onClickButton1: ()=> context.read<SetupBloc>().add(SetupEventBatteryManagerMode()),
              onClickButton2: ()=>configureFaustus()
            );
          }

          if(state is SetupIncompatibleState){

            List<StepperData> stepperData = [
              stepperListData(
                  text: state.stepValue==0?"I'm Here": 'I Came',
                  stepValue: state.stepValue,
                  index: 0),
              stepperListData(
                  text: state.stepValue>0?'I Saw':"I might see something",
                  stepValue: state.stepValue,
                  index: 1),
              stepperListData(
                  text: state.stepValue==2? 'I Conquered':'I think I can conquer',
                  stepValue: state.stepValue,
                  index: 2)

            ];
            return  Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AnotherStepper(
                      stepperList: stepperData,
                      stepperDirection: Axis.horizontal,
                      activeBarColor: SadShaAuroraColors.purple,
                      activeIndex: state.stepValue,
                      inActiveBarColor: SadShaAuroraColors.grey,
                      inverted: true,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child:state.child??placeholder(),
                  ),
                  BlocBuilder<SadShaAuroraButtonCubit,bool>(
                    builder: (BuildContext context, isLoading) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SadShaAuroraButton(
                              isEnabled: state.isValid,
                              isLoading: isLoading,
                              isSelected: true,
                              title: "Install", action: ()async{
                               context.read<SetupBloc>().add(SetupEventOnInstall(stepValue: state.stepValue));
                          }),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SadShaAuroraButton(
                                isEnabled: state.isValid&&!isLoading,
                                title: state.stepValue>0?"Back":"Cancel", action: (){
                                  context.read<SetupBloc>().add(SetupEventOnCancel(stepValue: state.stepValue));
                            }),
                          ),
                        ],
                      );
                    },

                  ),
                ]);
          }else{
            return placeholder();
          }
        },
      ),
    );
  }
}