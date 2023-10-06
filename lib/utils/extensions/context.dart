import 'package:cdio/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

extension AppContext on BuildContext {
  App get appState => read<App>();
}