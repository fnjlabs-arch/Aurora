import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_widgets.dart';
import 'package:flutter/cupertino.dart';

Widget sadshaAuroraRequestDialog({
  required String title,
  String? buttonTitle1,
  String? buttonTitle2,
  Function? onClickButton1,
  Function? onClickButton2
}){
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(title),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SadShaAuroraButton(title: buttonTitle1??"Okay",
              action: (){
                if(onClickButton1!=null) {
                  onClickButton1();
                }
              }),
          SadShaAuroraButton(
              isSelected: true,
              edgeInsets: const EdgeInsets.only(left: 10),
              title: buttonTitle2??"Cancel",
              action: () {
                if(onClickButton2!=null){
                  onClickButton2();
                }
              }
          )
        ],)
    ],
  );
}