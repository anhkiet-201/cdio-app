class ErrorResponse {
  String? timestamp;
  int? status;
  String? error;
  String? path;

  ErrorResponse({this.timestamp, this.status, this.error, this.path});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    status = json['status'];
    error = json['error'];
    path = json['path'];
  }
}
