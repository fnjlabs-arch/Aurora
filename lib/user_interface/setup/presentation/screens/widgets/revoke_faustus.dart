import 'package:sadsha_aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:sadsha_aurora/user_interface/setup/presentation/state/setup_event.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_button.dart';
import 'package:sadsha_aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RevokeFaustus extends StatelessWidget{
  const RevokeFaustus({super.key});

  @override
  Widget build(BuildContext context) {
    return Constants.globalConfig.isFaustusEnforced?SadShaAuroraButton(
        animate: false,
        title: "Revoke Faustus",
        action: (){
      context.read<SetupBloc>().add(SetupEventCompatibleKernel(removeFaustus: true));
    }):Container();
  }
}