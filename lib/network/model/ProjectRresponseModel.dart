class ProjectResponse {
  int? projectId;
  String? projectName;
  String? projectStatus;
  String? projectAddress;
  String? contactInfo;
  String? projectThumbNailUrl;
  String? projectDescription;

  ProjectResponse(
      {this.projectId,
        this.projectName,
        this.projectStatus,
        this.projectAddress,
        this.contactInfo,
        this.projectThumbNailUrl,
        this.projectDescription});

  ProjectResponse.fromJson(Map<String, dynamic> json) {
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
}