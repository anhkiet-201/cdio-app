import 'package:cdio/network/api/BaseApi.dart';
import 'package:cdio/network/model/HouseReponse.dart';
import 'package:cdio/network/model/PageableResponseModel.dart';
import 'package:cdio/network/model/ProjectRresponseModel.dart';

class ProjectService {
  static final shared = ProjectService();
  final _api = BaseApi.shared;

  Future<Pageable<Project>> getAllProject({
    int size = 10,
    int index = 0
  }) async {
    final response = await _api.get(
        path: '/project/getAll',
        params: {
          "size": size,
          "index": index
        }
    );
    return PageableResponseModel.fromJson(response.data).to(type: Project.new);
  }
}