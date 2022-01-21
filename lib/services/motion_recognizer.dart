import 'package:flutter/foundation.dart';
import 'package:stream_testing/models/motion_category.dart';
import 'package:stream_testing/models/motion_event.dart';
import 'package:stream_testing/models/motion_kind.dart';

class MotionRecognizer {
  final Stream<MotionEvent> motionEventStream;
  final List<MotionKind> rotationalPattern;
  final AsyncCallback callback;
  final rotationalBuffer = List<MotionKind>.empty(growable: true);

  MotionRecognizer({
    required this.motionEventStream,
    required this.rotationalPattern,
    required this.callback,
  }) {
    motionEventStream.listen(onData, cancelOnError: true);
  }

  void onData(MotionEvent event) {
    if (event.category != MotionCategory.rotational) {
      // Translational motions are not supported yet
      return;
    }

    if (event.kind != rotationalPattern[rotationalBuffer.length]) {
      // The current motion does not match the pattern
      return;
    }

    rotationalBuffer.add(event.kind);
    debugPrint("Pattern kept matching! $rotationalBuffer");

    if (rotationalBuffer.length == rotationalPattern.length) {
      // Full pattern matches
      debugPrint("Full pattern matched! $rotationalPattern");
      callback();
      rotationalBuffer.clear();
    }
  }
}
