import 'package:cdio/widget/present/present_widget.dart';
import 'package:flutter/material.dart';

final PresentController presentController = PresentController();
void present({required Widget view, Function? callbackViewHide, Function? onPresentHide}) {
  presentController.showPresent(view: view, callbackViewHide: callbackViewHide, onPresentHide: onPresentHide);
}

void dismiss({bool clear = false}) => presentController.hidePresent(clear: clear);