import 'dart:convert';
import 'dart:io';

import 'package:finance/finance/repository/models/payment_methods.dart';
import 'package:http/http.dart' as http;

class FinanceApi {
  Future<bool> addPaymentMethod(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("https://services.oshinstar.net/v2/finance"),
      body: jsonEncode(data),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',

      },
    );

    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<List<Method>?> loadPaymentMethods(dynamic userId,
      {bool payScreen = false}) async {
    final data = {
      "eventType": payScreen ? "read_payment_pay" : "read_payment_finance",
      "clientId": userId.toString(),
    };
    final http.Response response = await http.post(
      Uri.parse('https://services.oshinstar.net/v2/finance'),
      body: data,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        "Access-Control-Allow-Origin": 'wallet.oshinstar.net',
        "Access-Control-Allow-Methods": 'GET, POST, PUT, PATCH, DELETE',
        '"Access-Control-Allow-Headers': 'X-Requested-With,content-type',
        "Access-Control-Allow-Credentials": "true"
      },
    );
    try {
      return PaymentMethods.fromMap(json.decode(response.body)).methods;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> loadWalletDetails(
      String currency, int userId) async {
    final response = await http.get(
        Uri.parse('https://services.oshinstar.net/wallets/$userId/$currency'));

    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<bool> addFunds(Map data) async {
    http.Response response;
    response = await http.post(
      Uri.parse("https://services.oshinstar.net/v2/finance"),
      body: json.encode(data),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        "Access-Control-Allow-Origin": 'wallet.oshinstar.net',
        "Access-Control-Allow-Methods": 'GET, POST, PUT, PATCH, DELETE',
        '"Access-Control-Allow-Headers': 'X-Requested-With,content-type',
        "Access-Control-Allow-Credentials": "true"
      },
    );

    print("status code type: ${response.statusCode.runtimeType}");
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }
}
