import 'dart:async';

import 'package:esense_flutter/esense.dart';
import 'package:stream_testing/models/motion_category.dart';
import 'package:stream_testing/models/motion_event.dart';
import 'package:stream_testing/models/motion_kind.dart';
import 'package:rxdart/rxdart.dart';

class MotionDetector {
  late final Stream<MotionEvent> motionEventStream;
  final Stream<SensorEvent> sensorEventStream;
  final Duration translationalEventInterval;
  final int accelerometerThreshold;
  final int gyroscopeThreshold;

  MotionDetector({
    required this.sensorEventStream,
    this.accelerometerThreshold = 5000,
    this.gyroscopeThreshold = 6000,
    this.translationalEventInterval = const Duration(seconds: 1),
  }) {
    final translationalTransformer = StreamTransformer.fromHandlers(
      handleData: handleTranslationalData,
      handleDone: handleDone,
      handleError: handleError,
    );

    final rotationalTransformer = StreamTransformer.fromHandlers(
      handleData: handleRotationalData,
      handleDone: handleDone,
      handleError: handleError,
    );

    final translationalStream = sensorEventStream
        .throttleTime(
          translationalEventInterval,
          leading: false,
          trailing: true,
        )
        .transform(translationalTransformer);

    final rotationalStream = sensorEventStream.transform(rotationalTransformer);

    motionEventStream = translationalStream.mergeWith([rotationalStream]);
  }

  void handleTranslationalData(SensorEvent data, EventSink<MotionEvent> sink) {
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
          surge.isNegative ? MotionKind.surgeMinus : MotionKind.surgePlus,
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
  }

  void handleRotationalData(SensorEvent data, EventSink<MotionEvent> sink) {
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

  bool hasTranslationalData(SensorEvent event) {
    return event.accel != null;
  }

  bool hasRotationalData(SensorEvent event) {
    return event.gyro != null;
  }
}
