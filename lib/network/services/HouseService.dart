import 'dart:ffi';

import 'package:cdio/network/model/HouseReponse.dart';
import 'package:cdio/network/model/PageableResponseModel.dart';

import '../api/BaseApi.dart';

class HouseService {
  static HouseService shared = HouseService();
  final _api = BaseApi.shared;

  Future<List<House>> getHouseSameProject(
      {required int id, int size = 10, int index = 0}) async {
    final response = await _api.get(
        path: '/house/getSameProject',
        params: {"id": id, "size": size, "index": index, "enableSort": true});
    final result = PageableResponseModel.fromJson(response.data);
    return result.items?.map((e) => House.fromJson(e)).toList() ?? [];
  }

  Future<HouseResponseModel?> getHouseById({required int id}) async {
    final response = await _api.get(path: '/house/getById', params: {
      "id": id,
    });
    return HouseResponseModel.fromJson(response.data);
  }

  Future<HouseResponseModel?> createHouse(
      {required String displayName,
      String? description,
      int? projectId,
      String? projectName,
      String? projectStatus,
      String? contactInfo,
      String? projectThumbNailUrl,
      String? projectDescription,
      String? province,
      String? district,
      String? wards,
      String? street,
      String? addressDescription,
      String? thumbNailUrl,
      double? area,
      int? numKitchen,
      int? numBathroom,
      int? numToilet,
      int? numLivingRoom,
      int? numBedRoom,
      List<String>? images,
      double? rentPrice,
      double? sellPrice}) async {
    final List<Map<String, dynamic>> type = [];
    if (rentPrice != null) {
      type.add({"type": "Rent", "price": rentPrice});
    }
    if (sellPrice != null) {
      type.add({"type": "Sell", "price": sellPrice});
    }
    final response = await _api.put(path: '/house/createHouse', body: {
      "displayName": displayName,
      "description": description,
      "projectId": projectId,
      "projectName": projectName,
      "projectStatus": projectStatus,
      "contactInfo": contactInfo,
      "projectThumbNailUrl": projectThumbNailUrl,
      "projectDescription": projectDescription,
      "province": province,
      "district": district,
      "wards": wards,
      "area": area,
      "street": street,
      "addressDescription": addressDescription,
      "thumbNailUrl": thumbNailUrl,
      "numKitchen": numKitchen,
      "numBathroom": numBathroom,
      "numToilet": numToilet,
      "numLivingRoom": numLivingRoom,
      "numBedRoom": numBedRoom,
      "images": images,
      "type": type
    });
    return HouseResponseModel.fromJson(response.data);
  }
}
