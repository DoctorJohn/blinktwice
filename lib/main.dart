import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkeep/flutter_callkeep.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stream_testing/app.dart';
import 'package:stream_testing/models/gesture.dart';
import 'package:stream_testing/models/motion_kind.dart';
import 'package:stream_testing/services/calls.dart';
import 'package:stream_testing/services/motion_detector.dart';
import 'package:stream_testing/services/motion_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<Gesture>(GestureAdapter());
  await Hive.openBox<Gesture>("gestures");
  await CallKeep.setup();

  ESenseManager().connectionEvents.listen((event) {
    if (event.type == ConnectionType.connected) {
      final detector = MotionDetector(
        sensorEventStream: ESenseManager().sensorEvents,
      );

      final manager = MotionManager(
        motionEventStream: detector.motionEventStream,
      );

      final box = Hive.box<Gesture>('gestures');
      final gestures = box.values;

      for (final gesture in gestures) {
        final pattern = gesture.pattern!
            .split(",")
            .map((motionName) => MotionKind.values
                .firstWhere((motionKind) => motionKind.name == motionName))
            .toList();

        manager.register(
          pattern: pattern,
          callback: () async {
            debugPrint("CALLING ${gesture.caller}");
            displayIncomingCall(gesture.number!, gesture.caller!);
          },
        );

        debugPrint("REGISTERED ${gesture.caller}");
      }

      manager.progressStream.listen((event) {
        debugPrint("PROGRESS: $event");
        Vibrate.vibrate();
      });
    }
  });

  runApp(const App());
}
