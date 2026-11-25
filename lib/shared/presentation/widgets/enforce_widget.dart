import 'package:sadsha_aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:sadsha_aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_widgets.dart';
import 'package:sadsha_aurora/utility/constants.dart';
import 'package:sadsha_aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnforceWidget extends StatelessWidget with GlobalMixin {
  const EnforceWidget({super.key});

  @override
  Widget build(BuildContext context) {

    if(isMainLine()){
      return showEnforcementDialog(context, enforcement: Enforcement.faustus);
    }

    if(Constants.globalConfig.isFaustusEnforced){
      return showEnforcementDialog(context, enforcement: Enforcement.mainline);
    }

    return const SizedBox();
  }

  Widget showEnforcementDialog(BuildContext context,{required Enforcement enforcement}){
    String title="Enforce ${enforcement==Enforcement.faustus?'Faustus':"Mainline"} Mode";
    return SadShaAuroraButton(
        animate: false,
        title: title, action: (){
          sadshaAuroraDialog(
              title: title,
              subject: "This will disable and blacklist\n${enforcement==Enforcement.faustus?"- asus_wmi\n- asus_nb_wmi":'- faustus'}\nand force SadSha Aurora to run in ${enforcement==Enforcement.faustus?"faustus":"Mainline"} mode",
              onConfirm: (){
                context.read<HomeBloc>().add(HomeEventEnforcement(enforcement));
              }
          );
    });
  }
}
