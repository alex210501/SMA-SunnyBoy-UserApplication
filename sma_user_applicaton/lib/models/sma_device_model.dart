import '../utils/uuid_generator.dart';

const String defaultName = 'Undefined';
const String defaultHost = 'localhost';
const int defaultPort = 5000;
const String defaultUsername = 'dummy';
const String defaultPassword = '1234';

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

  /// Default constructor that need
  /// [name], [host], [port], [username], [password]
  SmaDevice({
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    required this.password
  }): id = UuidGenerator.generate();

  /// Create an instance with default values
  SmaDevice.defaultInstance()
      : id = UuidGenerator.generate(),
        name = defaultName,
        host = defaultHost,
        port = defaultPort,
        username = defaultUsername,
        password = defaultPassword;

  /// Create an instance from JSON data
  SmaDevice.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['id'] ?? UuidGenerator.generate(),
        name = jsonData['name'] ?? defaultName,
        host = jsonData['host'] ?? defaultHost,
        port = jsonData['port'] ?? defaultPort,
        username = jsonData['username'] ?? defaultUsername,
        password = jsonData['password'] ?? defaultPassword;

  /// Return a JSON representation of the class
  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'id': id,
      'name': name,
      'host': host,
      'port': port,
      'username': username,
      'password': password
    };
  }

  /// Override the == operator to compare instance by their [id]
  @override
  bool operator ==(Object other) {
    return (other is SmaDevice) && (other.id == id);
  }
}