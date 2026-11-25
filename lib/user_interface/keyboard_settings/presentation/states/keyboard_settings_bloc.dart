
import 'package:sadsha_aurora/shared/data/isar_manager/models/sadsha_aurora_profile_model.dart';
import 'package:sadsha_aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:sadsha_aurora/shared/data/shared_data.dart';
import 'package:sadsha_aurora/shared/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:sadsha_aurora/user_interface/keyboard_settings/domain/repositories/keyboard_settings_repo.dart';
import 'package:sadsha_aurora/user_interface/keyboard_settings/entity/keyboard_settings_entity.dart';
import 'package:sadsha_aurora/user_interface/keyboard_settings/presentation/states/keyboard_settings_event.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_colors.dart';
import 'package:sadsha_aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'keyboard_settings_state.dart';

class KeyboardSettingsBloc extends TerminalBaseBloc<KeyboardSettingsEvent,KeyboardSettingsState> {
  KeyboardSettingsBloc(this._isarDelegate):super(const KeyboardSettingsState()){

   on<KeyboardSettingsEventInit>((event, emit) => _initPanel(emit));
   on<KeyboardSettingsEventSetBrightness>((event, emit)=> _setBrightness(event.brightness,emit));
   on<KeyboardSettingsEventSetSpeed>((event, emit)=> _setSpeed(speed: event.speed,emit));
   on<KeyboardSettingsEventSetMode>((event, emit)=> _setMode(mode: event.mode,emit));
   on<KeyboardSettingsEventSetColor>((event, emit)=> _setColor(color: event.color??SadShaAuroraColors.accentColor,mode: 0, emit));
   on<KeyboardSettingsEventSetState>((event, emit) => _setStateParams(emit,sadshaAuroraState: SadShaAuroraState(boot: event.boot,sleep: event.sleep,awake: event.awake)));
   on<KeyboardSettingsEventShowColorCode>((event, emit) => _showColorCode(emit));
  }

  final IsarDelegate _isarDelegate;
  final KeyboardSettingsRepo _keyboardSettingsRepo=KeyboardSettingsEntity.getRepo();

  bool _boot=false;
  bool _awake=false;
  bool _sleep=false;

  late SadShaAuroraMode sadshaAuroraMode;

  late SadShaAuroraProfileModel sadshaAuroraProfileModel;

  Future<void> _initPanel(Emitter emit) async{
      sadshaAuroraProfileModel=await _isarDelegate.getArProfile();
      sadshaAuroraMode= SadShaAuroraMode.copyModel(sadshaAuroraProfileModel.sadshaAuroraMode);
      if(Constants.globalConfig.isBacklightControllerEnabled) {
        await _setBrightness(sadshaAuroraProfileModel.brightness, emit);
        await _setModeParams(sadshaAuroraMode: sadshaAuroraMode, emit);
        if (super.isMainLine()) {
          await _setStateParams(sadshaAuroraState: (sadshaAuroraProfileModel.sadshaAuroraState).negateValue(), emit);
        }
      }
  }

  Future<void> _setColor(Emitter emit,{required Color color,int? mode}) async {
    sadshaAuroraMode.color= color;
    sadshaAuroraMode.colorRad=color.toARGB32();
    sadshaAuroraMode.mode=mode??sadshaAuroraMode.mode;

    await _keyboardSettingsRepo.setColor(sadshaAuroraMode: SadShaAuroraMode.copyModel(sadshaAuroraMode));
    _updateState(emit);
  }

  Future<void> _setBrightness(int brightness, emit) async {
    await _keyboardSettingsRepo.setBrightness(brightness);
    emit(state.copyState(brightness: brightness));
  }


  Future<void> _setMode(Emitter emit, {required int mode})async{
    sadshaAuroraMode.mode=mode;
    await _keyboardSettingsRepo.setMode(sadshaAuroraMode: sadshaAuroraMode);
    _updateState(emit);
  }

  Future<void> _setSpeed(Emitter emit,{required int speed}) async{
    sadshaAuroraMode.speed=speed;
    await _keyboardSettingsRepo.setSpeed(sadshaAuroraMode: sadshaAuroraMode);
    _updateState(emit);
  }
  
  Future<void> _setModeParams(Emitter emit,{
    required SadShaAuroraMode sadshaAuroraMode    
  }) async{
    this.sadshaAuroraMode.color=sadshaAuroraMode.color??this.sadshaAuroraMode.color;
    this.sadshaAuroraMode.mode=sadshaAuroraMode.mode??this.sadshaAuroraMode.mode;
    this.sadshaAuroraMode.speed=sadshaAuroraMode.speed??this.sadshaAuroraMode.speed;
    await _keyboardSettingsRepo.setModeParams(sadshaAuroraMode: sadshaAuroraMode);
    _updateState(emit);
  }
  
  Future<void> _setStateParams(Emitter emit,{
    required SadShaAuroraState sadshaAuroraState
  }) async{
    _boot=sadshaAuroraState.boot==null?_boot:!sadshaAuroraState.boot!;
    _awake=sadshaAuroraState.awake==null?_awake:!sadshaAuroraState.awake!;
    _sleep=sadshaAuroraState.sleep==null?_sleep:!sadshaAuroraState.sleep!;
    await _keyboardSettingsRepo.setMainlineStateParams(sadshaAuroraState: SadShaAuroraState(awake: _awake,boot: _boot,sleep: _sleep));
    _updateState(emit);
  }

  void _showColorCode(Emitter emit){
    emit(state.copyState(showColorCode: true));
  }

  void _updateState(Emitter emit){
    super.setSelectedColor(sadshaAuroraMode.color!);
    emit(state.copyState(speed: sadshaAuroraMode.speed,mode: sadshaAuroraMode.mode,color: sadshaAuroraMode.color,awake: _awake,sleep: _sleep,boot: _boot));
  }

  bool get isSpeedBarVisible => (state.mode)>0&&(state.mode)<3&&isModeBarVisible;
  bool get isModeBarVisible => (state.brightness)>0;

}