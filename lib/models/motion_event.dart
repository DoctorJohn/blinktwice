import 'package:stream_testing/models/motion_category.dart';
import 'package:stream_testing/models/motion_kind.dart';

class MotionEvent {
  final MotionKind kind;
  final MotionCategory category;
  final int value;

  MotionEvent(this.kind, this.category, this.value);
}
