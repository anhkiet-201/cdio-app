import 'package:cdio/app.dart';
import 'package:cdio/network/model/ErrorResponseModel.dart';
import 'package:cdio/network/services/AuthService.dart';
import 'package:cdio/utils/snack_bar.dart';
import 'package:cdio/utils/utils.dart';
import 'package:flutter/material.dart';

class UpdatePasswordViewModel with ChangeNotifier {
  final BuildContext context;
  UpdatePasswordViewModel(this.context);
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool status = false;

  final _service = AuthService.shared;

  Future<void> reset(String email) async {
    if(!isValidEmail(email)) {
      context.showCustomSnackBar('Vui lòng nhập đúng định dạng email!');
      return;
    }
    isLoading = true;
    App.presentController.dismissible = false;
    await _service.getTokenResetPassword(email: email)
    .then((value){
      if(!(value.status ?? false)) {
        context.showCustomSnackBar(value.message ?? '');
      }
      status = value.status ?? false;
    }).onError((ErrorResponse error, stackTrace) {
      context.showCustomSnackBar(error.error);
    })
    .whenComplete(() {
      isLoading = false;
      App.presentController.dismissible = true;
    });
  }
}