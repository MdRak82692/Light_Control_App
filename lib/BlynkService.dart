// ignore_for_file: file_names, empty_catches
import 'dart:async';
import 'package:http/http.dart' as http;

class BlynkService {
  final String _baseURL = 'https://sgp1.blynk.cloud/external/api';
  final String _authToken;

  static bool isLoggedIn = false;
  static String currentProfile = '';

  BlynkService(String authToken) : _authToken = authToken;

  // Send data (ON/OFF) to the Blynk server
  Future<void> sendSwitchData(bool isOn) async {
    String value = isOn ? '1' : '0';
    var url = Uri.parse('$_baseURL/update?token=$_authToken&v1=$value');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {}
  }

  // Fetch the current switch state from the Blynk server
  Future<bool> getSwitchState() async {
    var url = Uri.parse('$_baseURL/get?token=$_authToken&v1');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // The Blynk server returns the value directly, so we can just parse the body
        String switchValue = response.body
            .trim(); // Get the body directly as string and trim any whitespace
        return switchValue == '1'; // Return true if switch is ON, false if OFF
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
