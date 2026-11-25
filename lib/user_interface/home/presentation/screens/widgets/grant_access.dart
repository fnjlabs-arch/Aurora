import 'package:sadsha_aurora/user_interface/home/presentation/screens/widgets/privileged_run_button.dart';
import 'package:sadsha_aurora/user_interface/home/presentation/state/home_bloc.dart';
import 'package:sadsha_aurora/user_interface/home/presentation/state/home_event.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget grantAccess(BuildContext context,{bool runAsRoot=false, required List<String> deniedList}){
  return Column(
    children: [
      Expanded(
        flex: 7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(deniedList.isNotEmpty)
            Text('SadSha Aurora needs access to:',style: Theme.of(context).textTheme.titleMedium,textAlign: TextAlign.start),
            Flexible(child: Text(deniedList.join('\n'),style: const TextStyle(color: SadShaAuroraColors.grey),)),
            SadShaAuroraButton(title: "Grant Access",
                isSelected: true,
                action: ()=> context.read<HomeBloc>().add(HomeEventRequestAccess())
            ),
          ],
        ),
      ),
      if(runAsRoot)
      const Expanded(child:  Center(
        child: PrivilegedRunButton()
      ),)
    ],
  );
}