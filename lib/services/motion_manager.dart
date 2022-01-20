import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:stream_testing/models/motion_event.dart';
import 'package:stream_testing/models/motion_kind.dart';

class MotionManager {
  final Stream<SensorEvent> sensorEventStream;
  late final Stream<MotionEvent> motionEventStream;
  final int accelerometerThreshold;
  final int gyroscopeThreshold;

  MotionManager({
    required this.sensorEventStream,
    this.accelerometerThreshold = 6000,
    this.gyroscopeThreshold = 5000,
  }) {
    StreamTransformer<SensorEvent, MotionEvent> transformer =
        StreamTransformer.fromHandlers(
      handleData: handleData,
      handleDone: handleDone,
      handleError: handleError,
    );
    motionEventStream = sensorEventStream.transform(transformer);
  }

  void handleData(SensorEvent data, EventSink<MotionEvent> sink) {
    if (data.accel != null) {
      int heave = data.accel![0];
      int surge = data.accel![1];
      int sway = data.accel![2];

      if (heave.abs() > accelerometerThreshold) {
        sink.add(MotionEvent(MotionKind.heave, heave));
      }

      if (surge.abs() > accelerometerThreshold) {
        sink.add(MotionEvent(MotionKind.surge, surge));
      }

      if (sway.abs() > accelerometerThreshold) {
        sink.add(MotionEvent(MotionKind.sway, sway));
      }
    }

    if (data.gyro != null) {
      int yaw = data.gyro![0];
      int roll = data.gyro![1];
      int pitch = data.gyro![2];

      if (yaw.abs() > gyroscopeThreshold) {
        sink.add(MotionEvent(MotionKind.yaw, yaw));
      }

      if (roll.abs() > gyroscopeThreshold) {
        sink.add(MotionEvent(MotionKind.roll, roll));
      }

      if (pitch.abs() > gyroscopeThreshold) {
        sink.add(MotionEvent(MotionKind.pitch, pitch));
      }
    }
  }

  void handleDone(EventSink<MotionEvent> sink) {
    sink.close();
  }

  void handleError(
    Object obj,
    StackTrace stackTrace,
    EventSink<MotionEvent> sink,
  ) {
    sink.addError(obj, stackTrace);
  }
}
