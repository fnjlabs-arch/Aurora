
import 'package:sadsha_aurora/shared/terminal/shared_terminal.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'sadsha_aurora_enums.dart';

Widget sadshaAuroraTerminal(TerminalText terminalText){

  Color commandColor(CommandStatus commandStatus) {
    if (commandStatus == CommandStatus.stdinp) {
      return SadShaAuroraColors.blue;
    } else if (commandStatus == CommandStatus.stdout) {
      return SadShaAuroraColors.green;
    } else {
      return SadShaAuroraColors.red;
    }
  }


  return Text(terminalText.text,style: TextStyle(color: commandColor(terminalText.commandStatus)));
}