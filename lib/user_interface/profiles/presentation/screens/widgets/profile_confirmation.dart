import 'package:sadsha_aurora/shared/data/isar_manager/models/sadsha_aurora_profile_model.dart';
import 'package:sadsha_aurora/user_interface/profiles/presentation/states/profiles_bloc.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_colors.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_dialog.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_snackbar.dart';
import 'package:sadsha_aurora/utility/constants.dart';
import 'package:sadsha_aurora/utility/global_configuration.dart';
import 'package:sadsha_aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileConfirmation extends StatefulWidget {
  const ProfileConfirmation({super.key,
    required this.currentProfile,
    required this.allProfileNames
  });

  final SadShaAuroraProfileModel currentProfile;
  final List<String> allProfileNames;

  @override
  State<ProfileConfirmation> createState() => _ProfileConfirmationState();
}

class _ProfileConfirmationState extends State<ProfileConfirmation> with GlobalMixin{
  late TextEditingController profileNameController;
  final GlobalConfig _globalConfig=Constants.globalConfig;


  @override
  void initState() {
    profileNameController=TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    profileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    void profileConfirmationDialog(){
      sadshaAuroraDialog(
          title: widget.currentProfile.id==2? "Save Profile As":"Rename Profile", subject: '',
          optionalWidget: profileDetails(),
          barrierColor: SadShaAuroraColors.transparent,
          onCancel: ()=>profileNameController.text='',
          onConfirm: (){
            if(profileNameController.text.isNotEmpty) {
              if(widget.currentProfile.profileName!=profileNameController.text&&
                  widget.allProfileNames.any((element) => element==profileNameController.text)){
                sadshaAuroraSnackBar(text: '${profileNameController.text} already exists! Try a different name',isPositive: false);
              }else {
                Navigator.pop(context);
                context.read<ProfilesBloc>().add(ProfilesSaveEvent(name: profileNameController.text));
                profileNameController.text='';
              }
            }else{
              Navigator.pop(context);
            }
          });
    }

    return IconButton(
        onPressed: () {
          profileConfirmationDialog();
        },
        tooltip: '${widget.currentProfile.id==2?"save":"rename"} profile',
        icon: Icon(
          widget.currentProfile.id==2?
          Icons.save:
          Icons.drive_file_rename_outline,
          size: 15.sp,
        ));

  }

  Widget profileDetails() {

    String getStateValues(){
      List values=[];
      for(int i = 0; i< Constants.stateTitle.length;i++){
        if(widget.currentProfile.sadshaAuroraState.props[i]==true){
          values.add(Constants.stateTitle[i]);
        }
      }
      return values.join(', ');
    }

    InputBorder border =OutlineInputBorder(
      borderSide: BorderSide(color: Color(widget.currentProfile.sadshaAuroraMode.colorRad!)));

    Widget listItem({required String title,required String text}){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Container()),
          Expanded(child: Text(title)),
          const Expanded(child: Center(child: Text(":"))),
          Expanded(child: Container()),
          Expanded(child: Text(text)),
        ],
      );
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        IntrinsicWidth(
          child: TextField(
            controller: profileNameController,
            decoration: InputDecoration(hintText: widget.currentProfile.profileName,
              focusedBorder: border,
              enabledBorder: border,
              ),
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if(_globalConfig.isBatteryManagerEnabled)
              listItem(title: 'Threshold', text: '${widget.currentProfile.threshold}'),
              if(_globalConfig.isBacklightControllerEnabled)
                Column(children: [
                  listItem(title: 'Brightness', text: Constants.brightnessTitle[widget.currentProfile.brightness]),
                  listItem(title: 'Mode', text: Constants.modeTitle[widget.currentProfile.sadshaAuroraMode.mode!]),
                  listItem(title: 'Speed', text: Constants.speedTitle[widget.currentProfile.sadshaAuroraMode.speed!]),
                  if(super.isMainLine())
                    listItem(title: 'State', text: getStateValues()),
                ],),
              const SizedBox.shrink()
            ],
          ),
        ),
          Container()

      ],);
  }
}

