import 'package:cdio/scene/NavView.dart';
import 'package:cdio/widget/present/present_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'network/model/UserModel.dart';

class AppDelegate extends StatelessWidget {
  const AppDelegate(this.app, {super.key});
  final App app;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CDIO App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider.value(
        value: app,
        child: PresentWidget(
            controller: App.presentController,
            dismissDragLeftDrawer: true,
            dismissDragRightDrawer: true,
            child: const NavView()
        ),
      ),
    );
  }
}

class App with ChangeNotifier {
  /// Constructor
  App(User? initUser) {
    _user = initUser;
  }
  /// Share Properties
  static final presentController = PresentController();

  /// Share Properties

  /// Global state
  User? _user;

  User? get user => _user;

  set user(User? value) {
    _user = value;
    notifyListeners();
  }
}
