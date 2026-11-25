
import 'sadsha_aurora_widgets/sadsha_aurora_enums.dart';

class GlobalConfig {

  //version
   String? sadshaAuroraVersion;
   String? sadshaAuroraChannel;

  //paths
   String? kWorkingDirectory;
   String? kTmpPath;
   String? kThresholdPath;

  //url
   String? kSadShaAuroraGitRawYaml;
   String? kSadShaAuroraGitRawChangelog;
   String? kFaustusGitUrl;


   //misc
   bool? kSecureBootEnabled = false;
   String deviceName;
   SadShaAuroraModeEnum sadshaAuroraMode;

   //flags
   bool isLoggingEnabled;
   bool isFaustusEnforced;
   bool isBatteryManagerEnabled;
   bool isBacklightControllerEnabled;
   bool isBacklightControllerServiceEnabled;


   GlobalConfig({
    this.sadshaAuroraVersion,
    this.sadshaAuroraChannel,
    this.kWorkingDirectory,
    this.kSadShaAuroraGitRawYaml,
    this.kSadShaAuroraGitRawChangelog,
    this.kSecureBootEnabled,
    this.kFaustusGitUrl,
    this.kTmpPath,
    this.sadshaAuroraMode=SadShaAuroraModeEnum.faustus,
    this.deviceName='',
    this.kThresholdPath,
    this.isLoggingEnabled=false,
    this.isFaustusEnforced =false,
    this.isBatteryManagerEnabled=false,
    this.isBacklightControllerEnabled=false,
    this.isBacklightControllerServiceEnabled=false
  });

  void setInstance({
    String? sadshaAuroraVersion,
    String? sadshaAuroraChannel,
    String? kExecFaustusPath,
    String? kExecBatteryManagerPath,
    String? kWorkingDirectory,
    String? kSadShaAuroraGitRawYaml,
    String? kSadShaAuroraGitRawChangelog,
    bool? kSecureBootEnabled,
    String? kFaustusGitUrl,
    SadShaAuroraModeEnum? sadshaAuroraMode,
    String? kTmpPath,
    String? deviceName,
    String? kThresholdPath,
    bool? isLoggingEnabled,
    bool? isFaustusEnforced,
    bool? isBatteryManagerEnabled,
    bool? isBacklightControllerEnabled,
    bool? isBacklightControllerServiceEnabled
  }){

    this.sadshaAuroraChannel= sadshaAuroraChannel??this.sadshaAuroraChannel;
    this.sadshaAuroraVersion=  sadshaAuroraVersion??this.sadshaAuroraVersion;
    this.kSadShaAuroraGitRawChangelog= kSadShaAuroraGitRawChangelog?? "https://raw.githubusercontent.com/fnjlabs-arch/Aurora/${sadshaAuroraChannel??this.sadshaAuroraChannel}/changelog.txt";
    this.kSadShaAuroraGitRawYaml= kSadShaAuroraGitRawYaml?? "https://raw.githubusercontent.com/fnjlabs-arch/Aurora/${sadshaAuroraChannel??this.sadshaAuroraChannel}/pubspec.yaml";
    this.kSecureBootEnabled= kSecureBootEnabled??this.kSecureBootEnabled;
    this.kWorkingDirectory= kWorkingDirectory??this.kWorkingDirectory;
    this.kFaustusGitUrl=kFaustusGitUrl??'https://github.com/legacyO7/faustus.git';
    this.sadshaAuroraMode=sadshaAuroraMode??this.sadshaAuroraMode;
    this.kTmpPath=kTmpPath??this.kTmpPath;
    this.deviceName=deviceName??this.deviceName;
    this.kThresholdPath=kThresholdPath??this.kThresholdPath;
    this.isLoggingEnabled=isLoggingEnabled??this.isLoggingEnabled;
    this.isFaustusEnforced=isFaustusEnforced??this.isFaustusEnforced;
    this.isBatteryManagerEnabled=isBatteryManagerEnabled??this.isBatteryManagerEnabled;
    this.isBacklightControllerEnabled=isBacklightControllerEnabled??this.isBacklightControllerEnabled;
    this.isBacklightControllerServiceEnabled=isBacklightControllerServiceEnabled??this.isBacklightControllerServiceEnabled;
  }

  
}
