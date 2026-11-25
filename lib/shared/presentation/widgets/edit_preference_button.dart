import 'package:sadsha_aurora/user_interface/preferences/presentation/screens/preferences.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_widgets.dart';
import 'package:sadsha_aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';

class EditPreferencesButton extends StatelessWidget with GlobalMixin {
  const EditPreferencesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SadShaAuroraButton(
      action: () async {
        showPreferencesDialog();
      },
      title: "Edit Preferences",
      animate: false,
    );
  }
}
