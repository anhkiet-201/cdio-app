part of 'PostManager.dart';

class _ViewModel with ChangeNotifier {
  final BuildContext context;
  final ManagerType type;
  _ViewModel(this.context, this.type);
  final _service = HouseService.shared;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<House> house = [];
  int _currentPage = 0;
  bool hasNextPage = false;
  bool isLoaded = false;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  fetch({
    bool clear = true
  }) async {

    switch(type) {
      case ManagerType.personal:
        await _fetchPersonal(clear: clear);
        return;
      case ManagerType.admin:
        await _fetchAll(clear: clear);
        return;
    }
  }

  _fetchAll({bool clear = true}) async {
    isLoading = true;
    await _service.getAll(
        index: _currentPage
    ).then((value) {
      hasNextPage = value.hasNextPage ?? false;
      if(clear) {
        house.clear();
      }
      house.addAll(value.items ?? []);
    }).onError((error, stackTrace){
      context.showSnackBar(SnackBarType.error);
    }).whenComplete((){
      isLoading = false;
      isLoaded = true;
    });
  }

  _fetchPersonal({bool clear = true}) async {
    isLoading = true;
    await _service.getPersonalHouse(
        index: _currentPage
    ).then((value) {
      hasNextPage = value.hasNextPage ?? false;
      if(clear) {
        house.clear();
      }
      house.addAll(value.items ?? []);
    }).onError((ErrorResponse error, stackTrace){
      context.showSnackBar(SnackBarType.error);
    }).whenComplete((){
      isLoading = false;
      isLoaded = true;
    });
  }

  Future<void> refresh() async {
    _currentPage = 0;
    isLoaded = false;
    await fetch(clear: true);
  }

  Future<void> loadMore() async {
    _currentPage += 1;
    await fetch(clear: false);
  }
}

enum ManagerType {
  personal,
  admin
}