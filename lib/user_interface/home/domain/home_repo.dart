
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_enums.dart';

abstract class HomeRepo{
  Future<bool> requestAccess();
  Future<bool> canElevate();
  Future selfElevate();
  Future initLog();
  Future<bool> enforcement(Enforcement enforce);
}