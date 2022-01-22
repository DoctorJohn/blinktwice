import 'dart:math';

import 'package:esense_flutter/esense.dart';
import 'package:stream_testing/models/motion_category.dart';
import 'package:stream_testing/models/motion_event.dart';
import 'package:stream_testing/models/motion_kind.dart';
import 'package:rxdart/rxdart.dart';

class PostureDetector {
  final Stream<SensorEvent> sensorEventStream;
  late final Stream<MotionEvent> motionEventStream;
  MotionKind? lastPosture;

  PostureDetector({required this.sensorEventStream}) {
    const interval = Duration(seconds: 1);
    motionEventStream = sensorEventStream
        .where(hasTranslationalData)
        .debounceTime(interval)
        .map(mapper);
  }

  bool hasTranslationalData(SensorEvent event) {
    return event.accel != null;
  }

  MotionEvent mapper(SensorEvent event) {
    int heave = event.accel![0];
    int surge = event.accel![1];
    int sway = event.accel![2];

    if (heave > max(surge, sway)) {
      return MotionEvent(
        heave.isNegative ? MotionKind.heaveMinus : MotionKind.heavePlus,
        MotionCategory.translational,
        heave,
      );
    } else if (sway > max(heave, surge)) {
      return MotionEvent(
        sway.isNegative ? MotionKind.surgeMinus : MotionKind.surgePlus,
        MotionCategory.translational,
        surge,
      );
    } else {
      return MotionEvent(
        sway.isNegative ? MotionKind.swayMinus : MotionKind.swayPlus,
        MotionCategory.translational,
        sway,
      );
    }
  }
}
