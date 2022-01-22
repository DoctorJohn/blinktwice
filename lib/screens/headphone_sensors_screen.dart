import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:stream_testing/models/motion_event.dart';
import 'package:stream_testing/models/motion_kind.dart';
import 'package:stream_testing/services/motion_detector.dart';
import 'package:stream_testing/services/motion_manager.dart';
import 'package:stream_testing/widgets/reconnect_button.dart';

import '../widgets/chart_legend.dart';
import '../widgets/stream_chart.dart';

class HeadphoneSensorsScreen extends StatefulWidget {
  const HeadphoneSensorsScreen({Key? key}) : super(key: key);

  @override
  _HeadphoneSensorsScreenState createState() => _HeadphoneSensorsScreenState();
}

class _HeadphoneSensorsScreenState extends State<HeadphoneSensorsScreen> {
  final String _eSenseName = "eSense-0569";

  @override
  void initState() {
    super.initState();
    _connectToESense();
    initMotionRecognition();
  }

  void initMotionRecognition() {
    ESenseManager().connectionEvents.listen((event) {
      if (event.type == ConnectionType.connected) {
        final detector = MotionDetector(
          sensorEventStream: ESenseManager().sensorEvents,
        );
        final manager = MotionManager(
          motionEventStream: detector.motionEventStream,
        );
        manager.register(
          pattern: [
            MotionKind.surgePlus,
            MotionKind.surgeMinus,
            MotionKind.swayMinus,
            MotionKind.swayPlus,
          ],
          callback: () async {
            debugPrint("CALLBACK 2 CALLED!");
          },
        );
        manager.progressStream.listen((event) {
          debugPrint("PROGRESS: $event");
          Vibrate.vibrate();
        });
      }
    });
  }

  @override
  void dispose() {
    ESenseManager().disconnect();
    super.dispose();
  }

  Future<void> _connectToESense() async {
    await ESenseManager().disconnect();
    bool hasSuccessfulConnected = await ESenseManager().connect(_eSenseName);
    debugPrint("hasSuccessfulConnected: $hasSuccessfulConnected");
  }

  List<double> _handleAccel(SensorEvent event) {
    if (event.accel != null) {
      return [
        event.accel![0].toDouble(),
        event.accel![1].toDouble(),
        event.accel![2].toDouble(),
      ];
    } else {
      return [0.0, 0.0, 0.0];
    }
  }

  List<double> _handleGyro(SensorEvent event) {
    if (event.gyro != null) {
      return [
        event.gyro![0].toDouble(),
        event.gyro![1].toDouble(),
        event.gyro![2].toDouble(),
      ];
    } else {
      return [0.0, 0.0, 0.0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Headphone sensors"),
      ),
      body: StreamBuilder<ConnectionEvent>(
        stream: ESenseManager().connectionEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.type) {
              case ConnectionType.connected:
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StreamChart<SensorEvent>(
                          stream: ESenseManager().sensorEvents,
                          handler: _handleAccel,
                          timeRange: const Duration(seconds: 10),
                          minValue: -20000.0,
                          maxValue: 20000.0,
                        ),
                      ),
                    ),
                    const ChartLegend(label: "Accel"),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StreamChart<SensorEvent>(
                          stream: ESenseManager().sensorEvents,
                          handler: _handleGyro,
                          timeRange: const Duration(seconds: 10),
                          minValue: -20000.0,
                          maxValue: 20000.0,
                        ),
                      ),
                    ),
                    const ChartLegend(label: "Gyro"),
                    StreamBuilder<MotionEvent>(
                        stream: MotionDetector(
                          sensorEventStream: ESenseManager().sensorEvents,
                        ).motionEventStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                                "Last gesture: ${snapshot.data?.kind} ${snapshot
                                    .data?.value}");
                          }
                          return const Text("No data");
                        })
                  ],
                );
              case ConnectionType.unknown:
                return ReconnectButton(
                  child: const Text("Connection: Unknown"),
                  onPressed: _connectToESense,
                );
              case ConnectionType.disconnected:
                return ReconnectButton(
                  child: const Text("Connection: Disconnected"),
                  onPressed: _connectToESense,
                );
              case ConnectionType.device_found:
                return const Center(child: Text("Connection: Device found"));
              case ConnectionType.device_not_found:
                return ReconnectButton(
                  child: Text("Connection: Device not found - $_eSenseName"),
                  onPressed: _connectToESense,
                );
            }
          } else {
            return const Center(child: Text("Waiting for Connection Data..."));
          }
        },
      ),
    );
  }
}
