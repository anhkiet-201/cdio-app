import 'package:cdio/network/model/HouseReponse.dart';
import 'package:cdio/network/model/PageableResponseModel.dart';

import '../api/BaseApi.dart';

class HouseService {
  static HouseService shared = HouseService();
  final _api = BaseApi.shared;

  Future<List<HouseResponse>> getHouseSameProject({required int id, int size = 10, int index = 0}) async {
    final response = await _api.get(
        path: '/house/getSameProject',
        params: {
          "id": id,
          "size": size,
          "index": index,
          "enableSort": true
        }
    );
    final result = PageableResponseModel.fromJson(response.data);
    return result.items?.map((e) => HouseResponse.fromJson(e)).toList() ?? [];
  }
}