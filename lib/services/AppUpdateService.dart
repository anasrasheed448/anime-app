import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateService {
  static const URL =
      'https://raw.githubusercontent.com/simrat39/AnimeTwistFlut/master/release.json';

  String latestVersion = '';
  String currentVersion = '';
  String downloadLink = '';
  bool hasUpdate = false;

  Future checkUpdate(
      {BuildContext context, bool showPopupOnUpdate = true}) async {
    var req = await http.get(URL);
    var jsonData = jsonDecode(req.body);
    latestVersion = jsonData['latest_version'];
    downloadLink = jsonData['download_link'];
    currentVersion = (await PackageInfo.fromPlatform()).version;
    if (latestVersion != currentVersion) {
      hasUpdate = true;
    }
    if (showPopupOnUpdate && hasUpdate) {
      await showDialog(
        context: context,
        builder: (context) => updateDialog(context),
      );
      return;
    }
  }

  void launchDownloadLink() async {
    if (await canLaunch(downloadLink)) {
      await launch(downloadLink);
    }
  }

  Widget updateDialog(BuildContext context) {
    return AlertDialog(
      title: Text(hasUpdate ? 'Update available!' : 'No Update available!'),
      contentTextStyle: Theme.of(context).textTheme.subtitle2.copyWith(
            color: Theme.of(context).hintColor,
          ),
      contentPadding: EdgeInsets.fromLTRB(8, 20, 8, 8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Latest version: $latestVersion',
            textAlign: TextAlign.left,
          ),
          Text(
            'Current version: $currentVersion',
            textAlign: TextAlign.left,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close'),
        ),
        if (hasUpdate)
          TextButton(
            onPressed: () => launchDownloadLink(),
            child: Text('Download'),
          ),
      ],
    );
  }
}
