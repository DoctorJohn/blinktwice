import 'package:flutter/material.dart';
import 'package:stream_testing/widgets/esense_device.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool turnedOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Connection"),
          ),
          ESenseDevice(deviceName: "eSense-0569"),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Gestures"),
          ),
        ],
      ),
    );
  }
}
