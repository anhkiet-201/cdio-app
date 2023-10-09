import 'dart:async';
import 'dart:convert';

import 'package:cdio/network/model/BaseResponseModel.dart';
import 'package:cdio/network/model/ErrorResponseModel.dart';
import 'package:cdio/utils/LocalStorageService.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BaseApi {
  static final shared = BaseApi();
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  BaseApi();

  final String _baseUrl =
      'http://ec2-18-141-25-99.ap-southeast-1.compute.amazonaws.com:8080/api';

  Future<BaseResponse> get(
      {required String path, Map<String, dynamic>? params}) async {
    final jwt = LocalStorageService.jwt;
    if (jwt != null) {
      _headers.addEntries([MapEntry('Authorization', jwt)]);
    }
    final response = await http.get(
        Uri.parse('$_baseUrl$path${_paramsConvert(params)}'),
        headers: _headers);
    if (response.statusCode >= 400) {
      throw Exception(
          ErrorResponse.fromJson(_utf8JsonDecode(response.bodyBytes)));
    }
    return BaseResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  Future<BaseResponse> post({required String path, Object? body, Object? rawBody}) async {
    final jwt = LocalStorageService.jwt;
    if (jwt != null) {
      _headers.addEntries([MapEntry('Authorization', jwt)]);
    }
    final response = await http.post(Uri.parse('$_baseUrl$path'),
        body: rawBody ?? (body != null ? jsonEncode(body) : body), headers: _headers);
    if (response.statusCode >= 400) {
      throw (ErrorResponse.fromJson(_utf8JsonDecode(response.bodyBytes))
              .error ??
          'Error');
    }
    return BaseResponse.fromJson(_utf8JsonDecode(response.bodyBytes));
  }

  Future<BaseResponse> put({required String path, Object? body, Object? rawBody}) async {
    final jwt = LocalStorageService.jwt;
    if (jwt != null) {
      _headers.addEntries([MapEntry('Authorization', jwt)]);
    }
    final response = await http.put(Uri.parse('$_baseUrl$path'),
        body: rawBody ?? (body != null ? jsonEncode(body) : body), headers: _headers);
    if (response.statusCode >= 400) {
      throw (ErrorResponse.fromJson(_utf8JsonDecode(response.bodyBytes))
          .error ??
          'Error');
    }
    return BaseResponse.fromJson(_utf8JsonDecode(response.bodyBytes));
  }

  Future<BaseResponse> delete({required String path, Object? body, Object? rawBody}) async {
    final jwt = LocalStorageService.jwt;
    if (jwt != null) {
      _headers.addEntries([MapEntry('Authorization', jwt)]);
    }
    final response = await http.delete(Uri.parse('$_baseUrl$path'),
        body: rawBody ?? (body != null ? jsonEncode(body) : body), headers: _headers);
    if (response.statusCode >= 400) {
      throw (ErrorResponse.fromJson(_utf8JsonDecode(response.bodyBytes))
              .error ??
          'Error');
    }
    return BaseResponse.fromJson(_utf8JsonDecode(response.bodyBytes));
  }

  dynamic _utf8JsonDecode(Uint8List value) => jsonDecode(utf8.decode(value));

  String _paramsConvert(Map<String, dynamic>? params) {
    final paramsList = <String>[];
    params?.forEach((key, value) {
      paramsList.add('$key=$value');
    });
    return paramsList.isEmpty ? '' : '?${paramsList.join('&')}';
  }
}
