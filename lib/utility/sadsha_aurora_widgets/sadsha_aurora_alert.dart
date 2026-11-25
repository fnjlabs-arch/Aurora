import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_button.dart';
import 'package:sadsha_aurora/utility/constants.dart';
import 'package:flutter/material.dart';

void sadshaAuroraAlert({required List<Widget> actions, String content=''}) {
  showDialog(
    barrierDismissible: false,
    context: Constants.kScaffoldKey.currentState!.context,
    builder: (context) {
    return AlertDialog(
      title: const Text('Are You Sure?'),
      content: Text(content),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ...actions,
        SadShaAuroraButton(title: 'Cancel', action: () => Navigator.of(context).pop()),
      ],);
  },);
}