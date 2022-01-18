import 'package:flutter/material.dart';

import './widgets/task_button.dart';
import '../tasks/task3.dart';
import '../tasks/task4.dart';

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
              page: Task3(title: "Phone sensors"),
            ),
            SizedBox(height: 16),
            TaskButton(
              name: "Earable sensors",
              page: Task4(title: "Earable sensors"),
            ),
          ],
        ),
      ),
    );
  }
}
