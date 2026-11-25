import 'dart:io';



import 'package:sadsha_aurora/shared/data/shared_data.dart';
import 'package:sadsha_aurora/utility/constants.dart';
import 'package:sadsha_aurora/utility/global_mixin.dart';
import 'package:flutter/foundation.dart';


class SadShaAuroraLogger with GlobalMixin{

  static SadShaAuroraLogger? _instance;

  SadShaAuroraLogger._();

  factory SadShaAuroraLogger(){
    _instance??=SadShaAuroraLogger._();
    return _instance!;
  }

  late File _logFile;
  final IOManager _ioManager=sl<IOManager>();
  
  final List<String> _log=[];
  bool _logging=false;


  static Future log({required dynamic data, StackTrace? stackTrace})async {
    if(_instance!.canLog()) {
      _instance!._log.add("$data\n ${stackTrace ?? ''}");
      if (!_instance!._logging) {
        _instance!._logging = true;
        await _instance!._logBuffer(data: _instance!._log.first);
      }
    }
  }

  Future _logBuffer({required String data}) async{
    if (kDebugMode) {
      print(data.trim());
    }else {
      await _ioManager.writeToFile(
          filePath: _logFile,
          content: data,
          fileMode: FileMode.append);
    }

    _log.removeAt(0);
    if(_log.isNotEmpty){
      await _logBuffer(data: _log.first);
    }else{
      _logging=false;
    }
  }

  static void initialize(){
    try{
    Constants.globalConfig.setInstance(kTmpPath: Directory.systemTemp.path);
    _instance!._logFile=File("${Constants.globalConfig.kTmpPath}/sadsha-aurora.log");
    if(_instance!._logFile.existsSync()) {
      _instance!._logFile.deleteSync();
      }
    }catch(e,stackTrace){
      SadShaAuroraLogger.log(data: e,stackTrace: stackTrace);
    }
  }
}