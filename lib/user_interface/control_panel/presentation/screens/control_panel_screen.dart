import 'package:sadsha_aurora/user_interface/battery_manager/battery_manager.dart';
import 'package:sadsha_aurora/user_interface/control_panel/presentation/screens/drawer/sadsha_aurora_drawer.dart';
import 'package:sadsha_aurora/user_interface/keyboard_settings/keyboard_settings.dart';
import 'package:sadsha_aurora/user_interface/profiles/presentation/screens/profile_panel.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_colors.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_enums.dart';
import 'package:sadsha_aurora/utility/constants.dart';
import 'package:sadsha_aurora/utility/global_configuration.dart';
import 'package:sadsha_aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';


class ControlPanelScreen extends StatefulWidget {
  const ControlPanelScreen({super.key});

  @override
  State<ControlPanelScreen> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanelScreen> with GlobalMixin{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalConfig _globalConfig=Constants.globalConfig;

  void _openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        endDrawer: const SadShaAuroraDrawer(),
        drawerScrimColor: Colors.transparent,
        endDrawerEnableOpenDragGesture: true,
        key: _scaffoldKey,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const ProfilePanel(),
                  IconButton(
                      onPressed: ()=>_openEndDrawer(),
                      icon: const Icon(Icons.settings),
                      hoverColor: SadShaAuroraColors.transparent,
                      highlightColor: SadShaAuroraColors.transparent,
                      splashColor: SadShaAuroraColors.transparent,
                  ),
                ],
              ),

              if(_globalConfig.sadshaAuroraMode!=SadShaAuroraModeEnum.mainlineWithoutBatteryManager && _globalConfig.isBatteryManagerEnabled )
               const Expanded(
                child:BatteryManagerScreen()
              ),
              if(_globalConfig.sadshaAuroraMode!=SadShaAuroraModeEnum.batteryManager && _globalConfig.isBacklightControllerEnabled)
               Expanded(
                  flex: super.isMainLine()?3:2,
                  child: const KeyboardSettingsScreen())
            ],
          ),
        ),
      );
  }
}