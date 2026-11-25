import 'dart:convert';
import 'dart:io';

import 'package:sadsha_aurora/shared/data/io/local/io_manager/io_manager.dart';
import 'package:sadsha_aurora/shared/data/isar_manager/models/sadsha_aurora_profile_model.dart';
import 'package:sadsha_aurora/shared/data/isar_manager/models/sadsha_aurora_settings_model.dart';
import 'package:sadsha_aurora/shared/data/isar_manager/repository/isar_manager.dart';
import 'package:sadsha_aurora/shared/data/model/sadsha_aurora_mode_model.dart';
import 'package:sadsha_aurora/shared/data/model/sadsha_aurora_state_model.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_colors.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_logger.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';


class IsarManagerImpl implements IsarManager {


  IsarManagerImpl(this._ioManager);

  late Isar isar;

  final IOManager _ioManager;

  SadShaAuroraSettingsModel _arSettingsModel=SadShaAuroraSettingsModel();
  late SadShaAuroraProfileModel _arProfileModel;

  List<SadShaAuroraProfileModel> _allProfiles=[];

  late  Directory _supportDir;

  Future _validateIsar() async{
    if(!isar.isOpen){
      await initIsar();
    }
  }

  @override
  Future initIsar() async{

    _supportDir=await getApplicationSupportDirectory();

    isar = await Isar.open(
      name: 'sadshaAuroraDB',
      [SadShaAuroraSettingsModelSchema,SadShaAuroraProfileModelSchema],
      directory: _supportDir.path
    );

   if(await _validateArSettingsIsar()){
     await _initArProfiles();
   }

   await readArSettingsIsar();
   await readArProfileIsar();
  }

  Future<bool> _validateArSettingsIsar() async{
    return (await isar.sadshaAuroraSettingsModels.where().findAll()).isEmpty;
  }


  Future _initArProfiles() async{

    setDefaultProfileAndSettings(){

      _arSettingsModel = SadShaAuroraSettingsModel(
          sadshaAuroraTheme: 'system',
          sadshaAuroraVersion: '0',
          profileId: null);

      _arProfileModel = SadShaAuroraProfileModel(
          id: 1,
          profileName: 'Default Profile',
          threshold: 55,
          brightness: 1,
          sadshaAuroraState: const SadShaAuroraState(),
          sadshaAuroraMode: SadShaAuroraMode(colorRad: SadShaAuroraColors.accentColor.toARGB32(), mode: 1, speed: 0));
    }

    try {

      File sharedPref=File('${_supportDir.path}/shared_preferences.json');
      String sharedPrefData=(await _ioManager.readFile(sharedPref)).join('');

      if(sharedPrefData.isNotEmpty){
        _arSettingsModel=SadShaAuroraSettingsModel.fromJson(jsonDecode(sharedPrefData));
        _arProfileModel=SadShaAuroraProfileModel.fromJson(jsonDecode(sharedPrefData))..id=1;
         await _ioManager.deleteFile(sharedPref);
      }else {
        setDefaultProfileAndSettings();
      }

    }catch(e){
      setDefaultProfileAndSettings();
      SadShaAuroraLogger.log(data: e.toString());
    }


    await writeArProfileIsar();
  }
  
  /// Ar Settings Isar
  @override
  Future writeArSettingsIsar() async{
    await _validateIsar();
    if(_arSettingsModel.profileId!=null) {
      if(_arSettingsModel.id!=null || (_arSettingsModel.id==null && await _validateArSettingsIsar())) {
        await isar.writeTxn(() => isar.sadshaAuroraSettingsModels.put(_arSettingsModel));
        await readArSettingsIsar();
      }else{
        stdout.writeln("SadShaAuroraSettingsModel already exists!");
      }
    }
  }

  @override
  Future<SadShaAuroraSettingsModel?> readArSettingsIsar() async{
    await _validateIsar();
    var tempModel= await isar.sadshaAuroraSettingsModels.where().findFirst();
    if(tempModel!=null) {
      _arSettingsModel=tempModel;
    }
    return tempModel;
  }  

  @override
  Future deleteArSettingsIsar(int id) async{
    await _validateIsar();
    _arSettingsModel=SadShaAuroraSettingsModel();
    return await isar.sadshaAuroraSettingsModels.delete(id);
  }

  /// SadSha Aurora Profile ISAR
  @override
  Future writeArProfileIsar({SadShaAuroraProfileModel? sadshaAuroraProfileModel}) async{
    await _validateIsar();

    sadshaAuroraProfileModel??=_arProfileModel;
    await isar.writeTxn(() => isar.sadshaAuroraProfileModels.put(sadshaAuroraProfileModel!));
    _arSettingsModel.profileId=sadshaAuroraProfileModel.id;
    if(_allProfiles.where((element) => element.id==sadshaAuroraProfileModel!.id).isEmpty){
      _allProfiles.add(sadshaAuroraProfileModel);
    }

    await writeArSettingsIsar();
    await readArProfileIsar();
  }

  @override
  Future<SadShaAuroraProfileModel?> readArProfileIsar({int? id}) async{
    await _validateIsar();

    if(id==null) {
      id=_arSettingsModel.profileId;
    }else{
      _arSettingsModel.profileId=id;
      await writeArSettingsIsar();
    }
    SadShaAuroraProfileModel? tempModel= await isar.sadshaAuroraProfileModels.get(id!);
    if(tempModel!=null){
      _arProfileModel=tempModel;
    }
    return tempModel;
  }

  @override
  Future<List<SadShaAuroraProfileModel>> readAllArProfileIsar() async{
    await _validateIsar();

    _allProfiles= await isar.sadshaAuroraProfileModels.where().findAll();
    return _allProfiles;
  }

  @override
  Future deleteArProfileIsar({int? id}) async{
    await _validateIsar();

    id??=_arSettingsModel.profileId;
    _allProfiles.removeWhere((element) => element.id==id!);
    await isar.writeTxn(() async {
      await isar.sadshaAuroraProfileModels.delete(id!);
    });
  }

  @override
  Future deleteDatabase() async{
    try {
      await _validateIsar();
      await isar.writeTxn(() async => await isar.clear());
      await isar.close(deleteFromDisk: true);
      _allProfiles.clear();
    }catch(e){
      SadShaAuroraLogger.log(data: e.toString());
    }
  }


  @override
  set sadshaAuroraProfileModel(SadShaAuroraProfileModel value) {
    _arProfileModel = SadShaAuroraProfileModel.copyModel(value);
  }

  @override
  SadShaAuroraSettingsModel get sadshaAuroraSettingsModel=> _arSettingsModel;

  @override
  SadShaAuroraProfileModel get sadshaAuroraProfileModel=> SadShaAuroraProfileModel.copyModel(_arProfileModel);

  @override
  List<SadShaAuroraProfileModel> get allProfiles => _allProfiles;

}