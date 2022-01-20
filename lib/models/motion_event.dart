import 'package:stream_testing/models/motion_kind.dart';

class MotionEvent {
  final MotionKind kind;
  final int value;

  MotionEvent(this.kind, this.value);
}