import 'package:cdio/component/CustomImage.dart';
import 'package:cdio/network/model/HouseReponse.dart';
import 'package:cdio/network/model/NewsResponseModel.dart';
import 'package:cdio/network/model/ProjectRresponseModel.dart';
import 'package:cdio/network/services/HomeService.dart';
import 'package:cdio/scene/house_detail/HouseDetail.dart';
import 'package:cdio/widget/scrollview/scrollview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
part './ViewModel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const _View(),
    );
  }
}

class _View extends StatefulWidget {
  const _View({super.key});

  @override
  State<_View> createState() => __ViewState();
}

class __ViewState extends State<_View> with AutomaticKeepAliveClientMixin {
  late _ViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<_ViewModel>(context);
    return BaseScrollView.sliver(
        padding: EdgeInsets.zero,
        onRefresh: _viewModel.fetch,
        slivers: [
          SliverAppBar(
            expandedHeight: 270,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: banner(),
              ),
              collapseMode: CollapseMode.pin,
            ),
            floating: true,
          ),
          _searchBar(context),
        ],
        body: _content());
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

extension on __ViewState {
  Widget spacer() => const SizedBox(
        height: 20,
      );

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          homeNewest(),
          spacer(),
          projectNewest(),
          spacer(),
          projectNewest()
        ],
      ),
    );
  }

  SliverAppBar _searchBar(BuildContext context) {
    return SliverAppBar(
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      pinned: true,
      collapsedHeight: 75,
      flexibleSpace: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 20, right: 20),
        child: Center(
          child: Row(
            children: [
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: TextFormField(
                  maxLines: 1,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type something',
                      prefixIcon: Icon(Icons.search)),
                  textInputAction: TextInputAction.search,
                ),
              )),
            ],
          ),
        ),
      ),
      elevation: 0,
    );
  }

  Widget banner() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 250,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        child: Image.network(
          'https://danhkhoireal.vn/wp-content/uploads/2020/05/C%C3%B4ng-ty-C%E1%BB%95-ph%E1%BA%A7n-Kinh-doanh-B%E1%BA%A5t-%C4%91%E1%BB%99ng-s%E1%BA%A3n-S-Vin-Vi%E1%BB%87t-Nam.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget title(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );

  Widget homeNewest() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title('Home newsest'),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              height: 200,
              child: BaseScrollView.horizontal(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                isLoading: _viewModel.isLoading,
                itemCount: _viewModel.houses.length,
                spacing: 50,
                itemBuilder: (_, index) {
                  return _homeListViewItem(index);
                },
                loadingBuilder: (_, __) {
                  return SizedBox(
                    width: 275,
                    child: Column(
                      children: [
                        SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                              width: 260,
                              height: 100,
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        SkeletonParagraph(
                          style: const SkeletonParagraphStyle(
                              lineStyle: SkeletonLineStyle(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
                        )
                      ],
                    ),
                  );
                },
              ))
        ],
      ),
    );
  }

  Widget projectNewest() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title('Prject newsest'),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _viewModel.isLoading
                  ? _calculatedItemLoadingNum(275)
                  : _viewModel.projects.length,
              itemBuilder: (_, index) {
                return _projectListItem(index);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _homeListViewItem(int index) {
    final HouseResponse house;
    house = _viewModel.houses[index];
    return GestureDetector(
      onTap: () => Navigator.maybeOf(context)
          ?.push(MaterialPageRoute(builder: (_) => HouseDetail(house))),
      child: SizedBox(
        width: 275,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CDImage(
                url: house.info?.thumbNailUrl ?? '',
                fit: BoxFit.cover,
                height: 200,
                width: 275,
              ),
              Container(
                height: 90,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: Colors.white.withOpacity(0.9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      house.displayName ?? '',
                      style: const TextStyle(color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      house.description ?? '',
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 10),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      child: Text(
                        '# ${house.address?.toString()}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _projectListItem(int index) {
    final ProjectResponse project;
    if (!_viewModel.isLoading) {
      project = _viewModel.projects[index];
    } else {
      project = ProjectResponse(
          projectName: 'cdio cdio cdio cdio cdio cdio ',
          projectDescription: 'cdio cdio cdio cdio cdio cdio cdio cdio cdio ',
          projectStatus: 'cdio cdio cdio cdio ',
          projectThumbNailUrl:
              'https://file4.batdongsan.com.vn/2023/04/17/20230417230202-3438_wm.jpg');
    }
    return Container(
      margin: EdgeInsets.only(right: index < 9 ? 10 : 0),
      width: MediaQuery.of(context).size.width * 0.6,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.network(
              project.projectThumbNailUrl ??
                  'https://file4.batdongsan.com.vn/2023/04/17/20230417230202-3438_wm.jpg',
              fit: BoxFit.cover,
              height: 300,
            ),
            Container(
              height: 90,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.white.withOpacity(0.9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.projectName ?? '',
                    style: const TextStyle(color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    project.projectDescription ?? '',
                    style: const TextStyle(color: Colors.black87, fontSize: 10),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      'cdio',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

extension on __ViewState {
  int _calculatedItemLoadingNum(double width) {
    return MediaQuery.of(context).size.width ~/ width + 1;
  }
}
