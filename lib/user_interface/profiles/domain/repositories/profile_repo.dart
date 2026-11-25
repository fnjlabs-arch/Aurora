import 'package:sadsha_aurora/shared/data/isar_manager/models/sadsha_aurora_profile_model.dart';
import 'package:sadsha_aurora/user_interface/profiles/domain/models/profile_model.dart';

abstract class ProfileRepo{
  Future<List<ProfileModel>> getAllProfiles();
  Future<SadShaAuroraProfileModel> loadProfile(int id);
  Future<SadShaAuroraProfileModel> getCurrentProfile();
  Future setProfile({required SadShaAuroraProfileModel sadshaAuroraProfileModel});
  Future deleteProfile({required int id});
}