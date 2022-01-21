import 'package:flutter/material.dart';
import '../widgets/chart_legend.dart';
import '../widgets/stream_chart.dart';
import 'package:sensors_plus/sensors_plus.dart';

class PhoneSensorsScreen extends StatelessWidget {
  const PhoneSensorsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone sensors"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamChart<AccelerometerEvent>(
                stream: accelerometerEvents,
                handler: (event) => [event.x, event.y, event.z],
                timeRange: const Duration(seconds: 15),
                minValue: -10.0,
                maxValue: 10.0,
              ),
            ),
          ),
          const ChartLegend(label: "Accel"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamChart<GyroscopeEvent>(
                stream: gyroscopeEvents,
                handler: (event) => [event.x, event.y, event.z],
                timeRange: const Duration(seconds: 15),
                minValue: -10.0,
                maxValue: 10.0,
              ),
            ),
          ),
          const ChartLegend(label: "Gyro"),
        ],
      ),
    );
  }
}
