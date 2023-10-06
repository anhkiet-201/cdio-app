import 'package:cdio/component/FilterBar.dart';
import 'package:cdio/component/HouseVerticalListView.dart';
import 'package:cdio/network/model/HouseReponse.dart';
import 'package:cdio/network/services/QueryServices.dart';
import 'package:cdio/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
part 'ViewModel.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({super.key, this.keyword});
  final String? keyword;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _ViewModel(context)..searchWithOptions(key: keyword),
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
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<_ViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _searchBar(),
              _filter(),
              Expanded(
                child: HouseVerticalListView(
                  _viewModel.house,
                  isLoading: _viewModel.isLoading && !_viewModel.isLoaded,
                  hasNext: _viewModel.hasNext,
                  onLoadMore: () async {
                    _viewModel.loadMore()
                        .then((value){
                          setState(() {

                          });
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

extension on _ViewState {
  Widget _searchBar() {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: TextFormField(
                  initialValue: _viewModel.key,
                  maxLines: 1,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type something',
                      prefixIcon: Icon(Icons.search)),
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (value) {
                    _viewModel.searchWithOptions(key: value);
                  },
                ),
              )),
        ],
      ),
    );
  }

  Widget _filter() => _viewModel.isLoading && !_viewModel.isLoaded ? _filterSkeleton() : FilterBar(
      options: _viewModel.options,
      onFilterChange: (value) {
        setState(() {
          _viewModel.options = value;
        });
      },
    onSheetClose: () {
        _viewModel.searchWithOptions();
    },
  );

  Widget _filterSkeleton() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      height: 35,
      color: Colors.white,
      width: MediaQuery.of(context).size.width - 16,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (_, __) {
          return Padding(
            padding: const EdgeInsets.only(right: 5),
            child: SkeletonAvatar(
              style: SkeletonAvatarStyle(
                width: 150,
                borderRadius: BorderRadius.circular(50)
              ),
            ),
          );
        },
      ),
    );
  }
}
