part of 'FavoriteView.dart';

class _ViewModel with ChangeNotifier {
  _ViewModel(this.context);

  final BuildContext context;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final _service = UserService.shared;
  int _currentPage = 0;

  var isOptionsLoaded = false;
  List<House> house = [];
  bool hasNext = false;

  Future<void> fetch({
    bool sortByDesc = true,
    int size = 10,
    bool clear = true
  }) async {
    isLoading = true;
    await _service
        .getFavoriteHouse(
      index: _currentPage,
      size: size,
      sortByDesc: sortByDesc
    )
        .then((value) {
      if(clear) {
        house.clear();
      }
      house.addAll(value.items ?? []);
      hasNext = value.hasNextPage ?? false;
    }).catchError(() {
      context.showSnackBar(SnackBarType.error);
    }).whenComplete(() {
      isLoading = false;
    });
  }

  Future<void> refresh() async {
    _currentPage = 0;
    await fetch();
  }

  Future<void> loadMore() async {
    _currentPage += 1;
    await fetch(clear: false);
  }
}