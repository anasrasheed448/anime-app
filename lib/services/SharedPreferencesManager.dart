import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  SharedPreferences preferences;

  /// Initializes [preferences] to hold the SharedPreference
  Future initialize() async {
    preferences = await SharedPreferences.getInstance();
  }
}
