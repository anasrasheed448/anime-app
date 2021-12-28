import 'package:anime_twist_flut/providers/settings/CustomSettingProvider.dart';
import 'package:anime_twist_flut/services/SharedPreferencesManager.dart';

class PlaybackSpeedProvider extends CustomSettingProvider<double> {
  static const List<double> POSSIBLE_SPEEDS = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    4.0,
  ];

  @override
  String preferenceName = 'playbackSpeed';

  @override
  String exceptionMessage = 'An error occured while getting the playback speed';

  @override
  double value = DEFAULT_VALUE;

  static const DEFAULT_VALUE = 1.0;

  PlaybackSpeedProvider(SharedPreferencesManager sharedPreferencesManager)
      : super(sharedPreferencesManager);

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
