
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlLink(String url) async {
  final uri = Uri.parse(url);

  try {
    await launchUrl(uri);
  } catch (e) {
    print('Error: $e');
  }
}