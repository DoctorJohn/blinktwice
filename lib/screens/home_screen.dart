import 'package:flutter/material.dart';

import '../widgets/task_button.dart';
import './phone_sensors_screen.dart';
import './headphone_sensors_screen.dart';
import './call_test_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Screen selection"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            TaskButton(
              name: "Phone sensors",
              page: PhoneSensorsScreen(),
            ),
            SizedBox(height: 16),
            TaskButton(
              name: "Headphone sensors",
              page: HeadphoneSensorsScreen(),
            ),
            SizedBox(height: 16),
            TaskButton(
              name: "Test calls",
              page: CallTestScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
