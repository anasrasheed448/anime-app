import 'package:anime_twist_flut/services/CacheService.dart';
import 'package:flutter/material.dart';

class ClearCacheSetting extends StatefulWidget {
  const ClearCacheSetting({Key key}) : super(key: key);

  @override
  _ClearCacheSettingState createState() => _ClearCacheSettingState();
}

class _ClearCacheSettingState extends State<ClearCacheSetting> {
  void showConfirmationSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Network cache cleared'),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Clear network cache'),
      subtitle: Text('Get the newest data next time you open the app'),
      trailing: IconButton(
        icon: Icon(Icons.restore),
        onPressed: () async {
          await CacheService.clearCache()
              .whenComplete(() => showConfirmationSnackbar());
        },
      ),
    );
  }
}
