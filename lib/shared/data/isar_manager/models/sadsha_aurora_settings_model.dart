import 'package:isar/isar.dart';

part 'sadsha_aurora_settings_model.g.dart';

@collection
class SadShaAuroraSettingsModel {
  Id? id;

  String? sadshaAuroraVersion;
  String? sadshaAuroraTheme;
  bool enforceFaustus;
  int? profileId;
  bool isBatteryManagerEnabled;
  bool isBacklightControllerAvailableEnabled;
  bool isBacklightControllerServiceEnabled;

  SadShaAuroraSettingsModel({
    this.sadshaAuroraVersion,
    this.sadshaAuroraTheme,
    this.enforceFaustus = false,
    this.profileId,
    this.isBatteryManagerEnabled=false,
    this.isBacklightControllerAvailableEnabled=false,
    this.isBacklightControllerServiceEnabled=false
  });

  factory SadShaAuroraSettingsModel.fromJson(Map<String, dynamic> json) {
    return SadShaAuroraSettingsModel(
        sadshaAuroraTheme: json['flutter.system'], sadshaAuroraVersion: json['flutter.sadsha_aurora_version'], enforceFaustus: json['flutter.enforce_faustus']);
  }

  @override
  toString() => "sadshaAuroraVersion: $sadshaAuroraVersion, sadshaAuroraTheme: $sadshaAuroraTheme, enforceFaustus: $enforceFaustus ";
}
