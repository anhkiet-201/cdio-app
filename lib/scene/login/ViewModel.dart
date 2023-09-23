part of './LoginView.dart';

class _ViewModel with ChangeNotifier {
  final _authService = AuthService.shared;
  final _localStorage = LocalStorageService.shared;
  var _isLoading = false;
  var _isError = false;
  User? _user;

  set user(User? user) {
    Shared.user = _user = user;
    notifyListeners();
  }
  User? get user => _user;

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
  bool get isLoading => _isLoading;

  set isError(bool isError) {
    _isError = isError;
    notifyListeners();
  }
  bool get isError => _isError;

  login({required String email, required String password}) async {
    isLoading = true;
    _authService.login(email: email, password: password)
      .then((value) {
        user = value.user;
        Future.wait([
          _localStorage.saveValue(key: LocalStorageKey.jwtKey, value: value.token),
          _localStorage.saveObject(key: LocalStorageKey.user, object: user)
        ]).then((value) => presentController.hidePresent());
      })
      .onError((ErrorResponse error, stackTrace) {
        print(error.error);
      })
      .whenComplete(() {
        isLoading = false;
      });
  }
}