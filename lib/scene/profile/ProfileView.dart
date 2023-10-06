import 'package:cdio/component/CustomButton.dart';
import 'package:cdio/component/CustomImage.dart';
import 'package:cdio/utils/extensions/context.dart';
import 'package:cdio/widget/scrollview/scrollview.dart';
import 'package:flutter/material.dart';
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
            _profile(),
            const SizedBox(height: 10,),
            CustomButton(text: 'Logout', onClick: () {
              context.appState.user = null;
            })
          ],
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
          )
        ],
      ),
    );
  }
}

