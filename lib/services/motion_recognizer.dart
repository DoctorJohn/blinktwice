import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_testing/models/motion_event.dart';
import 'package:stream_testing/models/motion_kind.dart';

typedef MotionRecognizerCallback = Future<void> Function(
    List<MotionKind> pattern);

typedef MotionRecognizerProgressCallback = Future<void> Function(MotionKind match);

class MotionRecognizer {
  final Stream<MotionEvent> motionEventStream;
  final List<MotionKind> pattern;
  final MotionRecognizerCallback callback;
  final MotionRecognizerProgressCallback progressCallback;
  final rotationalBuffer = List<MotionKind>.empty(growable: true);

  MotionRecognizer({
    required this.motionEventStream,
    required this.pattern,
    required this.callback,
    required this.progressCallback,
  }) {
    motionEventStream.listen(onData, cancelOnError: true);
  }

  void onData(MotionEvent event) {
    if (event.kind != pattern[rotationalBuffer.length]) {
      // The current motion does not match the pattern
      return;
    }

    rotationalBuffer.add(event.kind);
    progressCallback(event.kind);
    debugPrint("Pattern kept matching! $rotationalBuffer");

    if (rotationalBuffer.length == pattern.length) {
      // Full pattern matches
      debugPrint("Full pattern matched! $pattern");
      callback(pattern);
      reset();
    }
  }

  void reset() {
    rotationalBuffer.clear();
  }
}
