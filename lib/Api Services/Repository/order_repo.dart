import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:zipline_project/core/utils/conts/api_constant.dart';

class OrderRepo {
  final Dio _client = Dio();

  Future<List<Map<String, dynamic>>> getAllOrder(int userId) async {
    var url = "$BASE_URL/user/order/summary/all/?user_id=$userId";
    try {
      var response = await _client.get(url);
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response.data["orders"]);
      return data;
    } catch (e) {
      log("${e.toString()}");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getCompletedOrder(int userId) async {
    var url = "$BASE_URL${ApiConstant.completedordersEndpoint}?user_id=$userId";
    try {
      var response = await _client.get(url);
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response.data["orders"]);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getPickUpOrder(int userId) async {
    var url = "$BASE_URL/user/order/summary/pickup?user_id=$userId";
    try {
      var response = await _client.get(url);
      log("${response.data}");
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response.data["orders"]);

      return data;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getDeliveredOrder(int userId) async {
    var url = "$BASE_URL${ApiConstant.DeliveredordersEndpoint}?user_id=$userId";
    try {
      var response = await _client.get(url);
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response.data["orders"]);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getDeliveryPendingOrder(int userId) async {
    var url =
        "$BASE_URL${ApiConstant.DeliveryPendingordersEndpoint}?user_id=$userId";
    try {
      var response = await _client.get(url);
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response.data["orders"]);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> orderDetails(String OrderNo) async {
    var url = "$BASE_URL/user/order/details?order_no=${OrderNo}";
    try {
      var response = await _client.get(url);
      Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
      log("${data}");

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> recentOrder(int userId) async {
    var url = "$BASE_URL/user/recent/orders?user_id=$userId";
    try {
      var response = await _client.get(url);
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response.data["orders"]);
      return data;
    } catch (e) {
      log("${e.toString()}");
      rethrow;
    }
  }
}
