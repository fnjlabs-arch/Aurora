import 'package:sadsha_aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:sadsha_aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivilegedRunButton extends StatelessWidget {
  const PrivilegedRunButton({super.key});

  @override
  Widget build(BuildContext context) =>
      SadShaAuroraButton(title: "Run With Elevated Privileges",
          animate: false,
          action: ()=> context.read<HomeBloc>().add(HomeEventRunAsRoot())
      );
}
