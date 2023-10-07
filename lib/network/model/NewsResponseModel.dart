import 'package:cdio/network/model/UserModel.dart';

class News {
  String? title;
  String? content;
  User? account;
  int? createTime;

  News({this.title, this.content, this.account, this.createTime});

  News.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    account =
    json['account'] != null ? User.fromJson(json['account']) : null;
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['content'] = content;
    if (account != null) {
      data['account'] = account!.toJson();
    }
    data['createTime'] = createTime;
    return data;
  }
}