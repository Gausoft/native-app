import 'package:url_launcher/url_launcher.dart';

const String gentlestudentBackPack = "https://gentlestudent.gent/backpack";

class WebLauncherUtils {
  static void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch url: $url';
    }
  }

  static void launchBackpack() async => launchURL(gentlestudentBackPack);
}
