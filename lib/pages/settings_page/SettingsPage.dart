import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:anime_twist_flut/pages/search_page/SearchPage.dart';
import 'package:anime_twist_flut/pages/settings_page/AboutAppSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/AccentPickerSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/CheckUpdateSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/ClearCacheSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/DoubleTapDurationSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/PlaybackSpeedSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/ResetFavouritesSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/ResetRecentlyWatchedSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/ResetToWatchSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/SettingsCategory.dart';
import 'package:anime_twist_flut/pages/settings_page/ZoomFactorSetting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
     DeviceOrientation.portraitUp,
     DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        primary: true,
        title: AppbarText(),
      ),
      body: Scrollbar(
        controller: scrollController,
        child: ListView(
          controller: scrollController,
          children: [
            SizedBox(height: 4.0),
            SettingsCategory(title: 'Data'),
            ResetRecentlyWatchedSetting(),
            ResetToWatchSetting(),
            ResetFavouritesSetting(),
            ClearCacheSetting(),
            SettingsCategory(title: 'Player'),
            PlaybackSpeedSetting(),
            ZoomFactorSetting(),
            DoubleTapDurationSetting(),
          ],
        ),
      ),
    );
  }
}
