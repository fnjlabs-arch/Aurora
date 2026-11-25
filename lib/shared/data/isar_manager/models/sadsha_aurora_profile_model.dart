
import 'dart:convert';

import 'package:sadsha_aurora/shared/data/model/sadsha_aurora_mode_model.dart';
import 'package:sadsha_aurora/shared/data/model/sadsha_aurora_state_model.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'sadsha_aurora_profile_model.g.dart';


@Collection(inheritance: false)
//ignore: must_be_immutable
class SadShaAuroraProfileModel extends Equatable{
   Id? id;
   String profileName;
   int threshold;
   int brightness;
   SadShaAuroraState sadshaAuroraState;
   SadShaAuroraMode sadshaAuroraMode;

   SadShaAuroraProfileModel({
    this.id,
    required this.profileName,
    required this.threshold,
    required this.brightness,
    required this.sadshaAuroraState,
    required this.sadshaAuroraMode
  });

  factory SadShaAuroraProfileModel.copyModel(SadShaAuroraProfileModel model){
    return SadShaAuroraProfileModel(
        id: model.id,
        profileName: model.profileName,
        threshold: model.threshold,
        brightness: model.brightness,
        sadshaAuroraState: model.sadshaAuroraState,
        sadshaAuroraMode: model.sadshaAuroraMode);
  }


  factory SadShaAuroraProfileModel.fromJson(Map<String, dynamic> json){

    Map<String, dynamic> convertToJson(String string)=>
        jsonDecode(string.replaceAll('\\', ''));

    return SadShaAuroraProfileModel(
        profileName: 'Default Profile',
        threshold: json['flutter.sadsha_aurora_charge_threshold'],
        brightness: json['flutter.sadsha_aurora_brightness'],
        sadshaAuroraState: SadShaAuroraState.fromJson(convertToJson(json['flutter.sadsha_aurora_state'])),
        sadshaAuroraMode: SadShaAuroraMode.fromJson(convertToJson(json['flutter.sadsha_aurora_mode']))
    );
  }


  @override
  @ignore
  List<Object?> get props => [ threshold, brightness, sadshaAuroraState, sadshaAuroraMode];

}