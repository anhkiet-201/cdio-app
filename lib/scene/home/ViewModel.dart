part of 'HomeView.dart';

class _ViewModel with ChangeNotifier {
  _ViewModel() {
    fetch();
  }

  final _service = HomeService.shared;

  var _isLoading = false;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  bool get isLoading => _isLoading;

  var _isError = true;
  set isError(bool value) {
    _isError = value;
    isLoading = false;
  }
  bool get isError => _isError;
  String? error;

  var houses = <HouseResponse>[];
  var projects = <ProjectResponse>[];
  var news = <NewsResponse>[];

  Future<void> fetch() async {
    isLoading = true;
     _service.fetchData()
        .then((value) {
          houses = value.houseNewest ?? [];
          projects = value.projectNewest ?? [];
          news = value.newsNewest ?? [];
          if (kDebugMode) {
            print('Fetch home data ${value.status}');
          }
          isLoading = false;
        })
        .onError((error, stackTrace) {
          isError = true;
          debugPrintStack(stackTrace: stackTrace, label: 'Home fetch error');
        });
  }
}

