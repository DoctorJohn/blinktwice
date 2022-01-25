import 'package:flutter/material.dart';
import 'package:stream_testing/services/calls.dart';

class CallTestScreen extends StatelessWidget {
  const CallTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test calls'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              child: const Text('Display incoming call'),
              onPressed: () => displayIncomingCall(
                "John Snow",
                "+44 113 496 0000",
              ),
            )
          ],
        ),
      ),
    );
  }
}
