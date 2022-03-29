import 'dart:convert';
import 'dart:io';

import 'package:finance/finance/repository/models/payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

@immutable
class FinanceApiManager {
  Map<String, String> apiDefaultHeaders() => {
        HttpHeaders.contentTypeHeader: 'application/json',
      };

  Future<List<Method>?> loadPaymentMethods(String userId,
      {bool payScreen = false}) async {
    final data = {
      "eventType": payScreen ? "read_payment_pay" : "read_payment_finance",
      "clientId": userId.toString(),
    };
    final http.Response response = await http.post(
        Uri.parse('https://services.oshinstar.net/v2/finance'),
        body: data);
    try {
      return PaymentMethods.fromMap(json.decode(response.body)).methods;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<dynamic, dynamic>> loadWalletDetails(
      String currency, int userId) async {
    final response = await http.get(
        Uri.parse('https://services.oshinstar.net/wallets/$userId/$currency'));

    return json.decode(response.body) as Map;
  }

  Future<int> withdrawBalance(int userId, Map withdrawRequest) async {
    final Map<String, dynamic> data = {"clientId": userId, "currency": "usd"};
    final response = await http.post(Uri.parse('/v2/finance'), body: data);

    return response.statusCode;
  }

  /// [buyMedia] performs request to buy media
  Future<bool> buyMedia(
      {@required String? userId,
      @required int? mediaId,
      @required int? amount,
      @required String? methodUid}) async {
    final Map<String, dynamic> data = {
      "eventType": "buy_media",
      "userId": userId,
      "mediaId": mediaId,
      "amount": amount,
      "paymentUid": methodUid,
    };

    final response = await http.post(
        Uri.parse("https://services.oshinstar.net/v2/finance"),
        headers: apiDefaultHeaders(),
        body: jsonEncode(data));

    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  ///
  Future<bool> buySubscription(
      {@required String? userId,
      @required int? amount,
      @required String? targetId,
      @required String? methodUid}) async {
    final Map<String, dynamic> data = {
      "eventType": "buy_subscription",
      "userId": userId,
      "amount": amount,
      "targetId": targetId,
      "paymentUid": methodUid,
    };
    final response = await http.post(
        Uri.parse("https://services.oshinstar.net/v2/finance"),
        headers: apiDefaultHeaders(),
        body: jsonEncode(data));

    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<bool> addFunds(
      {@required String? userId,
      @required int? amount,
      @required String? methodUid}) async {
    http.Response response;
    final Map<String, dynamic> data = {
      "eventType": "add_funds",
      "clientId": userId,
      "amount": amount,
      "paymentUid": methodUid,
    };
    response = await http.post(
        Uri.parse("https://services.oshinstar.net/v2/finance"),
        headers: apiDefaultHeaders(),
        body: jsonEncode(data));

    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<bool> tier(int tierId, int userId) async {
    Map<String, dynamic> data = {
      "eventType": "update_tier",
      "tierId": tierId,
      "userId": userId,
    };

    http.Response response;
    response = await http.post(
        Uri.parse("https://services.oshinstar.net/v2/finance"),
        body: jsonEncode(data),
        headers: apiDefaultHeaders());
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }
}
