part of 'RegisterView.dart';

class _ViewModel with ChangeNotifier {
  _ViewModel(this.context);
  final BuildContext context;
  final _authService = AuthService.shared;
  final _localStorage = LocalStorageService.shared;
  var _isLoading = false;
  var _isError = false;

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

  register({required String email, required String password, required String name}) async {
    if(name.isEmpty) {
      context.showCustomSnackBar('Tên người dùng không được trống!');
      return;
    }
    if(!isValidEmail(email)) {
      context.showCustomSnackBar('Vui lòng nhập đúng định dạng email!');
      return;
    }
    if(password.length < 8) {
      context.showCustomSnackBar('Mật khẩu tối thiểu 8 ký tự');
      return;
    }
    isLoading = true;
    _authService.register(email: email, password: password, name: name)
        .then((value) async {
      if(!(value.status ?? false)) {
        context.showCustomSnackBar(value.message);
        return;
      }
      context.appState.user = value.user;
      await Future.wait([
        _localStorage.saveValue(key: LocalStorageKey.jwtKey, value: value.token),
        _localStorage.saveObject(key: LocalStorageKey.user, object: context.appState.user)
      ]).then((_) {
        LocalStorageService.jwt = value.token;
        context.showCustomSnackBar('Đã đăng nhập với ${context.appState.user?.email ?? ''}');
        dismiss(clear: true);
      });
    }).onError((ErrorResponse error, stackTrace) {
      context.showCustomSnackBar(error.error);
    }).whenComplete(() {
      isLoading = false;
    });
  }
}

