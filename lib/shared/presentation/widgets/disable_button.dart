import 'package:sadsha_aurora/shared/utility/init_sadsha_aurora.dart';
import 'package:sadsha_aurora/user_interface/disable_services/disable_services.dart';
import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_widgets.dart';
import 'package:sadsha_aurora/utility/constants.dart';
import 'package:sadsha_aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisableButton extends StatefulWidget with GlobalMixin {
  const DisableButton({super.key});

  @override
  State<DisableButton> createState() => _DisableButtonState();
}

class _DisableButtonState extends State<DisableButton> {

  late Bloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<DisableSettingsBloc>(context);
    _bloc.add(DisableEventInit());
    super.initState();
  }

  Widget _selectorWindow() {
    return BlocProvider.value(value: sl<DisableSettingsBloc>(),
      child: BlocBuilder<DisableSettingsBloc, DisableSettingsState>(
          builder: (BuildContext context, state) {
            List<Widget> disableSettingsItems=[
              if(Constants.globalConfig.isBatteryManagerEnabled && !Constants.globalConfig.isBacklightControllerServiceEnabled)
                SadShaAuroraCheckbox(
                    text: "Disable charging threshold",
                    isSelected: state.disableThreshold,
                    onChange: (_) => _bloc.add(DisableEventCheckDisableServices(disableThreshold: !state.disableThreshold))
                ),

              if(!widget.isMainLine() && !widget.isFallbackedWorkingDirectory())
                SadShaAuroraCheckbox(
                    text: "Disable faustus module",
                    isSelected: state.disableFaustusModule,
                    onChange: (_) =>
                        _bloc.add(DisableEventCheckDisableServices(disableFaustusModule: !state.disableFaustusModule))
                ),
              if(widget.isInstalledPackage() && !widget.isFallbackedWorkingDirectory())
                SadShaAuroraCheckbox(
                    text: "Uninstall SadSha Aurora",
                    isSelected: state.uninstallAurora,
                    onChange: (_) =>
                        _bloc.add(DisableEventCheckDisableServices(uninstallAurora: !state.uninstallAurora))
                )
            ];

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: disableSettingsItems.isNotEmpty?disableSettingsItems:[
                Text("Nothing to disable!")
              ],
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SadShaAuroraButton(
      action: () async {
        await sadshaAuroraDialog(
            title: "Disable Services",
            subject: "Select the services to be disabled",
            optionalWidget: _selectorWindow(),
            context: context,
            onConfirm: () {
              _bloc.add(DisableEventSubmitDisableServices());
              Navigator.pop(context);
            },
            onCancel: () {
              Navigator.pop(context);
            });
      },
      title: "Disable Features",
      animate: false,
    );
  }
}
