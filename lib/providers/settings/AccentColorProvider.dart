import 'package:anime_twist_flut/providers/settings/CustomSettingProvider.dart';
import 'package:anime_twist_flut/services/SharedPreferencesManager.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AccentColorProvider extends CustomSettingProvider<Color> {
  AccentColorProvider(SharedPreferencesManager sharedPreferencesManager)
      : super(sharedPreferencesManager);

  @override
  String exceptionMessage = 'An error occured while getting accent data';

  static const Color DEFAULT_COLOR = Color(0xfffb981b);

  @override
  String preferenceName = 'accent';

  @override
  Color value = DEFAULT_COLOR;

  @override
  Future initalize() async {
    value = Color(sharedPreferencesManager.preferences.getInt(preferenceName) ??
        DEFAULT_COLOR.value);
    notifyListeners();
  }

  @override
  void writeValue() {
    sharedPreferencesManager.preferences.setInt(preferenceName, value.value);
  }
}
