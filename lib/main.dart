import 'package:cdio/firebase_options.dart';
import 'package:cdio/utils/LocalStorageService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'network/model/UserModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var user = await LocalStorageService.shared
      .getObject(key: LocalStorageKey.user, type: User.new);
  await LocalStorageService.initJwt();
  runApp(AppDelegate(App(user)));
}