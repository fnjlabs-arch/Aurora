import 'package:sadsha_aurora/user_interface/terminal/presentation/state/terminal_bloc.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_alert.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClearCacheWidget extends StatelessWidget {
  const ClearCacheWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SadShaAuroraButton(
      title: "Clear Cache",
      animate: false,
      action: () {
        sadshaAuroraAlert(
            content: "Settings will be restored back to default",
            actions: [
              SadShaAuroraButton(
                  title: "Yes",
                  action: () => context.read<TerminalBloc>().clearCache()
              )
            ]);
      });
  }

}