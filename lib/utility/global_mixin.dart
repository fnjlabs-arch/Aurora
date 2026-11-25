import 'dart:io';

import 'package:sadsha_aurora/utility/sadsha_aurora_widgets/sadsha_aurora_widgets.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'constants.dart';

mixin GlobalMixin{

  bool isMainLine()=>Constants.globalConfig.sadshaAuroraMode.name.contains(SadShaAuroraModeEnum.mainline.name);

  bool canLog()=> Constants.globalConfig.isLoggingEnabled || Constants.buildType==BuildType.debug;

  bool isInstalledPackage() => Constants.buildType==BuildType.deb||Constants.buildType==BuildType.rpm;

  bool isFallbackedWorkingDirectory()=>Constants.globalConfig.kWorkingDirectory=='/tmp';

  Future<String> getVersion() async{
    var version= (await PackageInfo.fromPlatform()).version;
    Constants.globalConfig.setInstance(
        sadshaAuroraVersion:version,
        sadshaAuroraChannel: version.split('-')[1]
    );
    return version;
  }
  
  List<String> kernelModules(SadShaAuroraModules? module){
    SadShaAuroraModules sadshaAuroraModule=module??(isMainLine()?SadShaAuroraModules.mainline:SadShaAuroraModules.faustus);

    if(sadshaAuroraModule==SadShaAuroraModules.faustus){
      return ['faustus'];
    }
    if(sadshaAuroraModule==SadShaAuroraModules.mainline){
      return ['asus-nb-wmi','asus-wmi','asus_nb_wmi','asus_wmi'];
    }

    return [];
  }


  bool isMainLineCompatible()=>
      File(Constants.kMainlineModuleModePath).existsSync() &&
      File(Constants.kMainlineModuleStatePath).existsSync() &&
      File(Constants.kMainlineBrightnessPath).existsSync();

  bool isDark({BuildContext? context})=>
    Theme.of(context??Constants.kScaffoldKey.currentState!.context).brightness==Brightness.dark;

  ThemeData setTheme([bool light=true]) {
    return ThemeData(
      fontFamily: 'Play',
      brightness: light ? Brightness.light : Brightness.dark,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: SadShaAuroraColors.transparent,
        foregroundColor:light?SadShaAuroraColors.black:SadShaAuroraColors.white, ),
      textTheme:  TextTheme(
        bodyMedium: TextStyle(fontSize: 13.sp),
        headlineSmall:  TextStyle(fontSize: 13.5.sp),
        headlineLarge:  TextStyle(fontSize: 22.sp,fontWeight: FontWeight.bold),
      ).apply(
        bodyColor: light?SadShaAuroraColors.black:SadShaAuroraColors.white,
      )
    );
  }


  ThemeData lightTheme()=> setTheme();
  ThemeData darkTheme()=> setTheme(false);


}