import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:stream_testing/models/motion_category.dart';
import 'package:stream_testing/models/motion_event.dart';
import 'package:stream_testing/models/motion_kind.dart';

class MotionDetector {
  final Stream<SensorEvent> sensorEventStream;
  late final Stream<MotionEvent> motionEventStream;
  final int accelerometerThreshold;
  final int gyroscopeThreshold;

  MotionDetector({
    required this.sensorEventStream,
    this.accelerometerThreshold = 6000,
    this.gyroscopeThreshold = 6000,
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
        sink.add(MotionEvent(
          heave.isNegative ? MotionKind.heaveMinus : MotionKind.heavePlus,
          MotionCategory.translational,
          heave,
        ));
      }

      if (surge.abs() > accelerometerThreshold) {
        sink.add(MotionEvent(
          sway.isNegative ? MotionKind.surgeMinus : MotionKind.surgePlus,
          MotionCategory.translational,
          surge,
        ));
      }

      if (sway.abs() > accelerometerThreshold) {
        sink.add(MotionEvent(
          sway.isNegative ? MotionKind.swayMinus : MotionKind.swayPlus,
          MotionCategory.translational,
          sway,
        ));
      }
    }

    if (data.gyro != null) {
      int yaw = data.gyro![0];
      int roll = data.gyro![1];
      int pitch = data.gyro![2];

      if (yaw.abs() > gyroscopeThreshold) {
        sink.add(MotionEvent(
          yaw.isNegative ? MotionKind.yawMinus : MotionKind.yawPlus,
          MotionCategory.rotational,
          yaw,
        ));
      }

      if (roll.abs() > gyroscopeThreshold) {
        sink.add(MotionEvent(
          roll.isNegative ? MotionKind.rollMinus : MotionKind.rollPlus,
          MotionCategory.rotational,
          roll,
        ));
      }

      if (pitch.abs() > gyroscopeThreshold) {
        sink.add(MotionEvent(
          pitch.isNegative ? MotionKind.pitchMinus : MotionKind.pitchPlus,
          MotionCategory.rotational,
          pitch,
        ));
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
