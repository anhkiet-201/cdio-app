import 'package:cdio/network/model/BaseData.dart';

class Project extends BaseData {
  int? projectId;
  String? projectName;
  String? projectStatus;
  String? projectAddress;
  String? contactInfo;
  String? projectThumbNailUrl;
  String? projectDescription;

  Project(
      {this.projectId,
        this.projectName,
        this.projectStatus,
        this.projectAddress,
        this.contactInfo,
        this.projectThumbNailUrl,
        this.projectDescription});

  Project.fromJson(Map<String, dynamic> json) {
    projectId = json['projectId'];
    projectName = json['projectName'];
    projectStatus = json['projectStatus'];
    projectAddress = json['projectAddress'];
    contactInfo = json['contactInfo'];
    projectThumbNailUrl = json['projectThumbNailUrl'];
    projectDescription = json['projectDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['projectId'] = projectId;
    data['projectName'] = projectName;
    data['projectStatus'] = projectStatus;
    data['projectAddress'] = projectAddress;
    data['contactInfo'] = contactInfo;
    data['projectThumbNailUrl'] = projectThumbNailUrl;
    data['projectDescription'] = projectDescription;
    return data;
  }

  @override
  BaseData fromJsonBase(Map<String, dynamic> json) {
    // TODO: implement fromJsonBase
    return Project.fromJson(json);
  }
}