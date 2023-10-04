part of 'same_project_view.dart';

class _ViewModel with ChangeNotifier {
  final int? id;
  final BuildContext context;
  final HouseService _houseService = HouseService.shared;

  _ViewModel(this.id, this.context) {
    _fetch();
  }

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  var houses = <HouseResponse>[];

  _fetch() async {
    if(id == null) return;
    isLoading = true;
    _houseService.getHouseSameProject(id: 10).then((value) {
      houses = value;
    }).catchError(() {
      context.showSnackBar(SnackBarType.error);
    })
    .whenComplete(() => isLoading = false);
  }
}
