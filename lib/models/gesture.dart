import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Gesture extends HiveObject {
  @HiveField(0)
  String? caller;

  @HiveField(1)
  String? number;

  @HiveField(2)
  String? pattern;
}

class GestureAdapter extends TypeAdapter<Gesture> {
  @override
  final typeId = 0;

  @override
  Gesture read(BinaryReader reader) {
    return Gesture()
      ..caller = reader.read()
      ..number = reader.read()
      ..pattern = reader.read();
  }

  @override
  void write(BinaryWriter writer, Gesture obj) {
    writer.write(obj.caller);
    writer.write(obj.number);
    writer.write(obj.pattern);
  }
}
