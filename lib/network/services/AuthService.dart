import 'package:cdio/network/model/AuthResponseModel.dart';

import '../api/BaseApi.dart';

class AuthService {
  static final shared = AuthService();
  final _api = BaseApi.shared;

  Future<AuthResponse> login({required String email, required String password}) async {
     final response = await _api.post(
          path: '/login',
          body: {
              "email": email,
              "password": password
          }
      );
     return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> register({required String email, required String password, required String name}) async {
    final response = await _api.post(
        path: '/register',
        body: {
          "email": email,
          "password": password,
          "username": name
        }
    );
    return AuthResponse.fromJson(response.data);
  }

}