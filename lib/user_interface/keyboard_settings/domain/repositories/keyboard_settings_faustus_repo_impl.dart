import 'dart:ui';

import 'package:sadsha_aurora/shared/data/shared_data.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_colors.dart';
import 'package:sadsha_aurora/utility/constants.dart';

import 'keyboard_settings_repo.dart';

class KeyboardSettingsFaustusRepoImpl extends KeyboardSettingsRepo {

  KeyboardSettingsFaustusRepoImpl(this._ioManager, this._serviceManager);

  final IOManager _ioManager;
  final ServiceManager _serviceManager;

  @override
  List<int> get keys=>[0,1,2,3];

  @override
  Future setModeParams({required SadShaAuroraMode sadshaAuroraMode}) async{
    sadshaAuroraMode.color??=Color(sadshaAuroraMode.colorRad!);

      await setSpeed(sadshaAuroraMode: sadshaAuroraMode);
      await setColor(sadshaAuroraMode: sadshaAuroraMode);

  }
  
  @override
  Future setMode({required SadShaAuroraMode sadshaAuroraMode}) async{

      await _ioManager.writeToFile(
          filePath: Constants.kFaustusModuleModePath,
          content: "${keys[sadshaAuroraMode.mode!]}"
      );
      await saveFaustusSettings();

      super.setMode(sadshaAuroraMode: sadshaAuroraMode);
  }

  @override
  Future setColor({required SadShaAuroraMode sadshaAuroraMode}) async {

      Color color=sadshaAuroraMode.color!;
      await _ioManager.writeToFile(filePath: Constants.kFaustusModuleRedPath, content: (color.r * 255).round().toRadixString(16));
      await _ioManager.writeToFile(filePath: Constants.kFaustusModuleGreenPath, content: (color.g * 255).round().toRadixString(16));
      await _ioManager.writeToFile(filePath: Constants.kFaustusModuleBluePath, content: (color.b * 255).round().toRadixString(16));

      SadShaAuroraColors.accentColor = color;
      await setMode(sadshaAuroraMode: sadshaAuroraMode);

  }

  @override
  Future setSpeed({required SadShaAuroraMode sadshaAuroraMode}) async{
     await _ioManager.writeToFile(
        filePath: Constants.kFaustusModuleSpeedPath,
        content: "${sadshaAuroraMode.speed}");
     super.setSpeed(sadshaAuroraMode: sadshaAuroraMode);
  }

  @override
  Future setBrightness(int brightness) async {
    await _ioManager.writeToFile(
        filePath: Constants.kFaustusModuleBrightnessPath,
        content:  brightness.toString()
    );
    super.setBrightness(brightness);
  }

  Future saveFaustusSettings() async{
    await _ioManager.writeToFile(filePath: Constants.kFaustusModuleFlagsPath, content: '2a');
    await _ioManager.writeToFile(filePath: Constants.kFaustusModuleSetPath, content: '1');
    await _serviceManager.updateService();
  }

  @override
  Future setMainlineStateParams({required SadShaAuroraState sadshaAuroraState}) {
    throw UnimplementedError();
  }

}