import 'package:cdio/component/CustomImage.dart';
import 'package:cdio/component/SkeletonListView.dart';
import 'package:cdio/utils/LocalStorageService.dart';
import 'package:cdio/utils/present.dart';
import 'package:cdio/utils/shared/Shared.dart';
import 'package:cdio/widget/present/present_widget.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

import 'app.dart';
import 'network/model/UserModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Shared.user = await LocalStorageService.shared
      .getObject(key: LocalStorageKey.user, type: User.new);
  runApp(const CDIOApp());
}

class CDIOApp extends StatelessWidget {
  const CDIOApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CDIO App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: PresentWidget(
          controller: presentController,
          dismissDragLeftDrawer: true,
          dismissDragRightDrawer: true,
          child: const App()
      ),
    );
  }
}
