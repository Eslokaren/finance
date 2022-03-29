import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class LoginApi {
  Future checkEmailExists(String email) async {}

  Future login(String email, String password) async {
    Map data = {"email": email, "password": password, "eventType": "auth"};
    final response = await http.post(
        Uri.parse('https://services.oshinstar.net/v2/finance'),
        body: json.encode(data),
        headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        "Access-Control-Allow-Credentials": "true",
        "Origin": "https://wallet.oshinstar.net"
      });

    return response;

  }
}
