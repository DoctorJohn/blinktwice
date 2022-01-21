import 'package:flutter/foundation.dart';
import 'package:stream_testing/models/motion_event.dart';
import 'package:stream_testing/models/motion_kind.dart';
import 'package:stream_testing/services/motion_recognizer.dart';

class MotionManager {
  final recognizers = <List<MotionKind>, MotionRecognizer>{};
  final Stream<MotionEvent> motionEventStream;

  MotionManager({required this.motionEventStream});

  void register({
    required List<MotionKind> pattern,
    required AsyncCallback callback,
  }) {
    wrappedCallback(pattern) async {
      resetAll();
      callback();
    }

    final recognizer = MotionRecognizer(
      motionEventStream: motionEventStream,
      pattern: pattern,
      callback: wrappedCallback,
    );

    recognizers[pattern] = recognizer;
  }

  void unregister(List<MotionKind> pattern) {
    recognizers.remove(pattern);
  }

  void resetAll() {
    for (final recognizer in recognizers.values) {
      recognizer.reset();
    }
  }
}
