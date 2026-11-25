import 'package:sadsha_aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:sadsha_aurora/user_interface/setup/presentation/state/setup_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sadsha_aurora_request_dialog.dart';

class SadShaAuroraKernelCompatibleDialog extends StatelessWidget {
  const SadShaAuroraKernelCompatibleDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return sadshaAuroraRequestDialog(title: 'Your kernel might support keyboard backlit without using faustus module.\n Would you like to give it a try?',
        buttonTitle1: "Nope",
        buttonTitle2: "Okay",
        onClickButton1: (){
          context.read<SetupBloc>().add(SetupEventCompatibleKernel());
        },
        onClickButton2: (){
          context.read<SetupBloc>().add(SetupEventCompatibleKernel(removeFaustus: true));
        }
    );
  }
}
