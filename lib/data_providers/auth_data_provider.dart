import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';

import 'http_client.dart';

abstract class BaseAuth {
  Future<bool> signInWithEmailAndPassword(String email, String password);
  Future<bool> signOut();
}

class AuthDataProvider implements BaseAuth {
  const AuthDataProvider({
    this.http,
  });

  final HttpClient? http;

  @override
  Future<bool> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final String body = jsonEncode({email: email, password: password});
    final Response res = await http!.post('API_ENDPOINT', body);
    print('API_ENDPOINT');
    print(res.headers);
    return res.statusCode == 200;
  }

  @override
  Future<bool> signOut() async {
    final Response res = await http!.get('API_ENDPOINT');

    return res.statusCode == 200;
  }
}
