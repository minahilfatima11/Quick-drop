import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static const String _keyUserId = 'userId';
  static const String _keyOrderId = 'orderid';
  static const String _keyProfileData = 'profileData';
  static const String _keyAllOrders = '_allOrders';
  static const String _keyCompletedOrders = '_completedOrders';
  static const String _keyrecentOrders = '_keyrecentOrders';

  static const String _keyDeliveredOrders = '_deliveredOrders';
  static const String _keyDeliveryPendingOrders = '_deliveryPendingOrders';
  static const String _keyPickUpOrders = '_pickUpOrders';
  static const String _keyLoginStatus = 'loginStatus'; // Key for login status
  static const String _keyOrderDetailsStatus =
      'OrderDetail'; // Key for login status
  // Save user ID
  static Future<void> saveUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, userId);
  }

  // Get user ID
  static Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  // Save user ID
  static Future<void> saveOrderId(int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyOrderId, orderId);
  }

  // Get user ID
  static Future<int?> getOrderId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyOrderId);
  }

  // Save profile data as a Map
  static Future<void> saveProfileData(Map<String, dynamic> profileData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String profileDataString = _encodeMap(profileData);
    await prefs.setString(_keyProfileData, profileDataString);
  }

  // Get profile data as a Map
  static Future<Map<String, dynamic>?> getProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profileDataString = prefs.getString(_keyProfileData);
    return profileDataString != null ? _decodeMap(profileDataString) : null;
  }

  static Future<void> saveOrderDetails(
      Map<String, dynamic> orderDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String orderDetailsStr = _encodeMap(orderDetails);
    await prefs.setString(_keyOrderDetailsStatus, orderDetailsStr);
  }

  static Future<Map<String, dynamic>?> getOrderDetailsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? orderDetailstr = prefs.getString(_keyOrderDetailsStatus);
    return orderDetailstr != null ? _decodeMap(orderDetailstr) : null;
  }

  // Save orders as a List of Maps
  // Save orders as a List of Maps
  static Future<void> saveOrders(
      String key, List<Map<String, dynamic>> orders) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> ordersStringList =
        orders.map((order) => _encodeMap(order)).toList();
    await prefs.setStringList(key, ordersStringList);
  }

// Get orders as a List of Maps
  static Future<List<Map<String, dynamic>>?> getOrders(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? ordersStringList = prefs.getStringList(key);
    return ordersStringList != null
        ? ordersStringList
            .map((orderString) => _decodeMap(orderString))
            .toList()
        : null;
  }

  // Save all orders
  static Future<void> saveAllOrders(List<Map<String, dynamic>> orders) async {
    await saveOrders(_keyAllOrders, orders);
  }

  // Get all orders
  static Future<List<Map<String, dynamic>>?> getAllOrders() async {
    return await getOrders(_keyAllOrders);
  }

  // Save completed orders
  static Future<void> saveCompletedOrders(
      List<Map<String, dynamic>> orders) async {
    await saveOrders(_keyCompletedOrders, orders);
  }

  // Get completed orders
  static Future<List<Map<String, dynamic>>?> getCompletedOrders() async {
    return await getOrders(_keyCompletedOrders);
  }

  // Save delivered orders
  static Future<void> saveDeliveredOrders(
      List<Map<String, dynamic>> orders) async {
    await saveOrders(_keyDeliveredOrders, orders);
  }

  // Get delivered orders
  static Future<List<Map<String, dynamic>>?> getDeliveredOrders() async {
    return await getOrders(_keyDeliveredOrders);
  }

  // Save delivery pending orders
  static Future<void> saveDeliveryPendingOrders(
      List<Map<String, dynamic>> orders) async {
    await saveOrders(_keyDeliveryPendingOrders, orders);
  }

  // Get delivery pending orders
  static Future<List<Map<String, dynamic>>?> getDeliveryPendingOrders() async {
    return await getOrders(_keyDeliveryPendingOrders);
  }

  // Save pickup orders
  static Future<void> savePickUpOrders(
      List<Map<String, dynamic>> orders) async {
    await saveOrders(_keyPickUpOrders, orders);
  }

  // Get pickup orders
  static Future<List<Map<String, dynamic>>?> getPickUpOrders() async {
    return await getOrders(_keyPickUpOrders);
  }

  // Save login status
  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoginStatus, isLoggedIn);
  }

  static Future<void> removeLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoginStatus);
  }

  // Get login status
  static Future<bool> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoginStatus) ??
        false; // Default to false if not set
  }

  // Remove user ID
  static Future<void> removeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
  }

  static Future<void> removeOrderId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyOrderId);
  }

  // Remove profile data
  static Future<void> removeProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyProfileData);
  }

  static Future<void> removeOrderDetailsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyOrderDetailsStatus);
  }

  static Future<void> saveRecentOrders(
      List<Map<String, dynamic>> orders) async {
    await saveOrders(_keyrecentOrders, orders);
  }

  // Get delivery pending orders
  static Future<List<Map<String, dynamic>>?> getRecentOrders() async {
    return await getOrders(_keyrecentOrders);
  }

  // Encode Map to a JSON string
  static String _encodeMap(Map<String, dynamic> data) {
    return data.map((key, value) => MapEntry(key, value.toString())).toString();
  }

  // Decode JSON string back to a Map
  static Map<String, dynamic> _decodeMap(String data) {
    Map<String, dynamic> map = {};
    data.substring(1, data.length - 1).split(', ').forEach((element) {
      List<String> keyValue = element.split(': ');
      map[keyValue[0]] = keyValue[1];
    });
    return map;
  }

  static Future<void> removeAllOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> orderKeys = [
      _keyAllOrders,
      _keyCompletedOrders,
      _keyDeliveredOrders,
      _keyDeliveryPendingOrders,
      _keyPickUpOrders,
    ];
    for (String key in orderKeys) {
      await prefs.remove(key);
    }
  }

  //packageDetails
  static Future<void> savePackageDetails(
      Map<String, dynamic> packageDetails) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(packageDetails);
    await prefs.setString('packageDetails', jsonString);
  }

  static Future<Map<String, dynamic>?> getPackageDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('packageDetails');
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null; // Return null if no data is found
  }

  Future<void> removePackageDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('packageDetails');
  }

  static Future<void> removeAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> keys = [
      _keyUserId,
      _keyOrderId,
      _keyProfileData,
      _keyAllOrders,
      _keyrecentOrders,
      _keyCompletedOrders,
      _keyDeliveredOrders,
      _keyDeliveryPendingOrders,
      _keyPickUpOrders,
      _keyLoginStatus,
      _keyOrderDetailsStatus,
      'packageDetails'
    ];

    for (String key in keys) {
      await prefs.remove(key);
    }
  }
}
