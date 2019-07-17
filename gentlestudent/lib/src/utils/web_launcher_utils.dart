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

  static Future<void> makePhoneCall(String phoneNumber) async {
    final url = "tel://$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> sendEmail(String emailAddress, String subject) async {
    final url = "mailto:$emailAddress?subject=$subject";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void launchBackpack() async => launchURL(gentlestudentBackPack);
}
