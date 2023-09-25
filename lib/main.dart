import 'package:cdio/scene/home/HomeView.dart';
import 'package:cdio/scene/login/LoginView.dart';
import 'package:cdio/utils/LocalStorageService.dart';
import 'package:cdio/utils/present.dart';
import 'package:cdio/utils/shared/Shared.dart';
import 'package:cdio/widget/present/present_widget.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'network/model/UserModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Shared.user = await LocalStorageService.shared
      .getObject(key: LocalStorageKey.user, type: User.new);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: PresentWidget(
          controller: presentController,
          dismissDragLeftDrawer: true,
          dismissDragRightDrawer: true,
          child: const _App()
      ),
    );
  }
}

class _App extends StatefulWidget {
  const _App({super.key});

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  var _selectedTab = 0;
  var _previousSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomeView(),
      bottomNavigationBar: bottomNavigation(),
    );
  }
}

extension on _AppState {
  Widget bottomNavigation() {
    return BottomNavigationBar(
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey.withOpacity(0.8),
      currentIndex: _selectedTab,
      onTap: (value) {
        _previousSelected = _selectedTab;
        setState(() {
          _selectedTab = value;
        });
        if ((_selectedTab > 0) && (Shared.user == null)) {
          present(
              view: Container(
                color: Colors.white,
                child: const LoginView(),
              ),
              onPresentHide: () {
                if (Shared.user == null) {
                  setState(() {
                    _selectedTab = _previousSelected;
                  });
                }
              }
          );
        } else {
          if (value == 2) {
            present(
                view: Container(
                  color: Colors.white,
                  child: ListView.builder(
                    primary: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_, index) => Container(
                            height: 100,
                            color: Colors.red,
                            child: Text('$index'),
                          )),
                ),
                onPresentHide: () {
                  setState(() {
                    _selectedTab = _previousSelected;
                  });
                });
          }
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Iconsax.heart), label: 'Favorite'),
        BottomNavigationBarItem(icon: Icon(Iconsax.edit), label: 'Post'),
        BottomNavigationBarItem(icon: Icon(Iconsax.profile_2user), label: 'Profile')
      ],
    );
  }
}
