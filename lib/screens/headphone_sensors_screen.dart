import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';
import 'package:stream_testing/models/motion_event.dart';
import 'package:stream_testing/services/motion_detector.dart';

import '../widgets/chart_legend.dart';
import '../widgets/stream_chart.dart';

class HeadphoneSensorsScreen extends StatefulWidget {
  const HeadphoneSensorsScreen({Key? key}) : super(key: key);

  @override
  _HeadphoneSensorsScreenState createState() => _HeadphoneSensorsScreenState();
}

class _HeadphoneSensorsScreenState extends State<HeadphoneSensorsScreen> {
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
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<bool>(
      future: ESenseManager().isConnected(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.data!) {
          return const Center(child: Text("Device not connected"));
        }

        return _buildCharts(context);
      },
    );
  }

  Widget _buildCharts(BuildContext context) {
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
                  "Last motion: ${snapshot.data?.kind} ${snapshot.data?.value}");
            }
            return const Text("No data");
          },
        )
      ],
    );
  }
}
