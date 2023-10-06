import 'package:cdio/utils/LocalStorageService.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'network/model/UserModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var user = await LocalStorageService.shared
      .getObject(key: LocalStorageKey.user, type: User.new);
  await LocalStorageService.initJwt();
  runApp(AppDelegate(App(user)));
}