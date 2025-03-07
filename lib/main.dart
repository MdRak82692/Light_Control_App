import 'package:flutter/material.dart';
import 'BlynkService.dart';
import 'dart:async';

void main() => runApp(const LightControlApp());

class LightControlApp extends StatelessWidget {
  const LightControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Light Control',
      home: LightControlHomePage(),
    );
  }
}

class LightControlHomePage extends StatefulWidget {
  const LightControlHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LightControlHomePageState createState() => _LightControlHomePageState();
}

class _LightControlHomePageState extends State<LightControlHomePage> {
  bool _isLightOn = false;
  final BlynkService _blynkService =
      BlynkService("Zb7cNgtoLGJxDabwy5kCvF-KNtM5xdDt");
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getInitialSwitchState();
    // Start a timer to fetch the switch state every second
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _checkSwitchState();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Fetch the initial switch state from Blynk when the app starts
  Future<void> _getInitialSwitchState() async {
    bool initialState = await _blynkService.getSwitchState();
    setState(() {
      _isLightOn = initialState;
    });
  }

  // Periodically check the switch state from Blynk
  Future<void> _checkSwitchState() async {
    bool serverState = await _blynkService.getSwitchState();
    if (serverState != _isLightOn) {
      setState(() {
        _isLightOn = serverState;
      });
    }
  }

  // Method to toggle the switch and send data to Blynk
  void _toggleSwitch(bool value) {
    setState(() {
      _isLightOn = value;
    });
    _blynkService.sendSwitchData(_isLightOn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isLightOn ? Colors.green[200] : Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Light Control',
          style: TextStyle(
            color: _isLightOn ? Colors.black : Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Merriweather',
          ),
        ),
        backgroundColor: _isLightOn ? Colors.green : Colors.black,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 40),
            Text(
              _isLightOn ? 'Light is ON' : 'Light is OFF',
              style: TextStyle(
                color: _isLightOn ? Colors.black : Colors.white,
                fontSize: 32,
                fontFamily: 'Merriweather',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40),
            Transform.scale(
              scale: 3,
              child: Switch(
                value: _isLightOn,
                onChanged: _toggleSwitch,
                activeTrackColor: Colors.green[700],
                activeColor: Colors.green,
                inactiveTrackColor: Colors.grey,
                inactiveThumbColor: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Tap the Switch to Turn the Light ${_isLightOn ? 'OFF' : 'ON'}.',
              style: TextStyle(
                color: _isLightOn ? Colors.black87 : Colors.white70,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontFamily: 'Merriweather',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 
