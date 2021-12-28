import 'package:anime_twist_flut/providers/settings/CustomSettingProvider.dart';
import 'package:anime_twist_flut/services/SharedPreferencesManager.dart';

class ZoomFactorProvider extends CustomSettingProvider<double> {
  ZoomFactorProvider(SharedPreferencesManager sharedPreferencesManager)
      : super(sharedPreferencesManager);

  @override
  String preferenceName = 'zoomFactor';

  @override
  String exceptionMessage = 'An error occured while getting the zoom factor';

  @override
  double value = DEFAULT_VALUE;

  static const DEFAULT_VALUE = 1.1;
  static const MIN = 1.0;
  static const MAX = 2.0;

  @override
  Future initalize() async {
    value = sharedPreferencesManager.preferences.getDouble(preferenceName) ??
        DEFAULT_VALUE;
    notifyListeners();
  }

  @override
  void writeValue() {
    sharedPreferencesManager.preferences.setDouble(preferenceName, value);
  }
}
