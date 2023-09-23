
import '../../utils/LocalStorageService.dart';

class User implements StorageObject {
  String? email;
  String? avatarUrl;
  String? fullName;
  int? birthday;
  String? phoneNumber;
  String? address;
  String? role;
  String? description;

  User(
      {this.email,
        this.avatarUrl,
        this.fullName,
        this.birthday,
        this.phoneNumber,
        this.address,
        this.role,
        this.description});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    avatarUrl = json['avatarUrl'];
    fullName = json['fullName'];
    birthday = json['birthday'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    role = json['role'];
    description = json['description'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['avatarUrl'] = avatarUrl;
    data['fullName'] = fullName;
    data['birthday'] = birthday;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['role'] = role;
    data['description'] = description;
    return data;
  }

  @override
  User fromJsonStorage(Map<String, dynamic> json) {
    return User.fromJson(json);
  }
}