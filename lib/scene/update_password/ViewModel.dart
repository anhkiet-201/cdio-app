part of 'InputResetPin.dart';

class _ViewModel with ChangeNotifier {
  _ViewModel(this.context, this.email);
  final BuildContext context;
  final String email;
  final _authService = AuthService.shared;
  final _localStorage = LocalStorageService.shared;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  updatePassword({required String password, required String token}) async {
    if(password.length < 8) {
      context.showCustomSnackBar('Mật khẩu tối thiểu 8 ký tự');
      return;
    }
    isLoading = true;
    _authService.setNewPassword(email: email, password: password, token: token)
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
    })
        .whenComplete(() {
      isLoading = false;
    });
  }

}