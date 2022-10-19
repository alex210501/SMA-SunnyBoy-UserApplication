import 'dart:convert';
import 'dart:io';
import 'dart:async';

const String loginPath = '/login';
const String logoutPath = '/logout';
const String getValuesPath = '/getValues';

/// Class that makes the HTTP request with the SMA server
class SmaHttp {
  final String host;
  final int port;
  final String path;
  final HttpClient client = HttpClient();

  /// Set the [host] and [port] and construct the [SmaHttp] instance
  /// Example: [host]: `https://192.168.1.2`, [port]: `5000`
  SmaHttp(this.host, this.port): path = '$host:$port' {
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }

  /// Login to the SMA server by passing the [username] and [password]
  /// Return the HTTP response
  Future<HttpClientResponse> login(String username, String password) async {
    Map bodyMap = {
      'username': username,
      'password': password
    };

    List<int> bodyBytes = utf8.encode(json.encode(bodyMap));

    HttpClientRequest request = await client.postUrl(Uri.parse('$path$loginPath'));
    request.headers.set('Content-Length', bodyBytes.length.toString());
    request.headers.set('Content-Type', 'application/json');
    request.add(bodyBytes);

    return await request.close();
  }

  /// Logout from the SMA server by entering a [token] and [cookies]
  /// Return the HTTP response
  Future<HttpClientResponse> logout(String token, List<String>? cookies) async {
    String hostPath = '$path$logoutPath';

    return await _postWithTokenAndCookie(hostPath, token, cookies);
  }

  /// Get tha values from the SMA server by entering a [token] and [cookies]
  /// Return the HTTP response
  Future<HttpClientResponse> getValues(String token, List<String>? cookies) async {
    String hostPath = '$path$getValuesPath';

    return await _postWithTokenAndCookie(hostPath, token, cookies);
  }

  /// Extract the body of the HTTP [response] in String
  static Future<String> getBodyFromResponse(HttpClientResponse response) async {
    return await response.transform(utf8.decoder).join();
  }

  /// Private function to post data to a [path] that need a [token] and [cookies]
  /// Return the HTTP response
  Future<HttpClientResponse> _postWithTokenAndCookie(String path, String token,
      List<String>? cookies) async {
    HttpClientRequest request = await client.postUrl(Uri.parse(path));
    request.headers.set('Authorization', 'Bearer $token');
    request.headers.set('Cookie', cookies!);

    return await request.close();
  }
}


/// Main function to test the above class
Future<void> main() async {
  var smaHttp = SmaHttp('https://192.168.1.151', 5000);

  smaHttp.login('dummy', '1234').then((response) async {
    String body = await SmaHttp.getBodyFromResponse(response);

    if (response.statusCode == 200) {
      print(body);
      print(response.headers);
      Map bodyMap = json.decode(body);
      String token = bodyMap['token'];
      print(token);

      print(await SmaHttp.getBodyFromResponse(await smaHttp.getValues(token, response.headers['set-cookie'])));
      print(await SmaHttp.getBodyFromResponse(await smaHttp.logout(token, response.headers['set-cookie'])));
    }
  });
}