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
  var _previousSelected = 0;
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(keepPage: true);
    context.appState.addListener(_onAppStateChange);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    context.appState.dispose();
  }

  final pages = const [
    HomeView(),
    FavoriteView(),
    CreatePostView(),
    ProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
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
    _selectedTab = index;
    switch (index) {
      case 0:
        _controller.animateToPage(0,
            duration: const Duration(milliseconds: 300), curve: Curves.linear);
        setState(() {});
        return;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
    }
    if (context.appState.user == null) {
      present(
          view: Container(
            color: Colors.white,
            child: const LoginView(),
          ),
          onPresentHide: () {
            if (context.appState.user != null) {
              _controller.animateToPage(_selectedTab,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear);
              setState(() {
                _previousSelected = _selectedTab;
              });
            }
          });
    } else {
      _controller.animateToPage(_selectedTab,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
      setState(() {
        _previousSelected = _selectedTab;
      });
    }
  }

  _onAppStateChange() {
    if (context.appState.user.isNull) _onLogout();
  }

  _onLogout() {
    setState(() {
      _previousSelected = 0;
      _selectedTab = 0;
    });
    _controller.jumpToPage(0);
  }
}
