import 'package:cdio/network/api/BaseApi.dart';
import 'package:cdio/network/model/HouseReponse.dart';
import 'package:cdio/network/model/PageableResponseModel.dart';
import 'package:cdio/network/services/HouseService.dart';

class UserService {
  static UserService shared = UserService();
  final _api = BaseApi.shared;
  final _houseService = HouseService.shared;

  Future<bool> checkIsFavorite(int id) async {
    final result = await _houseService.getHouseById(id: id);
    return result?.house?.isFavorite ?? false;
  }

  Future<bool> addFavorite({required int id}) async {
    final response = await _api.post(
        path: '/user/addFavorite',
        body: id
    );
    return HouseResponseModel.fromJson(response.data).house?.isFavorite ?? false;
  }

  Future<bool> removeFavorite({required int id}) async {
    final response = await _api.delete(
        path: '/user/removeFavorite',
        body: id
    );
    return HouseResponseModel.fromJson(response.data).house?.isFavorite ?? false;
  }

  Future<Pageable<House>> getFavoriteHouse({
    bool sortByDesc = true,
    int size = 10,
    int index = 0
  }) async {
    final response = await _api.get(
        path: '/user/getFavoriteHouse',
        params: {
          "size": size,
          "index": index,
          "enableSort": sortByDesc
        }
    );
    return PageableResponseModel.fromJson(response.data).to(type: House.new);
  }

}