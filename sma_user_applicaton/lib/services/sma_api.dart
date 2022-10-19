import 'dart:convert';
import 'dart:io';

import '../models/sma_device_model.dart';
import '../models/sma_data_model.dart';
import 'sma_http.dart';

/// Class that make the interface between the application
/// and the HTTP requests
class SmaApi {
  final SmaDevice _smaDevice;
  final SmaHttp _smaHttp;
  bool _isConnected = false;
  String _token = "";
  List<String>? _cookies;

  /// Getter for [_isConnected]
  bool get isConnected => _isConnected;

  /// Constructor that take an [SmaDevice] as input
  SmaApi(this._smaDevice): _smaHttp = SmaHttp(_smaDevice.host, _smaDevice.port);

  /// Login to the SMA server
  /// Register the [token] and [cookies] to use them in further requests
  Future<void> login() async {
    HttpClientResponse response = await _smaHttp.login(_smaDevice.username, _smaDevice.password);
    String body = await SmaHttp.getBodyFromResponse(response);

    if (response.statusCode != 200) {
      _isConnected = false;
      throw Exception("Error during the login (${response.statusCode}): $body");
    }

    Map jsonBody = json.decode(body);

    _token = jsonBody['token'] ?? "";
    _cookies = response.headers['set-cookie'] ?? <String>[];
    _isConnected = true;
  }

  /// Logout from the SMA server
  /// Clear the [token] and [cookies] fields
  Future<void> logout() async {
    if (!_isConnected) {
      throw Exception("You are not connected to the server !");
    }

    HttpClientResponse response = await _smaHttp.logout(_token, _cookies);

    String body = await SmaHttp.getBodyFromResponse(response);

    if (response.statusCode != 200) {
      throw Exception("Error during the logout (${response.statusCode}): $body");
    }

    /// Clear [token], [cookies] and set [isConnected] to false
    _isConnected = false;
    _token = "";
    _cookies = <String>[];
  }

  /// Get the values from the server and return an SmaData
  Future<SmaData> getValues() async {
    HttpClientResponse response = await _smaHttp.getValues(_token, _cookies);
    String body = await SmaHttp.getBodyFromResponse(response);

    if (response.statusCode != 200) {
      throw Exception("Error during the getValues (${response.statusCode}): $body");
    }

    return SmaData.fromJson(json.decode(body));
  }
}


void main() {
  SmaApi smaApi = SmaApi(SmaDevice(
      name: "First device",
      host: "https://192.168.1.151",
      port: 5000,
      username: "dummy",
      password: "1234"));

  smaApi.login().then((_) async {
    SmaData values = await smaApi.getValues();
    print(jsonEncode(values));
  });
}