import 'package:cdio/scene/create_post/CreatePostView.dart';
import 'package:cdio/scene/favorite/FavoriteView.dart';
import 'package:cdio/scene/home/HomeView.dart';
import 'package:cdio/scene/login/LoginView.dart';
import 'package:cdio/scene/profile/ProfileView.dart';
import 'package:cdio/utils/extensions/context.dart';
import 'package:cdio/utils/extensions/object.dart';
import 'package:cdio/utils/present.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NavView extends StatefulWidget {
  const NavView({super.key});

  @override
  State<NavView> createState() => _NavViewState();
}

class _NavViewState extends State<NavView> {
  var _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    context.appState.addListener(_onAppStateChange);
  }

  final pages = const [
    HomeView(),
    FavoriteView(),
    SizedBox(),
    ProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedTab],
      bottomNavigationBar: bottomNavigation(),
    );
  }
}

extension on _NavViewState {
  Widget bottomNavigation() {
    return BottomNavigationBar(
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey.withOpacity(0.8),
      currentIndex: _selectedTab,
      onTap: _onTapNav,
      items: const [
        BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Iconsax.heart), label: 'Favorite'),
        BottomNavigationBarItem(icon: Icon(Iconsax.edit), label: 'Post'),
        BottomNavigationBarItem(
            icon: Icon(Iconsax.profile_2user), label: 'Profile')
      ],
    );
  }
}

extension on _NavViewState {
  _onTapNav(int index) {
    if(index > 0 && context.appState.user == null) {
      present(
          view: Container(
            color: Colors.white,
            child: const LoginView(),
          ));
      return;
    }
    if(index == 2) {
      present(view: const CreatePostView());
      return;
    }
    setState(() {
      _selectedTab = index;
    });
  }

  _onAppStateChange() {
    if (context.appState.user.isNull) _onLogout();
  }

  _onLogout() {
    setState(() {
      _selectedTab = 0;
    });
  }
}
