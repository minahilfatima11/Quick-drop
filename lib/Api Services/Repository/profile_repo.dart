import 'package:dio/dio.dart';
import 'package:zipline_project/core/utils/conts/api_constant.dart';

class ProfileRepo {
  Dio _client = Dio();

  Future<dynamic> fetchProfile(int userid) async {
    var url = "$BASE_URL${ApiConstant.profileEndpoint}";
    try {
      var response = await _client.post(
        url,
        data: {
          "user_id": userid,
        },
      );
      return response.data["data"];
    } catch (e) {
      rethrow;
    }
  }
}
