import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_enums.dart';

abstract class DisableSettingsRepo{
  Future<bool> disableServices({required DisableEnum disable});
}