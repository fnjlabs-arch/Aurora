
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'sadsha_aurora_state_model.g.dart';

@Embedded(inheritance: false)
class SadShaAuroraState extends Equatable{
  final bool? boot;
  final bool? awake;
  final bool? sleep;

  const SadShaAuroraState({this.boot=false, this.awake=true, this.sleep=false});

  SadShaAuroraState negateValue(){
    return SadShaAuroraState(
      awake: !awake!,
      sleep: !sleep!,
      boot: !boot!
    );
  }

  factory SadShaAuroraState.fromJson(Map<String, dynamic> json)=>
      SadShaAuroraState(
        awake: json['awake'],
        boot: json['boot'],
        sleep: json['sleep']
      );

  static String sadshaAuroraStateToIntString(SadShaAuroraState sadshaAuroraState){
    int boolToString(bool? value)=>value==null?0:value?1:0;
    return "${boolToString(sadshaAuroraState.boot)} ${boolToString(sadshaAuroraState.awake)} ${boolToString(sadshaAuroraState.sleep)}";
  }

  @override
  @ignore
  List<Object?> get props => [awake, sleep, boot];
}