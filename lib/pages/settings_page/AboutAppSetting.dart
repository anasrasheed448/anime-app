import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppSetting extends StatefulWidget {
  const AboutAppSetting({Key key}) : super(key: key);

  @override
  _AboutAppSettingState createState() => _AboutAppSettingState();
}

class _AboutAppSettingState extends State<AboutAppSetting> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('About App'),
      subtitle: Text('Learn more!'),
      onTap: () => showInfoDialog(),
      trailing: IconButton(
        icon: Icon(Icons.info_outline_rounded),
        onPressed: () => showInfoDialog(),
      ),
    );
  }

  void showInfoDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'AnimeTwistFlut',
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.github,
              ),
              iconSize: 50.0,
              onPressed: () async {
                var url = 'https://github.com/simrat39/AnimeTwistFlut';
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.discord,
              ),
              iconSize: 50.0,
              onPressed: () async {
                var url = 'https://discord.gg/Ea3Mq9n';
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
