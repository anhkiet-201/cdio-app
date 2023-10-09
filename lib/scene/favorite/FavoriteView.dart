import 'package:cdio/component/HouseVerticalListView.dart';
import 'package:cdio/network/model/HouseReponse.dart';
import 'package:cdio/network/services/UserService.dart';
import 'package:cdio/utils/extensions/context.dart';
import 'package:cdio/utils/extensions/object.dart';
import 'package:cdio/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'ViewModel.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _ViewModel(context)..fetch(),
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

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<_ViewModel>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: HouseVerticalListView(viewModel.house,
          isLoading: viewModel.isLoading,
          hasNext: viewModel.hasNext,
          onLoadMore: viewModel.loadMore,
        onRefresh: viewModel.refresh,
      ),
    );
  }
}
