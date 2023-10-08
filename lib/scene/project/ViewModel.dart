part of 'ProjectView.dart';

class _ViewModel with ChangeNotifier {
  _ViewModel(this.context);
  final BuildContext context;
  final _service = QueryService.shared;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<House> house = [];

  fetch(String? name) async {
    isLoading = true;
    _service.search(key: '', projectName: name)
    .then((value){
      house.addAll(value.items ?? []);
    })
    .onError((error, stackTrace) => context.showSnackBar(SnackBarType.error))
    .whenComplete(() => isLoading = false);
  }
}