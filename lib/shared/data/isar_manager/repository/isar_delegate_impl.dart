import 'dart:io';

import 'package:sadsha_aurora/shared/utility/init_sadsha_aurora.dart';
import 'package:sadsha_aurora/shared/data/isar_manager/models/sadsha_aurora_profile_model.dart';
import 'package:sadsha_aurora/shared/data/isar_manager/repository/isar_manager.dart';
import 'package:sadsha_aurora/shared/data/model/sadsha_aurora_mode_model.dart';
import 'package:sadsha_aurora/shared/data/model/sadsha_aurora_state_model.dart';
import 'package:sadsha_aurora/user_interface/profiles/presentation/states/profiles_bloc.dart';
import 'package:sadsha_aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';

import '../../io/local/service_manager/service_manager.dart';
import 'isar_delegate.dart';

class IsarDelegateImpl with GlobalMixin implements IsarDelegate{

  IsarDelegateImpl(this._isarManager);

  final IsarManager _isarManager;

  late SadShaAuroraProfileModel _arProfileModel;

  @override
  String getVersionFromDB(){
    return  (_isarManager.sadshaAuroraSettingsModel.sadshaAuroraVersion)??'0';
  }

  @override
  Future<ThemeMode> getTheme() async{
    switch((_isarManager.sadshaAuroraSettingsModel.sadshaAuroraTheme)??'system'){
      case 'system':
        return ThemeMode.system;
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;

      default:
        return ThemeMode.system;
    }
  }

  @override
  bool getEnforceFaustus(){
    return  _isarManager.sadshaAuroraSettingsModel.enforceFaustus;
  }


  @override
  bool getBatteryManagerAvailability(){
    return _isarManager.sadshaAuroraSettingsModel.isBatteryManagerEnabled;
  }

  @override
  bool getBacklightControllerAvailability(){
    return _isarManager.sadshaAuroraSettingsModel.isBacklightControllerAvailableEnabled;
  }

  @override
  bool getBacklightControllerServiceAvailability(){
    return _isarManager.sadshaAuroraSettingsModel.isBacklightControllerServiceEnabled;
  }

  @override
  int getThreshold(){
    return _isarManager.sadshaAuroraProfileModel.threshold;
  }

  @override
  Future saveVersion(String version) async{
    _isarManager.sadshaAuroraSettingsModel.sadshaAuroraVersion=version;
    await _isarManager.writeArSettingsIsar();
  }

  @override
  Future saveTheme(ThemeMode themeMode) async{
    _isarManager.sadshaAuroraSettingsModel.sadshaAuroraTheme=themeMode.name;
    await _isarManager.writeArSettingsIsar();
  }

  @override
  Future saveBatteryAvailability(bool value) async{
    _isarManager.sadshaAuroraSettingsModel.isBatteryManagerEnabled=value;
    await _isarManager.writeArSettingsIsar();
  }

  @override
  Future saveBacklightAvailability(bool value) async{
    _isarManager.sadshaAuroraSettingsModel.isBacklightControllerAvailableEnabled=value;
    await _isarManager.writeArSettingsIsar();
  }

  @override
  Future saveBacklightServiceAvailability(bool value) async{
    _isarManager.sadshaAuroraSettingsModel.isBacklightControllerServiceEnabled=value;
    await _isarManager.writeArSettingsIsar();
  }

  @override
  Future setEnforceFaustus(bool enforced) async{
    _isarManager.sadshaAuroraSettingsModel.enforceFaustus=enforced;
    await _isarManager.writeArSettingsIsar();
  }

  @override
  Future<SadShaAuroraProfileModel> getArProfile({int? id}) async{
    return (await _isarManager.readArProfileIsar(id: id))!;
  }

  @override
  Future setBrightness(int brightness) async {
    await _writeProfile(()=>_arProfileModel.brightness=brightness);
  }

  @override
  Future setArMode({ required SadShaAuroraMode sadshaAuroraMode}) async {
    await _writeProfile(() {
      _arProfileModel.sadshaAuroraMode=SadShaAuroraMode.copyModel(sadshaAuroraMode);
    });
  }

  @override
  Future setArState({ required SadShaAuroraState sadshaAuroraState }) async {
    await _writeProfile(()=> _arProfileModel.sadshaAuroraState =sadshaAuroraState);

  }

  @override
  Future setThreshold(int threshold) async {
    await _writeProfile(()=>_arProfileModel.threshold=threshold);
  }

  @override
  Future deleteDatabase() async{
    await _isarManager.deleteDatabase();
  }

  @override
  Future<SadShaAuroraProfileModel?> readFromProfileName(String profileName) async{
    await _isarManager.readAllArProfileIsar();
    List<SadShaAuroraProfileModel> profiles= _isarManager.allProfiles.where((element){
      return element.profileName.trim()==profileName.trim();}).toList();
    if(profiles.isNotEmpty){
      return await _isarManager.readArProfileIsar(id: profiles.first.id);
    }else{
      stdout.writeln("no such profiles found");
    }
    return null;
  }

  Future _writeProfile(Function updateModel) async{
    _arProfileModel=SadShaAuroraProfileModel.copyModel(_isarManager.sadshaAuroraProfileModel);
    updateModel();

    if(!super.isMainLine()){
      _arProfileModel.sadshaAuroraState=_isarManager.sadshaAuroraProfileModel.sadshaAuroraState;
    }

    if(_arProfileModel!=_isarManager.sadshaAuroraProfileModel){

      List<SadShaAuroraProfileModel> profileMatchList=_isarManager.allProfiles.where((element) => element==_arProfileModel).toList();
      if(profileMatchList.isEmpty){
        if (_arProfileModel.id != 2) {
          _arProfileModel.id = 2;
          _arProfileModel.profileName = 'FreeStyle';
        }

        _isarManager.sadshaAuroraProfileModel = _arProfileModel;
        await _isarManager.writeArProfileIsar();
      }else{
        _arProfileModel= (await _isarManager.readArProfileIsar(id: profileMatchList.first.id))!;
      }

      sl<ProfilesBloc>().add(ProfilesReloadEvent(_arProfileModel));
      await sl<ServiceManager>().updateService();

    }else{
      stdout.writeln("avoiding unnecessary writes");
    }
  }
}