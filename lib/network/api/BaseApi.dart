import 'dart:async';
import 'dart:convert';

import 'package:cdio/network/model/BaseResponseModel.dart';
import 'package:cdio/network/model/ErrorResponseModel.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BaseApi {
  static final shared = BaseApi();
  final String _baseUrl =
      'http://ec2-18-141-25-99.ap-southeast-1.compute.amazonaws.com:8080/api';
  Future<BaseResponse> get(
      {required String path, Map<String, dynamic>? params}) async {
    final response = await http.get(Uri.parse('$_baseUrl$path${_paramsConvert(params)}'));
    if(response.statusCode >= 400) throw Exception(ErrorResponse.fromJson(_utf8JsonDecode(response.bodyBytes)));
    return BaseResponse.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)));
  }

  Future<BaseResponse> post({required String path, Object? body}) async {
      final response = await http.post(
          Uri.parse('$_baseUrl$path'),
          body: body != null ? jsonEncode(body) : body,
          headers: {
            "Content-Type": "application/json"
          });
      if(response.statusCode >= 400) throw(ErrorResponse.fromJson(_utf8JsonDecode(response.bodyBytes)).error ?? 'Error') ;
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
