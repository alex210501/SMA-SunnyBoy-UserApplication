import '../utils/uuid_generator.dart';

/// Model for a single SMA device identified by its [name]
/// Used to connect to a specific [host] using a [port]
/// Every device has its pair of [username] and [password]
class SmaDevice {
  final String id;
  String name;
  String host;
  int port;
  String username;
  String password;

  SmaDevice({
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    required this.password
  }): id = UuidGenerator.generate();

  @override
  bool operator ==(Object other) {
    return (other is SmaDevice) && (other.id == id);
  }
}