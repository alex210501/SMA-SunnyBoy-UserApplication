/// Model for a single SMA device identified by its [name]
/// Used to connect to a specific [host] using a [port]
/// Every device has its pair of [username] and [password]
class SmaDevice {
  final String name;
  final String host;
  final int port;
  final String username;
  final String password;

  SmaDevice({
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    required this.password
  });
}