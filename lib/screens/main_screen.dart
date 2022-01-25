import 'package:flutter/material.dart';
import 'package:stream_testing/models/debug_option.dart';
import 'package:stream_testing/screens/call_test_screen.dart';
import 'package:stream_testing/screens/gesture_creation_screen.dart';
import 'package:stream_testing/screens/headphone_sensors_screen.dart';
import 'package:stream_testing/screens/phone_sensors_screen.dart';
import 'package:stream_testing/services/motion_manager.dart';
import 'package:stream_testing/widgets/compatibility_card.dart';
import 'package:stream_testing/widgets/device_card.dart';
import 'package:stream_testing/widgets/gestures_card.dart';
import 'package:stream_testing/widgets/permissions_card.dart';

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
        title: const Text("Just Blink Twice"),
        actions: _buildActions(context),
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
            child: Text("Setup"),
          ),
          PermissionsCard(),
          CompatibilityCard(),
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

  List<Widget> _buildActions(BuildContext context) {
    return [
      PopupMenuButton(
        onSelected: (selection) {
          switch (selection) {
            case DebugOption.phoneSensors:
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PhoneSensorsScreen(),
                fullscreenDialog: true,
              ));
              break;
            case DebugOption.headphoneSensors:
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const HeadphoneSensorsScreen(),
                fullscreenDialog: true,
              ));
              break;
            case DebugOption.callTest:
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CallTestScreen(),
                fullscreenDialog: true,
              ));
              break;
          }
        },
        itemBuilder: (context) => <PopupMenuEntry<DebugOption>>[
          const PopupMenuItem<DebugOption>(
            value: DebugOption.phoneSensors,
            child: Text("Debug phone sensors"),
          ),
          const PopupMenuItem<DebugOption>(
            value: DebugOption.headphoneSensors,
            child: Text("Debug headphone sensors"),
          ),
          const PopupMenuItem<DebugOption>(
            value: DebugOption.callTest,
            child: Text("Debug calls"),
          ),
        ],
      ),
    ];
  }
}
