import 'package:flutter/material.dart';
import 'package:flutter_callkeep/flutter_callkeep.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stream_testing/app.dart';
import 'package:stream_testing/models/gesture.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<Gesture>(GestureAdapter());
  await Hive.openBox<Gesture>("gestures");
  await CallKeep.setup();
  runApp(const App());
}
