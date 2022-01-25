import 'package:flutter/material.dart';
import 'package:flutter_callkeep/flutter_callkeep.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stream_testing/models/gesture.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<Gesture>(GestureAdapter());
  await Hive.openBox<Gesture>("gestures");
  await CallKeep.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
