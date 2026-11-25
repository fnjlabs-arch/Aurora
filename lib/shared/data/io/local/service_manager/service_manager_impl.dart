import 'dart:io';
import 'dart:ui';

import 'package:sadsha_aurora/shared/data/isar_manager/models/sadsha_aurora_profile_model.dart';
import 'package:sadsha_aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:sadsha_aurora/shared/data/shared_data.dart';
import 'package:sadsha_aurora/user_interface/keyboard_settings/entity/keyboard_settings_entity.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_colors.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_logger.dart';
import 'package:sadsha_aurora/utility/constants.dart';
import 'package:sadsha_aurora/utility/global_mixin.dart';

class ServiceManagerImpl with GlobalMixin implements ServiceManager {

  ServiceManagerImpl(this._isarDelegate,this._ioManager);

  final File serviceFile = File(Constants.kServicePath + Constants.kServiceName);

  final IsarDelegate _isarDelegate;
  final IOManager _ioManager;

  @override
  Future createService({String? serviceFilePath}) async {
    File servFile=serviceFilePath==null?serviceFile:File(serviceFilePath);
    await servFile.create();
    await _ioManager.writeToFile(filePath: servFile, content: await _getServiceFileContent
    );
  }


@override
Future<String> get createServiceContentByShell async =>
    "tee $serviceFile > /dev/null << 'EOF'\n${await _getServiceFileContent}EOF";

  Future<String> get _getServiceFileContent async {
   return
     """
[Unit]
Description=To set charging threshold
After=multi-user.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target
StartLimitBurst=0

[Service]
Type=oneshot
Restart=on-failure
User=root
ExecStart= /bin/bash -c '${await getExecutionContent}'

[Install]
WantedBy=multi-user.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target
""";
  }


Future<String> get getExecutionContent async{
  List<String> execString=[];

  SadShaAuroraProfileModel sadshaAuroraProfileModel=await _isarDelegate.getArProfile();

  if(Constants.globalConfig.isBatteryManagerEnabled){
    execString.add('echo ${ _isarDelegate.getThreshold()} > ${Constants.globalConfig.kThresholdPath}');
  }

  if(Constants.globalConfig.isBacklightControllerServiceEnabled){
    Color color= Color(sadshaAuroraProfileModel.sadshaAuroraMode.colorRad!);
    if(isMainLine()) {
      execString.addAll([
        'echo  ${sadshaAuroraProfileModel.brightness} > ${Constants.kMainlineBrightnessPath}',
        'echo 1 ${KeyboardSettingsEntity.getRepo().keys[sadshaAuroraProfileModel.sadshaAuroraMode.mode!]} ${color.toRed} ${color.toGreen} ${color.toBlue} ${sadshaAuroraProfileModel.sadshaAuroraMode.speed} > ${Constants.kMainlineModuleModePath}',
        'echo 1 ${SadShaAuroraState.sadshaAuroraStateToIntString(sadshaAuroraProfileModel.sadshaAuroraState)} 0 > ${Constants.kMainlineModuleStatePath}',
    ]);
    }else{
      execString.addAll([
        'echo ${(color.r * 255).round().toRadixString(16)} > ${Constants.kFaustusModuleRedPath}',
        'echo ${(color.g * 255).round().toRadixString(16)} > ${Constants.kFaustusModuleGreenPath}',
        'echo ${(color.b * 255).round().toRadixString(16)} > ${Constants.kFaustusModuleBluePath}',
        'echo ${KeyboardSettingsEntity.getRepo().keys[sadshaAuroraProfileModel.sadshaAuroraMode.mode!]} > ${Constants.kFaustusModuleModePath}',
        'echo ${sadshaAuroraProfileModel.sadshaAuroraMode.speed} > ${Constants.kFaustusModuleSpeedPath}',
        'echo ${sadshaAuroraProfileModel.brightness} > ${Constants.kFaustusModuleBrightnessPath}',
        'echo 2a > ${Constants.kFaustusModuleFlagsPath}',
        'echo 1 > ${Constants.kFaustusModuleSetPath}',
      ]);
    }
  }

  return execString.join('; ');

}

  @override
  Future updateService() async {
    List<String> serviceContent=await  _ioManager.readFile(serviceFile);
    if(serviceContent.isEmpty){
      SadShaAuroraLogger.log(data: "service file not found!");
      return;
    }
    var execContent = await getExecutionContent;
    if(execContent.isNotEmpty) {
      serviceContent = serviceContent.map((content) {
        if (content.startsWith('ExecStart')) {
          return "ExecStart= /bin/bash -c '$execContent'";
        } else {
          return content;
        }
      }).toList();

      await _ioManager.writeToFile(
          filePath: serviceFile, content: serviceContent.join('\n'));
    }else{
      SadShaAuroraLogger.log(data: "nothing to execute!");
    }
  }

  @override
  Future deleteService() async{
    if(await serviceFile.exists()) {
      try {
        await serviceFile.delete();
      }catch(e){
        SadShaAuroraLogger.log(data: e);
      }
    }
  }

}