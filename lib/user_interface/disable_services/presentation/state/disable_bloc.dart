import 'dart:io';


import 'package:sadsha_aurora/shared/data/isar_manager/repository/isar_delegate.dart';
import 'package:sadsha_aurora/shared/disable_settings/shared_disable_services.dart';
import 'package:sadsha_aurora/shared/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_enums.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'disable_state.dart';
import 'disabler_event.dart';

class DisableSettingsBloc extends TerminalBaseBloc<DisableEvent,DisableSettingsState> {
  DisableSettingsBloc(this._disablerRepo, this._isarDelegate) : super(const DisableSettingsState.init()){
    on<DisableEventInit>((_, emit) => emit(const DisableSettingsState.init()));
    on<DisableEventCheckDisableServices>((event, emit) => _setDisableService(event,emit));
    on<DisableEventSubmitDisableServices>((_, emit) => _disableServices(emit));
 }

  final DisableSettingsRepo _disablerRepo;
  final IsarDelegate _isarDelegate;


  void _setDisableService(DisableEventCheckDisableServices event, emit) {
      emit(state.setState(
        disableThreshold: event.disableThreshold,
        disableFaustusModule: event.disableFaustusModule,
        uninstallAurora: event.uninstallAurora
      ));
  }

  Future _disableServices(Emitter emit) async{

    super.setLoad();
      DisableEnum disable=DisableEnum.none;
      if(state.uninstallAurora){
        disable=DisableEnum.uninstall;
      }else if(state.disableFaustusModule && state.disableThreshold){
       disable=DisableEnum.all;
      }else if(state.disableFaustusModule){
        disable=DisableEnum.faustus;
      }else if(state.disableThreshold){
        disable=DisableEnum.service;
      }else{
        return;
      }

      if(await _disablerRepo.disableServices(disable: disable)) {
        if(state.uninstallAurora){
          exit(0);
        }else{
          if(state.disableThreshold){
            await _isarDelegate.saveBatteryAvailability(false);
          }
          super.restartApp();
        }
      } else{
        sadshaAuroraSnackBar(text: "Something went wrong",isPositive: false);
        emit(state.setState(state: DisableStateStates.init));
      }

      super.setUnLoad();
  }

}
