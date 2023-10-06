part of 'RegisterView.dart';

class _ViewModel with ChangeNotifier {
  _ViewModel(this.context);
  final BuildContext context;
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

  register({required String email, required String password}) async {
    isLoading = true;
    _authService.register(email: email, password: password)
        .then((value) async {
      if(!(value.status ?? false)) {
        context.showCustomSnackBar(value.message);
        return;
      }
      user = value.user;
      await Future.wait([
        _localStorage.saveValue(key: LocalStorageKey.jwtKey, value: value.token),
        _localStorage.saveObject(key: LocalStorageKey.user, object: user)
      ]).then((value) {
        context.showCustomSnackBar('Đã đăng nhập với ${user?.email ?? ''}');
        dismiss(clear: true);
      });
    }).onError((ErrorResponse error, stackTrace) {
      context.showCustomSnackBar(error.error);
    }).whenComplete(() {
      isLoading = false;
    });
  }
}
