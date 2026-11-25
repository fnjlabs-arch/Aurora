import 'dart:io';


import 'package:sadsha_aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:sadsha_aurora/shared/data/shared_data.dart';
import 'package:sadsha_aurora/shared/disable_settings/shared_disable_services.dart';
import 'package:sadsha_aurora/shared/terminal/shared_terminal.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_enums.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_logger.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_snackbar.dart';
import 'package:sadsha_aurora/utility/constants.dart';
import 'package:sadsha_aurora/utility/global_mixin.dart';

import 'home_repo.dart';

class HomeRepoImpl extends HomeRepo with GlobalMixin, TerminalMixin{

  HomeRepoImpl(this._terminalRepo, this._permissionManager, this._ioManager, this._fileManager, this._isarDelegate, this._disableSettingsRepo);

  final TerminalRepo _terminalRepo;
  final PermissionManager _permissionManager;
  final IOManager _ioManager;
  final FileManager _fileManager;
  final IsarDelegate _isarDelegate;
  final DisableSettingsRepo _disableSettingsRepo;


  Future _getAccess() async{
     await _permissionManager.setPermissions();
  }

  @override
  Future<bool> canElevate() async{
    return await _ioManager.checkIfExists(filePath: Constants.kInstalledBinary, fileType: FileSystemEntityType.file) && isInstalledPackage();
  }

  @override
  Future selfElevate() async{
    if(await canElevate()) {
        await _terminalRepo.execute("${Constants.kInstalledBinary} --with-root");
        exit(0);
    }else{
      sadshaAuroraSnackBar(text: "Can't elevate at this point",isPositive: false);
    }
  }

  Future<bool> _checkAccess() async{
    return await _permissionManager.validatePaths() &&( await super.sadshaAuroraServiceEnabled() || !Constants.globalConfig.isBatteryManagerEnabled);
  }

  @override
  Future<bool> requestAccess() async{
    var checkAccess=await _checkAccess();
    if(!checkAccess) {
      await _getAccess();
      checkAccess=await _checkAccess();
    }
    return checkAccess;
  }


  @override
  Future<bool> enforcement(Enforcement enforce) async{
    bool isSuccess=false;
    if(enforce==Enforcement.faustus){
      isSuccess= await _disableSettingsRepo.disableServices(disable: DisableEnum.mainline);
    }
    if(enforce==Enforcement.mainline){
      isSuccess= await _disableSettingsRepo.disableServices(disable: DisableEnum.faustus);
    }

    if(isSuccess) {
      bool isFaustusEnforced=enforce==Enforcement.faustus;
      await _isarDelegate.setEnforceFaustus(isFaustusEnforced);
    }

    return isSuccess;
  }

  @override
  Future initLog() async{

    _fileManager.setWorkingDirectory();

   SadShaAuroraLogger.log(data: "Build Version          : ${await getVersion()}");
   SadShaAuroraLogger.log(data: "Build Type             : ${Constants.buildType.name}");
   SadShaAuroraLogger.log(data: "Compatible Device      : ${await _fileManager.isDeviceCompatible()}");
   SadShaAuroraLogger.log(data: "Compatible Kernel      : ${await super.isKernelCompatible()}");
   SadShaAuroraLogger.log(data: "Mainline Mode          : ${isMainLineCompatible()}");
   SadShaAuroraLogger.log(data: "System has systemd     : ${await systemHasSystemd()}");
   SadShaAuroraLogger.log(data: "Threshold Path Exists  : ${await _fileManager.thresholdPathExists()}");
   SadShaAuroraLogger.log(data: "Working Directory      : ${Constants.globalConfig.kWorkingDirectory}");

    if(await  _ioManager.checkIfExists(filePath: "${Constants.globalConfig.kTmpPath}/sadsha-aurora.log", fileType: FileSystemEntityType.file)) {
      await _terminalRepo.execute("chown \$(logname) ${Constants.globalConfig.kTmpPath}/sadsha-aurora.log");
    }

  }


}