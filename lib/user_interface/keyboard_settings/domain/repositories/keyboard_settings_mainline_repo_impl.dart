import 'dart:ui';

import 'package:sadsha_aurora/shared/data/shared_data.dart';
import 'package:sadsha_aurora/user_interface/keyboard_settings/domain/repositories/keyboard_settings_repo.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_widgets.dart';
import 'package:sadsha_aurora/utility/constants.dart';


class KeyboardSettingsMainlineRepoImpl extends KeyboardSettingsRepo{

  KeyboardSettingsMainlineRepoImpl(this._ioManager, this._serviceManager);

  final IOManager _ioManager;
  final ServiceManager _serviceManager;

  @override
  List<int> get keys=>[0,1,2,9];

  @override
  Future setBrightness(int brightness) async {
    await _ioManager.writeToFile(
        filePath: Constants.kMainlineBrightnessPath,
        content:  brightness.toString()
    );
    super.setBrightness(brightness);
  }

  @override
  Future setColor({required SadShaAuroraMode sadshaAuroraMode}) async {
    await setModeParams(sadshaAuroraMode: sadshaAuroraMode);
  }

  @override
  Future setMode({required SadShaAuroraMode sadshaAuroraMode}) async{
    await setModeParams(sadshaAuroraMode: sadshaAuroraMode);
  }

  @override
  Future setSpeed({required SadShaAuroraMode sadshaAuroraMode}) async {
    await setModeParams(sadshaAuroraMode: sadshaAuroraMode);
  }

  @override
  Future setModeParams({required SadShaAuroraMode sadshaAuroraMode}) async{
    sadshaAuroraMode.color??=Color(sadshaAuroraMode.colorRad!);

    await _ioManager.writeToFile(
        filePath: Constants.kMainlineModuleModePath,
        content: "1 ${keys[sadshaAuroraMode.mode!]} ${sadshaAuroraMode.color!.toRed} ${sadshaAuroraMode.color!.toGreen} ${sadshaAuroraMode.color!.toBlue} ${sadshaAuroraMode.speed}");

    await _serviceManager.updateService();

    super.setModeParams(sadshaAuroraMode: sadshaAuroraMode);
  }

  @override
  Future setMainlineStateParams({required SadShaAuroraState sadshaAuroraState}) async{
    await _ioManager.writeToFile(filePath: Constants.kMainlineModuleStatePath,content: "1 ${SadShaAuroraState.sadshaAuroraStateToIntString(sadshaAuroraState)} 0");
    super.setMainlineStateParams(sadshaAuroraState: sadshaAuroraState);
  }


  
}