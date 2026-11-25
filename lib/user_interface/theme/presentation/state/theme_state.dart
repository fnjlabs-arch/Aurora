import 'package:flutter/material.dart';

abstract class ThemeState{
  ThemeMode sadshaAuroraTheme;
  ThemeState(this.sadshaAuroraTheme);
}

class ThemeStateInit extends ThemeState{
  ThemeStateInit(super.sadshaAuroraTheme);
}
class ThemeStateSwitch extends ThemeState{
  ThemeStateSwitch(super.sadshaAuroraTheme);
}

class ThemeStateSet extends ThemeState{
  ThemeStateSet(super.sadshaAuroraTheme);
}