import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SadShaAuroraBlocObserver extends BlocObserver{

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    SadShaAuroraLogger.log(data: error, stackTrace: stackTrace);
  }
}