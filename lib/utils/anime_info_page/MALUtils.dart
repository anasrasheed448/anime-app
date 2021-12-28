// Package imports:
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class MALUtils {
  static Future launchMalLink(int malId) async {
    var url = 'https://myanimelist.net/anime/$malId';
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    }
  }
}
