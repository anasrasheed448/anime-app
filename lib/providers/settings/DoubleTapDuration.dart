import 'package:anime_twist_flut/providers/settings/CustomSettingProvider.dart';
import 'package:anime_twist_flut/services/SharedPreferencesManager.dart';

class DoubleTapDurationProvider extends CustomSettingProvider<int> {
  DoubleTapDurationProvider(SharedPreferencesManager sharedPreferencesManager)
      : super(sharedPreferencesManager);

  @override
  String preferenceName = 'doubleTapDuration';

  @override
  String exceptionMessage =
      'An error occured while getting the double tap duration';

  @override
  int value = DEFAULT_VALUE;

  static const DEFAULT_VALUE = 10;
  static const POSSIBLE_VALUES = [5, 10, 15, 20, 30, 60];

  @override
  Future initalize() async {
    value = sharedPreferencesManager.preferences.getInt(preferenceName) ??
        DEFAULT_VALUE;
    notifyListeners();
  }

  @override
  void writeValue() {
    sharedPreferencesManager.preferences.setInt(preferenceName, value);
  }
}
