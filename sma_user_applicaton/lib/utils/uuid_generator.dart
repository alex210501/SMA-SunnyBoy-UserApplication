import 'package:uuid/uuid.dart';

/// Utils class that generate a [UUID]
class UuidGenerator {
  /// Generate a time based [UUID]
  static String generate() {
    return const Uuid().v1();
  }
}

void main() {
  print(UuidGenerator.generate());
}