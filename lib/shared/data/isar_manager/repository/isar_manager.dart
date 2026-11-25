import 'package:sadsha_aurora/shared/data/isar_manager/models/sadsha_aurora_profile_model.dart';
import 'package:sadsha_aurora/shared/data/isar_manager/models/sadsha_aurora_settings_model.dart';

abstract class IsarManager{
  Future initIsar();

  Future writeArSettingsIsar();
  Future<SadShaAuroraSettingsModel?> readArSettingsIsar();
  Future deleteArSettingsIsar(int id);

  Future writeArProfileIsar({SadShaAuroraProfileModel? sadshaAuroraProfileModel});
  Future<SadShaAuroraProfileModel?> readArProfileIsar({int? id});
  Future<List<SadShaAuroraProfileModel>> readAllArProfileIsar();
  Future deleteArProfileIsar({int? id});

  SadShaAuroraSettingsModel get sadshaAuroraSettingsModel;
  SadShaAuroraProfileModel get sadshaAuroraProfileModel;
  List<SadShaAuroraProfileModel> get allProfiles;

  set sadshaAuroraProfileModel(SadShaAuroraProfileModel value);

  Future deleteDatabase();

}