import 'package:sadsha_aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:sadsha_aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_button.dart';
import 'package:sadsha_aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoggerButton extends StatelessWidget {
  const LoggerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SadShaAuroraButton(
        animate: false,
        title: "${Constants.globalConfig.isLoggingEnabled?'Dis':'En'}able logging", action: (){
      context.read<HomeBloc>().add(HomeEventEnableLogging());
      Navigator.pop(context);
    });
  }
}
