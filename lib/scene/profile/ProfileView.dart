import 'package:cdio/component/CustomButton.dart';
import 'package:cdio/component/CustomImage.dart';
import 'package:cdio/network/model/UserModel.dart';
import 'package:cdio/scene/post_manager/PostManager.dart';
import 'package:cdio/utils/LocalStorageService.dart';
import 'package:cdio/utils/extensions/context.dart';
import 'package:cdio/utils/snack_bar.dart';
import 'package:cdio/widget/scrollview/scrollview.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../app.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  App? _app;

  @override
  Widget build(BuildContext context) {
    _app = Provider.of<App>(context);
    return Scaffold(
      body: BaseScrollView.single(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: MediaQuery.of(context).padding.top
        ),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            _profile(),
            const SizedBox(height: 10,),
            _button(icon: Iconsax.note_1, label: 'Bài đăng', action: (){
              Navigator.maybeOf(context)?.push(
                MaterialPageRoute(builder: (_) => const PostManager(type: ManagerType.personal,))
              );
            }),
            if((context.appState.user?.role ?? '') == 'admin')
              _button(icon: Iconsax.note_1, label: 'Quản lý admin', action: (){}),
            const SizedBox(height: 10,),
            CustomButton(text: 'Logout', onClick: () {
              _logout();
            })
          ],
        ),
      ),
    );
  }

  Ink _button({
    required IconData icon,
    required String label,
    required Function() action
}) {
    return Ink(
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: action,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(icon),
                    const SizedBox(width: 10,),
                    Text(
                        label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                      ),
                    ),
                    const Spacer(),
                    const Icon(Iconsax.arrow_circle_right)
                  ],
                ),
              ),
            ),
          );
  }

  @override
  void initState() {
    super.initState();
  }

}

extension on _ProfileViewState {
  Widget _profile() {
    final user = _app?.user;
    return SizedBox(
      child: Row(
        children: [
          CDImage(
            url: user?.avatarUrl,
            width: 75,
            height: 75,
            radius: 50,
          ),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.fullName ?? 'name',
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25
                ),
              ),
              const Text('Xem trang cá nhân')
            ],
          ),
        ],
      ),
    );
  }
}

extension on _ProfileViewState {
  _logout() async {
    await Future.wait(
      [
        LocalStorageService.shared.dropValue(key: LocalStorageKey.jwtKey),
        LocalStorageService.shared.dropValue(key: LocalStorageKey.user),
      ]
    ).then((value) async {
      LocalStorageService.jwt = null;
      context.showCustomSnackBar('Đã đăng xuất!');
      context.appState.user = null;
    });
  }
}

