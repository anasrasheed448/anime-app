import 'package:anime_twist_flut/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetRecentlyWatchedSetting extends StatefulWidget {
  const ResetRecentlyWatchedSetting({Key key}) : super(key: key);

  @override
  _ResetRecentlyWatchedSettingState createState() =>
      _ResetRecentlyWatchedSettingState();
}

class _ResetRecentlyWatchedSettingState
    extends State<ResetRecentlyWatchedSetting> {
  void showConfirmationSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Recently watched animes cleared!'),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.read(recentlyWatchedProvider);
    return ListTile(
      title: Text('Reset Recently Watched'),
      subtitle: Text('Clear recently watched animes'),
      trailing: IconButton(
        icon: Icon(Icons.restore),
        onPressed: provider.hasData()
            ? () => setState(() {
                  provider.clearData();
                  showConfirmationSnackbar();
                })
            : null,
      ),
    );
  }
}
