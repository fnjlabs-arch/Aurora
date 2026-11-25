
import 'package:sadsha_aurora/shared/data/shared_data.dart';
import 'package:sadsha_aurora/shared/terminal/shared_terminal.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_logger.dart';
import 'package:sadsha_aurora/utility/constants.dart';

mixin TerminalMixin {

  final TerminalRepo _terminalRepo= sl<TerminalRepo>();

  Future<bool> isSecureBootEnabled() async{
    return (await _terminalRepo.getOutput("mokutil --sb-state")).toString().contains("enabled");
  }

  Future<bool> pkexecChecker() async{
    return await _terminalRepo.getOutput('type pkexec').then((value){
      if(value.isEmpty) {
        return true;
      } else{
          return !value.toString().contains('not found');
        }
    });
  }

  Future<bool> isKernelCompatible() async{
    try {
      return (int.tryParse((await _terminalRepo.getOutput('uname -r')).last
          .split('-')
          .first
          .replaceAll('.', '')) ?? 0) >= 610;
    }catch(e,stackTrace){
      SadShaAuroraLogger.log(data: e,stackTrace: stackTrace);
      return false;
    }
  }

  Future<bool> sadshaAuroraServiceEnabled() async{
    return (await _terminalRepo.getOutput(Constants.kSadShaAuroraServiceStatus))
        .toString().contains('enabled');

  }

  Future<bool> systemHasSystemd() async{
    return (await _terminalRepo.getOutput(Constants.kCheckSystemd)).toString().contains('systemd');
  }

}