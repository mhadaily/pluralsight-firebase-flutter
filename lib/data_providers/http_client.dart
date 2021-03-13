import 'package:http/http.dart' as http;

class HttpClient {
  final uri = Uri.https(
    'reqres.in',
    "/api/users/",
  );
  Future<http.Response> get(String api) async {
    // just to fake an API request
    await http.get(uri);
    return Future.delayed(
      const Duration(seconds: 1),
      () => http.Response('success', 200),
    );
  }

  Future<http.Response> post(String api, String body) async {
    // just to fake an API request
    await http.get(uri);
    return Future.delayed(
      const Duration(seconds: 1),
      () => http.Response('success', 200),
    );
  }
}
