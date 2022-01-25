import 'package:flutter/material.dart';
import 'package:stream_testing/screens/gesture_creation_screen.dart';
import 'package:stream_testing/services/motion_manager.dart';
import 'package:stream_testing/widgets/device_card.dart';
import 'package:stream_testing/widgets/gestures_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool turnedOn = false;
  MotionManager? motionManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add gesture"),
        icon: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const GestureCreationScreen(),
            fullscreenDialog: true,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Connection"),
          ),
          DeviceCard(deviceName: "eSense-0569"),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Gestures"),
          ),
          GesturesCard(),
        ],
      ),
    );
  }
}
