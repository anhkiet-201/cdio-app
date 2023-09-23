import 'package:cdio/network/model/NewsResponseModel.dart';
import 'package:cdio/network/model/ProjectRresponseModel.dart';

import 'HouseReponse.dart';

class HomeResponse {
  bool? status;
  String? message;
  List<HouseResponse>? houseNewest;
  List<ProjectResponse>? projectNewest;
  List<NewsResponse>? newsNewest;

  HomeResponse(
      {this.status,
        this.message,
        this.houseNewest,
        this.projectNewest,
        this.newsNewest});

  HomeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['houseNewest'] != null) {
      houseNewest = <HouseResponse>[];
      json['houseNewest'].forEach((v) {
        houseNewest!.add(HouseResponse.fromJson(v));
      });
    }
    if (json['projectNewest'] != null) {
      projectNewest = <ProjectResponse>[];
      json['projectNewest'].forEach((v) {
        projectNewest!.add(ProjectResponse.fromJson(v));
      });
    }
    if (json['newsNewest'] != null) {
      newsNewest = <NewsResponse>[];
      json['newsNewest'].forEach((v) {
        newsNewest!.add(NewsResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (houseNewest != null) {
      data['houseNewest'] = houseNewest!.map((v) => v.toJson()).toList();
    }
    if (projectNewest != null) {
      data['projectNewest'] =
          projectNewest!.map((v) => v.toJson()).toList();
    }
    if (newsNewest != null) {
      data['newsNewest'] = newsNewest!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
