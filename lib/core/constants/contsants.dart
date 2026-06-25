import 'package:url_launcher/url_launcher.dart';

String? token;
String? userId;
const String baseUrl = "https://enwanal-anaqa.com/";
void openGoogleMap(double lat, double lng) async {
  Uri googleMapUrl = Uri.parse(
    "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
  );

  if (!await launchUrl(googleMapUrl)) {
    throw Exception('Could not launch $googleMapUrl');
  } else {
    throw 'Could not open the map.';
  }
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  await launchUrl(launchUri);
}
