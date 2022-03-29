import 'dart:convert';
import 'package:finance/marketplace/models/media_details.dart';
import 'package:http/http.dart' as http;

int currentPage = 1;

class MarketplaceApi {
  loadMarketplace(String type, bool refresh) async {
    if (refresh) currentPage = 1;
    Map<String, dynamic> body = {
      "user_id": "255",
      "type": type,
      "page": '$currentPage',
      "limit": "12"
    };
    dynamic response;
    try {
      response = await http.post(Uri.parse("https://services.oshinstar.net/a"),
          body: body);
      currentPage++;
      return json.decode(response.body)['docs'];
    } catch (e) {
      rethrow;
    }
  }

  Future<MediaDetails> getMediaDetails(int id) async {
    late final http.Response response;
    try {
      response = await http
          .post(Uri.parse("https://services.oshinstar.net/media/details"),
              body: jsonEncode(
                {"eventType": "load_details", "mediaId": id},
              ),
              headers: {"content-type": "application/json"});
      final statusCode = response.statusCode;
      if (statusCode != 200) throw Exception();
      Map<String, dynamic> data = json.decode(response.body)['media'];
      return MediaDetails.fromMap(data);
    } catch (e) {
      rethrow;
    }
  }
}
