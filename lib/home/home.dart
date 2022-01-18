import 'package:flutter/material.dart';

import './widgets/task_button.dart';
import '../tasks/task3.dart';
import '../tasks/task4.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final Map<String, Widget> _screens = const {
    "Aufgabe 3": Task3(title: "Aufgabe 3"),
    "Aufagbe 4": Task4(title: "eSense Demo"),
  };

  List<Widget> _buildButtons() {
    return _screens.entries
        .map((e) => TaskButton(name: e.key, page: e.value))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Workshop"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blueGrey.shade200],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildButtons(),
          ),
        ),
      ),
    );
  }
}
