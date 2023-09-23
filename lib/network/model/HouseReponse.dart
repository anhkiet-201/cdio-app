import 'package:cdio/network/model/UserModel.dart';

import 'ProjectRresponseModel.dart';

class HouseResponse {
  int? houseId;
  String? displayName;
  String? description;
  Address? address;
  User? account;
  ProjectResponse? project;
  Info? info;
  int? createTime;
  bool? isOwner;
  bool? isFavorite;

  HouseResponse(
      {this.houseId,
        this.displayName,
        this.description,
        this.address,
        this.account,
        this.project,
        this.info,
        this.createTime,
        this.isOwner,
        this.isFavorite});

  HouseResponse.fromJson(Map<String, dynamic> json) {
    houseId = json['houseId'];
    displayName = json['displayName'];
    description = json['description'];
    address =
    json['address'] != null ? Address.fromJson(json['address']) : null;
    account =
    json['account'] != null ? User.fromJson(json['account']) : null;
    project =
    json['project'] != null ? ProjectResponse.fromJson(json['project']) : null;
    info = json['info'] != null ? Info.fromJson(json['info']) : null;
    createTime = json['createTime'];
    isOwner = json['isOwner'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['houseId'] = houseId;
    data['displayName'] = displayName;
    data['description'] = description;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (account != null) {
      data['account'] = account!.toJson();
    }
    if (project != null) {
      data['project'] = project!.toJson();
    }
    if (info != null) {
      data['info'] = info!.toJson();
    }
    data['createTime'] = createTime;
    data['isOwner'] = isOwner;
    data['isFavorite'] = isFavorite;
    return data;
  }
}

class Address {
  String? province;
  String? district;
  String? wards;
  String? street;
  String? description;

  Address(
      {this.province,
        this.district,
        this.wards,
        this.street,
        this.description});

  Address.fromJson(Map<String, dynamic> json) {
    province = json['province'];
    district = json['district'];
    wards = json['wards'];
    street = json['street'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['province'] = province;
    data['district'] = district;
    data['wards'] = wards;
    data['street'] = street;
    data['description'] = description;
    return data;
  }

  @override
  String toString() => '${street ?? ''},${wards ?? ''},${district ?? ''},${province ?? ''}.';
}

class Info {
  String? thumbNailUrl;
  int? numKitchen;
  int? numBathroom;
  int? numToilet;
  int? numLivingRoom;
  int? numBedRoom;
  List<HouseImage>? houseImage;
  List<HouseTypeDetailHouseTypes>? houseTypeDetailHouseTypes;

  Info(
      {this.thumbNailUrl,
        this.numKitchen,
        this.numBathroom,
        this.numToilet,
        this.numLivingRoom,
        this.numBedRoom,
        this.houseImage,
        this.houseTypeDetailHouseTypes});

  Info.fromJson(Map<String, dynamic> json) {
    thumbNailUrl = json['thumbNailUrl'];
    numKitchen = json['numKitchen'];
    numBathroom = json['numBathroom'];
    numToilet = json['numToilet'];
    numLivingRoom = json['numLivingRoom'];
    numBedRoom = json['numBedRoom'];
    if (json['houseImage'] != null) {
      houseImage = <HouseImage>[];
      json['houseImage'].forEach((v) {
        houseImage!.add(HouseImage.fromJson(v));
      });
    }
    if (json['houseTypeDetailHouseTypes'] != null) {
      houseTypeDetailHouseTypes = <HouseTypeDetailHouseTypes>[];
      json['houseTypeDetailHouseTypes'].forEach((v) {
        houseTypeDetailHouseTypes!
            .add(HouseTypeDetailHouseTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['thumbNailUrl'] = thumbNailUrl;
    data['numKitchen'] = numKitchen;
    data['numBathroom'] = numBathroom;
    data['numToilet'] = numToilet;
    data['numLivingRoom'] = numLivingRoom;
    data['numBedRoom'] = numBedRoom;
    if (houseImage != null) {
      data['houseImage'] = houseImage!.map((v) => v.toJson()).toList();
    }
    if (houseTypeDetailHouseTypes != null) {
      data['houseTypeDetailHouseTypes'] =
          houseTypeDetailHouseTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HouseImage {
  String? imageUrl;

  HouseImage({this.imageUrl});

  HouseImage.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageUrl'] = imageUrl;
    return data;
  }
}

class HouseTypeDetailHouseTypes {
  String? typeName;
  double? price;

  HouseTypeDetailHouseTypes({this.typeName, this.price});

  HouseTypeDetailHouseTypes.fromJson(Map<String, dynamic> json) {
    typeName = json['typeName'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['typeName'] = typeName;
    data['price'] = price;
    return data;
  }
}