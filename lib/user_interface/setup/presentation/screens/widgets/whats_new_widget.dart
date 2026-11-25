import 'package:sadsha_aurora/user_interface/setup/presentation/screens/widgets/changelog_container.dart';
import 'package:sadsha_aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:sadsha_aurora/user_interface/setup/presentation/state/setup_event.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_widgets.dart';
import 'package:sadsha_aurora/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WhatsNewWidget extends StatelessWidget{
  const WhatsNewWidget({required this.changelog, super.key});

  final String changelog;

  @override
  Widget build(BuildContext context) {
   return Column(
     mainAxisAlignment: MainAxisAlignment.center,
     mainAxisSize: MainAxisSize.min,
     crossAxisAlignment: CrossAxisAlignment.stretch,
     children: [
     Center(child: Text("Whats new in v${Constants.globalConfig.sadshaAuroraVersion}")),
     changelogContainer(changelog: changelog),
     Center(
       child: SadShaAuroraButton(
           title: "Okay",
           isSelected: true,
           action: (){
             context.read<SetupBloc>().add(SetupEventOnUpdate(ignoreUpdate: false));
           }),
     )
   ],);
  }

}