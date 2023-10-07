
import 'package:cdio/network/model/HouseReponse.dart';
import 'package:cdio/network/model/PageableResponseModel.dart';

import '../api/BaseApi.dart';

class QueryService {
  static QueryService shared = QueryService();
  final _api = BaseApi.shared;

  Future<Pageable<House>> search({
    required String key,
    String? province,
    String? district,
    String? wards,
    String? street,
    String? projectName,
    bool sortByDesc = true,
    int size = 10,
    int index = 0
}) async {
    final response = await _api.get(
        path: '/search',
        params: {
          "key": key,
          "province": province ?? '',
          "district": district ?? '',
          "wards": wards ?? '',
          "street": street ?? '',
          "projectName": projectName ?? '',
          "sortByDesc": sortByDesc,
          "size": size,
          "index": index
        }
    );
    return PageableResponseModel.fromJson(response.data).to(type: House.new);
  }

  Future<List<Address>> getAllAddress() async {
    final response = await _api.get(
        path: '/address/getAll',
    );
    final result = response.data['items'] as List;
    List<Address> address = [];
    for (var element in result) {
      if(element != null) {
        address.add(Address.fromJson(element));
      }
    }

    return address;
  }
}