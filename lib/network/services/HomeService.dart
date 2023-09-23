
import 'package:cdio/network/model/BaseResponseModel.dart';
import 'package:cdio/network/model/ErrorResponseModel.dart';
import 'package:cdio/network/model/HomeResponseModel.dart';

import '../api/BaseApi.dart';

class HomeService {
  static final shared = HomeService();
  final _api = BaseApi.shared;

  Future<HomeResponse> fetchData({int size = 5, int index = 0, bool enableSort = true}) async {
    final response = await _api.get(
        path: '/home',
        params: {
          "size": size,
          "index": index,
          "enableSort": enableSort
        }
    );
    return HomeResponse.fromJson(response.data);
  }
}