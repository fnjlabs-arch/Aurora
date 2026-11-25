import 'package:sadsha_aurora/user_interface/setup/presentation/screens/widgets/changelog_container.dart';
import 'package:sadsha_aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:sadsha_aurora/user_interface/setup/presentation/state/setup_event.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateWidget extends StatelessWidget{
  const UpdateWidget({super.key,required this.changelog});

  final String changelog;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("A new update is available"),
        Row(
          children: [
            changelogContainer(changelog: changelog),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SadShaAuroraButton(
                isSelected: true,
                title: "Download\nupdate", action:() => context.read<SetupBloc>().add(SetupEventLaunch())),
            SadShaAuroraButton(
                edgeInsets: const EdgeInsets.only(left: 10),
                title: "Ignore",
                action: (){
              context.read<SetupBloc>().add(SetupEventOnUpdate(ignoreUpdate: true));
            }),
          ],
        )

      ],
    );
  }

}