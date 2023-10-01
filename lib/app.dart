import 'package:cdio/scene/home/HomeView.dart';
import 'package:cdio/scene/login/LoginView.dart';
import 'package:cdio/utils/present.dart';
import 'package:cdio/utils/shared/Shared.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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