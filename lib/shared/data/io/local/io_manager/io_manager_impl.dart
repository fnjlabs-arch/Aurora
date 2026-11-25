import 'dart:io';

import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_logger.dart';


import 'io_manager.dart';


class IOManagerImpl implements IOManager{

  @override
  Future createFileSystemEntity({required String path, FileSystemEntityType fileType=FileSystemEntityType.file}) async{
    switch(fileType){
      case FileSystemEntityType.directory:
        await Directory(path).create();
        break;
      case FileSystemEntityType.file:
        await File(path).create();
        break;
      default:
        stderr.writeln("unhandled filetype $fileType");
    }
  }

  @override
  Future<bool> checkIfExists({required dynamic filePath, required FileSystemEntityType fileType}) async{
    try {
      FileSystemEntity fileInQuestion = await _parseFileSystemEntity(_parseFilePath(filePath));
      return (await fileInQuestion.exists() && (await fileInQuestion.stat()).type == fileType);
    }catch(e,stackTrace){
      SadShaAuroraLogger.log(data: e,stackTrace: stackTrace);
      return false;
    }
  }

  @override
  Future writeToFile({required dynamic filePath, required String content, FileMode fileMode=FileMode.write, bool allowEmptyContent=false}) async{
    try {
      if (content.isNotEmpty || allowEmptyContent) {
        return await File(_parseFilePath(filePath)).writeAsString(content, mode: fileMode);
      } else {
        stderr.writeln("blocked!. empty content");
      }
    }catch(e,stackTrace) {
      SadShaAuroraLogger.log(data: e,stackTrace: stackTrace);
    }
  }

  @override
  Future<List<String>> readFile(dynamic filePath) async{
    try {
      if (await checkIfExists(filePath: filePath, fileType: FileSystemEntityType.file)) {
        return await File(_parseFilePath(filePath)).readAsLines();
      } else {
        return [];
      }
    }catch(e,stackTrace){
      SadShaAuroraLogger.log(data: e,stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<String> getFileStat(String filePath) async{
    return (await File(filePath).stat()).modeString();
  }

  @override
  Future deleteFile(File file) async{
    await file.delete();
  }

  String _parseFilePath(dynamic filePath){
    if(filePath is String) {
      return filePath;
    }
    if(filePath is FileSystemEntity) {
      return filePath.path;
    }

    throw ("I donno what that is");
  }

  Future<FileSystemEntity> _parseFileSystemEntity(String filePath) async =>
     await FileSystemEntity.isDirectory(filePath)? Directory(filePath):File(filePath);


}