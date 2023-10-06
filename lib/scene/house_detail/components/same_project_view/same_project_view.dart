import 'package:cdio/component/HouseHorizontalListView.dart';
import 'package:cdio/network/services/HouseService.dart';
import 'package:cdio/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../../../component/CustomImage.dart';
import '../../../../network/model/HouseReponse.dart';
import '../../../../widget/scrollview/scrollview.dart';
import '../../HouseDetail.dart';

part 'viewmodel.dart';

class SameProjectView extends StatelessWidget {
  const SameProjectView(this.id, {super.key});

  final int? id;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(id, context),
      child: const _View(),
    );
  }
}

class _View extends StatefulWidget {
  const _View({super.key});

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  late _ViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<_ViewModel>(context);
    return Visibility(
      visible: _viewModel.houses.isNotEmpty && !_viewModel.isLoading,
        child: HouseHorizontalListView(
            house: _viewModel.houses,
            title: 'Căn hộ cùng dự án',
            isLoading: _viewModel.isLoading
        )
    );
  }
}
