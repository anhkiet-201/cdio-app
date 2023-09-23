import 'UserResponseModel.dart';

class BaseResponse {
  int? timestamp;
  int? statusCode;
  String? statusDescription;
  Map<String, dynamic> data;

  BaseResponse(
      {this.timestamp, this.statusCode, this.statusDescription, required this.data});

  BaseResponse.fromJson(Map<String, dynamic> json) : this(
      timestamp: json['timestamp'],
      statusCode: json['status_code'],
      statusDescription: json['status_description'],
      data: json['data']
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timestamp'] = timestamp;
    data['status_code'] = statusCode;
    data['status_description'] = statusDescription;
    data['data'] = this.data;
    return data;
  }
}
