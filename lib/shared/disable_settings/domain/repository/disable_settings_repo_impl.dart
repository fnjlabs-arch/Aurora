
import 'dart:io';

import 'package:sadsha_aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:sadsha_aurora/shared/data/shared_data.dart';
import 'package:sadsha_aurora/shared/disable_settings/shared_disable_services.dart';
import 'package:sadsha_aurora/shared/terminal/shared_terminal.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_enums.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_snackbar.dart';
import 'package:sadsha_aurora/utility/constants.dart';


class DisableSettingsRepoImpl extends DisableSettingsRepo with TerminalMixin {

  DisableSettingsRepoImpl(this._isarDelegate,this._serviceManager,this._permissionManager,this._ioManager);

  final IsarDelegate _isarDelegate;

  final IOManager _ioManager;
  final PermissionManager _permissionManager;
  final ServiceManager _serviceManager;


  @override
  Future<bool> disableServices({required DisableEnum disable}) async{

    List<String> disableCommands=[];

    List<String> disableMainlineCommandList=[
      'modprobe -r asus_wmi',
      'modprobe -r asus_nb_wmi',
      'printf "blacklist asus_wmi\\n blacklist asus_nb_wmi\\n" | sudo tee /etc/modprobe.d/faustus.conf',
      'modprobe faustus || echo faustus aint available'
    ];

    List<String> disableFaustusCommandList=[
      'rmmod faustus',
      'printf "blacklist faustus\\n" | sudo tee /etc/modprobe.d/faustus.conf',
      'modprobe asus-nb-wmi',
      'modprobe asus-wmi',
      'dkms remove faustus/0.2 --all || echo faustus aint available'
    ];

    List<String> uninstallAuroraCommandList=[
      'sudo rm -rf /opt/sadsha-aurora',
      'sudo rm -rf /usr/bin/sadsha-aurora',
      'sudo rm -rf /usr/local/lib/sadsha-aurora',
      'sudo rm -f /usr/share/applications/sadsha-aurora.desktop'
    ];
    
    List<String> disableService=[
     if(await _ioManager.checkIfExists(filePath: "${Constants.kServicePath}/${Constants.kServiceName}", fileType: FileSystemEntityType.file))
       ...[
      "systemctl disable ${Constants.kServiceName}",
      "sudo rm -f ${Constants.kServicePath}/${Constants.kServiceName}"
       ]
    ];

    List<String> disableThreshold=[
      if(Constants.globalConfig.kThresholdPath?.isNotEmpty==true)
      "sudo echo 100 > ${Constants.globalConfig.kThresholdPath}"
    ];


      switch(disable) {
        case DisableEnum.mainline:
            disableCommands.addAll(disableMainlineCommandList);
            break;

        case DisableEnum.faustus:
            disableCommands.addAll(disableFaustusCommandList);
            break;

        case DisableEnum.all:
            disableCommands.addAll([
              ...disableFaustusCommandList,
              ...disableThreshold,
              ...disableService
            ]);
            break;

        case DisableEnum.threshold:
            disableCommands.addAll(disableThreshold);
            break;

        case DisableEnum.uninstall:
            disableCommands.addAll([
              ...disableFaustusCommandList,
              ...uninstallAuroraCommandList
            ]);
            break;

        case DisableEnum.service:
            disableCommands.addAll([
              ...disableThreshold,
              ...disableService
            ]);
            break;

        case DisableEnum.none:
        // TODO: Handle this case.
          break;

      }

      bool isSuccess= await _runDisableCommand(disableCommands);

      if(!await super.sadshaAuroraServiceEnabled()) {
        if (disable == DisableEnum.all || disable == DisableEnum.threshold) {
          await _disableBatteryManager();
          await _isarDelegate.setThreshold(100);
        }
      }

        if (disable == DisableEnum.uninstall) {
          await _isarDelegate.deleteDatabase();
        }

        if(!isSuccess) {
          sadshaAuroraSnackBar(text: "Failed to apply setting",isPositive: false);
        }

        return isSuccess;
  }

  Future<bool> _runDisableCommand(List<String> commands) async{
    return (await _permissionManager.runWithPrivileges(commands))==0;
  }
  

  Future _disableBatteryManager() async{
    if(await _permissionManager.hasPermission(Constants.globalConfig.kThresholdPath!)) {
      await _ioManager.writeToFile(
          filePath: Constants.globalConfig.kThresholdPath!,
          content: '100'
      );
    }
    await _serviceManager.deleteService();
  }

}