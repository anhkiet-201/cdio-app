import 'package:flutter/material.dart';

import '../app.dart';

void present({required Widget view, Function? callbackViewHide, Function? onPresentHide}) {
  App.presentController.showPresent(view: view, callbackViewHide: callbackViewHide, onPresentHide: onPresentHide);
}

void dismiss({bool clear = false}) => App.presentController.hidePresent(clear: clear);