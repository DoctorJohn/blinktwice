import 'package:flutter/material.dart';
import 'package:flutter_callkeep/flutter_callkeep.dart';

Future<void> displayIncomingCall(String number, String caller) async {
  const callUUID = '0783a8e5-8353-4802-9448-c6211109af51';

  CallKeep.didActivateAudioSession.listen((event) {
    debugPrint("AUDIO START: $event");
  });

  CallKeep.didDeactivateAudioSession.listen((event) {
    debugPrint("AUDIO END: $event");
  });

  CallKeep.performEndCallAction.listen((event) {
    debugPrint("CALL END: $event");
  });

  await CallKeep.displayIncomingCall(
    callUUID,
    number,
    caller,
    HandleType.number,
    false,
  );
}
