import 'package:sadsha_aurora/shared/data/isar_manager/models/sadsha_aurora_profile_model.dart';
import 'package:sadsha_aurora/shared/data/model/sadsha_aurora_mode_model.dart';
import 'package:sadsha_aurora/shared/data/model/sadsha_aurora_state_model.dart';
import 'package:flutter/material.dart';

abstract class IsarDelegate{
  String getVersionFromDB();
  Future<ThemeMode> getTheme();
  bool getEnforceFaustus();
  bool getBatteryManagerAvailability();
  bool getBacklightControllerAvailability();
  bool getBacklightControllerServiceAvailability();
  Future saveVersion(String version);
  Future saveTheme(ThemeMode themeMode);
  Future setEnforceFaustus(bool enforced);
  Future saveBatteryAvailability(bool value);
  Future saveBacklightAvailability(bool value);
  Future saveBacklightServiceAvailability(bool value);
  Future<SadShaAuroraProfileModel> getArProfile({int? id});

  int getThreshold();
  Future setBrightness(int brightness);
  Future setArMode({ required SadShaAuroraMode sadshaAuroraMode});
  Future setArState({ required SadShaAuroraState sadshaAuroraState });
  Future setThreshold(int threshold);
  Future<SadShaAuroraProfileModel?> readFromProfileName(String profileName);

  Future deleteDatabase();
}