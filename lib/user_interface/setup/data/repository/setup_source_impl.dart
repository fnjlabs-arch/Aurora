
import 'package:sadsha_aurora/shared/data/shared_data.dart';
import 'package:sadsha_aurora/user_interface/setup/data/repository/setup_source.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_logger.dart';
import 'package:sadsha_aurora/utility/constants.dart';

class SetupSourceImpl extends SetupSource{
  
  SetupSourceImpl(this._remoteIOManager);

  final RemoteIOManager _remoteIOManager;
  
  @override
  Future<String> getTerminalList() async{
    try {
      return (await _remoteIOManager.fetch(url: Constants.kTerminalListUrl)).data.toString();
    }on Exception{
      return '';
    }
  }

  @override
  Future<String> getAuroraLiveVersion() async{
    try {
      return (await _remoteIOManager.fetch(url: Constants.globalConfig.kSadShaAuroraGitRawYaml!)).data.toString();
    }catch(e,stackTrace){
      SadShaAuroraLogger.log(data: e,stackTrace: stackTrace);
      return 'version: 0.0.0-unknwon+0';
    }
  }

  @override
  Future<String> getChangelog() async{
    try{
      return (await _remoteIOManager.fetch(url: Constants.globalConfig.kSadShaAuroraGitRawChangelog!)).data.toString();
    }catch(e,stackTrace){
      SadShaAuroraLogger.log(data: e,stackTrace: stackTrace);
      return 'unable to get changelog';
    }
  }

}