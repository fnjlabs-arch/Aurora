

import 'package:sadsha_aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:sadsha_aurora/shared/data/shared_data.dart';

abstract class KeyboardSettingsRepo{

  final IsarDelegate _isarDelegate=sl<IsarDelegate>();

  List<int> get keys;

  Future setMode({required SadShaAuroraMode sadshaAuroraMode}) async =>
      await _setArMode(sadshaAuroraMode);

  Future setColor({required SadShaAuroraMode sadshaAuroraMode});

  Future setSpeed({required SadShaAuroraMode sadshaAuroraMode}) async =>
      await _setArMode(sadshaAuroraMode);

  Future setModeParams({required SadShaAuroraMode sadshaAuroraMode}) async =>
    await _setArMode(sadshaAuroraMode);

  Future setBrightness(int brightness)async=>
    await _isarDelegate.setBrightness(brightness);

  Future setMainlineStateParams({required SadShaAuroraState sadshaAuroraState})async=>
      await _isarDelegate.setArState(sadshaAuroraState:sadshaAuroraState);

  Future _setArMode(SadShaAuroraMode sadshaAuroraMode) async=>
      await _isarDelegate.setArMode(sadshaAuroraMode: sadshaAuroraMode);
}