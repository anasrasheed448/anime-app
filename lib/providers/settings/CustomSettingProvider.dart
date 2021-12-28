import 'package:anime_twist_flut/services/SharedPreferencesManager.dart';
import 'package:flutter/foundation.dart';

abstract class CustomSettingProvider<T> extends ChangeNotifier {
  CustomSettingProvider(this.sharedPreferencesManager);

  final SharedPreferencesManager sharedPreferencesManager;

  String preferenceName = 'pref';
  String exceptionMessage = 'Could not load setting';

  T value;

  Future initalize();

  void updateValue(T newValue) {
    if (newValue == value) return;
    value = newValue;
    notifyListeners();
    writeValue();
  }

  void writeValue();
}
