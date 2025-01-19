import 'dart:io';
import 'package:dio/dio.dart';
import 'package:zipline_project/core/utils/conts/api_constant.dart';

class SignatureRepo {
  Dio _client = Dio();

  Future<Map<String, dynamic>> senderSignature(
      String orderid, File signature) async {
    var url = "$BASE_URL/user/order/sxsign";

    try {
      // Create FormData to handle the multipart request
      FormData formData = FormData.fromMap({
        'order_id': orderid,
        'sx_sign': await MultipartFile.fromFile(signature.path,
            filename: 'signature.png'),
      });

      var response = await _client.post(url, data: formData);

      return Map.from(response.data);
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> reciverSignature(
      String orderid, File signature) async {
    var url = "$BASE_URL/user/order/rxsign";

    try {
      // Create FormData to handle the multipart request
      FormData formData = FormData.fromMap({
        'order_id': orderid,
        'rx_sign': await MultipartFile.fromFile(signature.path,
            filename: 'signature.png'),
      });

      var response = await _client.post(url, data: formData);

      return Map.from(response.data);
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}
