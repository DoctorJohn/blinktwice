import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:stream_testing/models/motion_event.dart';
import 'package:stream_testing/models/motion_kind.dart';
import 'package:stream_testing/services/motion_recognizer.dart';

class MotionManager {
  final recognizers = <List<MotionKind>, MotionRecognizer>{};
  final Stream<MotionEvent> motionEventStream;
  final progressStreamController = StreamController<MotionKind>.broadcast();

  Stream<MotionKind> get progressStream => progressStreamController.stream;

  MotionManager({required this.motionEventStream});

  void register({
    required List<MotionKind> pattern,
    required AsyncCallback callback,
  }) {
    resetAndCallback(pattern) async {
      resetAll();
      callback();
    }

    final recognizer = MotionRecognizer(
      motionEventStream: motionEventStream,
      pattern: pattern,
      callback: resetAndCallback,
      progressCallback: reportProgress,
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

  Future<void> reportProgress(MotionKind match) async {
    progressStreamController.add(match);
  }
}
