import 'dart:io';

import 'package:dio/dio.dart';
import 'package:zipline_project/core/utils/conts/api_constant.dart';

class OrderPlaceRepo {
  Dio _client = Dio();
  Future<Map<String, dynamic>> senderDetails(
      Map<String, dynamic> sender) async {
    var url = "$BASE_URL/user/order/sxdetails";
    try {
      var response = await _client.post(
        url,
        data: sender, // data is included in the body
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      var data = Map<String, dynamic>.from(response.data);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> reciverDetails(
      Map<String, dynamic> reciver) async {
    var url = "$BASE_URL${ApiConstant.reciveirDetailEndpoint}";
    try {
      var response = await _client.post(
        url,
        data: reciver, // data is included in the body
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      var data = Map<String, dynamic>.from(response.data);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> PackageDetails({
    required File imageFile, // Accepts the image file directly
    required String orderId,
    required String itemName,
    required String itemSize,
    required String itemWeight,
    required String itemType,
    required String itemCategory,
    required String deliveryReq,
    required String charges,
  }) async {
    try {
      var data = FormData.fromMap({
        'order_id': orderId,
        'item_name': itemName,
        'item_size': itemSize,
        'item_weight': itemWeight,
        'item_type': itemType,
        'item_category': itemCategory,
        'delivery_req': deliveryReq,
        'charges': charges,
        "item_image": await MultipartFile.fromFile(imageFile.path,
            filename: imageFile.path.split('/').last)
      });

      var dio = Dio();
      var response = await dio.post(
        'https://zipline.zolovio.com/zipline/user/order/pxdetails',
        data: data,
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        return {'error': response.statusMessage};
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchPackageDetails(String orderId) async {
    var url =
        "https://zipline.zolovio.com/zipline/user/order/showDetails?order_id=${orderId}";
    try {
      var response = await _client.get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      var data = Map<String, dynamic>.from(response.data["details"]);
      return data;
    } catch (e) {
      rethrow;
    }
  }
}
