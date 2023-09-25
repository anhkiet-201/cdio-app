import 'package:cdio/network/model/HouseReponse.dart';
import 'package:cdio/network/model/NewsResponseModel.dart';
import 'package:cdio/network/model/ProjectRresponseModel.dart';
import 'package:cdio/network/services/HomeService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
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

class __ViewState extends State<_View> {
  late _ViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<_ViewModel>(context);
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
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
        _content()
      ],
    );
  }
}

extension on __ViewState {
  Widget spacer() => const SizedBox(
        height: 20,
      );

  SliverToBoxAdapter _content() {
    return SliverToBoxAdapter(
      child: Padding(
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
            top: MediaQuery.of(context).padding.top,
            left: 20,
            right: 20),
        child: Center(
          child: Row(
            children: [
              Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(15))),
                    child: TextFormField(
                      maxLines: 1,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type something',
                          prefixIcon: Icon(Icons.search)),
                      textInputAction: TextInputAction.search,
                    ),
                  )
              ),
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
            child: Skeletonizer(
              enabled: _viewModel.isLoading,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _viewModel.isLoading ? _calculatedItemLoadingNum(275) : _viewModel.houses.length,
                itemBuilder: (_, index) {
                  return _homeListViewItem(index);
                },
              ),
            ),
          )
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
              itemCount: 10,
              itemBuilder: (_, index) {
                return Container(
                  margin: EdgeInsets.only(right: index < 9 ? 10 : 0),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Image.network(
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
                              const Text(
                                'Khu dân cư 8315 Đông Tân',
                                style: TextStyle(color: Colors.black),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Text(
                                'Dự án Khu dân cư 8315 Đông Tân (Mặt bằng 8315 Đông Tân hay MBQH 8315) là khu đất nền đấu giá tại phường Đông Tân, TP. Thanh Hóa, tỉnh Thanh Hóa. Dự án có quy mô hơn 8000m2, gồm 100 lô đất nền liền kề với diện tích từ 80m2.\n\n\nVị trí\nVị trí dự án Khu dân cư 8315 Đông Tân nằm trên đường Đại lộ Đông Tây, thuộc địa phận phường Đông Tân, phía Tây TP. Thanh Hóa, cách trung tâm thành phố khoảng 4km. Từ dự án Khu dân cư 8315 Đông Tân đi đến các khu vực, tiện ích lân cận đều thuận tiện nhờ các tuyến giao thông chính như Đại lộ Đông Tây, Quốc lộ 47, đường vành đai phía Tây, cao tốc Bắc-Nam,…\n\nCác mặt tiếp giáp với mặt bằng 8315 Đông Tân:\n\nPhía Bắc: Giáp Đại lộ Đông Tây\nPhía Nam: Giáp cây xanh và đất giáo dục\nPhía Đông: Giáp đường Trần Hưng Đạo\nPhía Tây: Giáp cây xanh và khu dân cư mới\n\nVị trí dự án Khu dân cư 8315 Đông Tân - TP. Thanh Hóa\nKhoảng cách từ Khu dân cư 8315 phường Đông Tân đến các địa điểm, tiện ích nổi bật của khu vực lân cận:\n\n100m đến khu đô thị mới TT Rừng Thông, MB Đồng Vèn\n200m đến trung tâm hành chính huyện Đông Sơn\n300m đường vành đai phía Tây\n500m dến KDC Minh Tuấn,  chợ đầu mối\nTrong bán kính 2km là bệnh viện đa khoa huyện, trường cấp 3 Đông Sơn I, bệnh viện đa khoa Phúc Thịnh, các mặt bằng Đại đô thị Đông Sơn (1879, 767, 258, 3220, 2652….)\n3km đến cao tốc Bắc Nam\n4km đến bưu điện tỉnh Thanh Hóa\n28km đến sân bay Thọ Xuân\nTiện ích\nDự án đất nền MB 8315 Đông Tân được quy hoạch đồng bộ với các tiện ích đi kèm như:\n\nCông viên cây xanh\nNhà văn hoá\nKhu liên hợp thể dục thể thao\nHạ tầng giao thông được chỉnh trang hiện đại với các trục đường rộng, thoáng\nMặt bằng 8315 Đông Tân nằm dọc theo đường Đại lộ Đông Tây kết nối TP. Thanh Hoá với trung tâm huyện Đông Sơn, lòng đường rộng từ 7,5 – 15m giúp việc lưu thông cho các phương tiện được nhanh chóng, thuận lợi.\n\nMặt bằng - Thiết kế\nMặt bằng 8315 Đông Tân – Tp Thanh Hoá được chia làm 6 khu (A,B,C,D,E,F) với 212 lô. Đơt đấu giá 6/6 sẽ đấu giá 100 lô thuộc các phân khu A,B,C,D. Thông tin cụ thể như sau:\n\nKhu A: gồm 22 lô từ A01 – A22\n\nA01 – A11 thuộc mặt trong, diện tích 80m2 (5×16), hướng Nam, đường 7,5m, vỉa hè 3m\nA12 – A22 mặt đường đôi, diện tích 80m2 (5×16), hướng Bắc, mặt đường đại lộ Đông Tây\nKhu B: gồm 22 lô từ B01 – B22\n\nB01 – B08 thuộc mặt trong, diện tích 80m2 (5×16), hướng Nam, đường 7,5m, vỉa hè 3m\nB09 – B11 thuộc trục giữa, diện tích 85 – 97,5m2, hướng Đông, đường 7,5, vỉa hè 5m\nB12 – B22 mặt đường đại lộ Đông Tây, diện tích 80 – 107m2, hướng Bắc.\nKhu C: gồm 46 lô từ C01 – C46\n\nC01 – C23 mặt đường đại lộ Đông Tây, diện tích 80 – 107m2, hướng Bắc.\nC24 – C43 thuộc mặt trong, diện tích 80m2 (5×16), hướng Nam, đường 7,5m, vỉa hè 3m\nC44 – C46 thuộc trục giữa, diện tích 85 – 97,5m2, hướng Đông, đường 7,5, vỉa hè 5m\nKhu D: gồm 10 lô từ D01 – D10\n\nD01 – D10 mặt đường đại lộ Đông Tây, diện tích 79 – 92m2, hướng Bắc.',
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 10),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.7),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: const Text(
                                  '# Đại Lộ Đông Tây, Đông Tân, Thanh Hóa',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Container _homeListViewItem(int index) {
    final HouseResponse house;
    if(!_viewModel.isLoading) {
      house = _viewModel.houses[index];
    } else {
      house = HouseResponse(
        displayName: 'cdio cdio cdio cdio cdio',
        description: 'cdio cdio cdio cdio cdio',
        info: Info(
          thumbNailUrl: 'https://danhkhoireal.vn/wp-content/uploads/2020/05/C%C3%B4ng-ty-C%E1%BB%95-ph%E1%BA%A7n-Kinh-doanh-B%E1%BA%A5t-%C4%91%E1%BB%99ng-s%E1%BA%A3n-S-Vin-Vi%E1%BB%87t-Nam.jpg'
        ),
        address: Address(
          street: 'cdio cdio cdio cdio',
          wards: 'cdio cdio cdio cdio',
          district: 'cdio',
          province: 'cdio'
        )
      );
    }
    return Container(
      margin: EdgeInsets.only(right: index < 9 ? 10 : 0),
      width: 275,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.network(
              house.info?.thumbNailUrl ?? '',
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
                    style: const TextStyle(
                        color: Colors.black87, fontSize: 10),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 2),
                    child: Text(
                      '# ${house.address?.toString()}',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
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
    );
  }
}

extension on __ViewState {
  int _calculatedItemLoadingNum(double width) {
    return MediaQuery.of(context).size.width ~/ width + 1;
  }
}

