import 'package:anime_twist_flut/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetToWatchSetting extends StatefulWidget {
  const ResetToWatchSetting({Key key}) : super(key: key);

  @override
  _ResetToWatchSettingState createState() => _ResetToWatchSettingState();
}

class _ResetToWatchSettingState extends State<ResetToWatchSetting> {
  void showConfirmationSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('To watch list cleared!'),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.read(toWatchProvider);
    return ListTile(
      title: Text('Reset To Watch list'),
      subtitle: Text('Clear to watch animes'),
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
