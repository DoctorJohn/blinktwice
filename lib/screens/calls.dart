import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_callkeep/flutter_callkeep.dart';

class Calls extends StatelessWidget {
  const Calls({Key? key}) : super(key: key);

  Future<void> displayIncomingCall(BuildContext context) async {
    await CallKeep.askForPermissionsIfNeeded(context);
    const callUUID = '0783a8e5-8353-4802-9448-c6211109af51';
    const number = '+49 70 123 45 67';
    const name = "Arbeit";

    await CallKeep.displayIncomingCall(
        callUUID, number, name, HandleType.number, false);
  }

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
              onPressed: () => displayIncomingCall(context),
            )
          ],
        ),
      ),
    );
  }
}
