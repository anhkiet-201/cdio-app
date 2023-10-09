import 'package:cdio/component/CustomImage.dart';
import 'package:cdio/network/model/ErrorResponseModel.dart';
import 'package:cdio/network/model/HouseReponse.dart';
import 'package:cdio/network/services/HouseService.dart';
import 'package:cdio/scene/post_manager/item/HouseManagerItem.dart';
import 'package:cdio/utils/snack_bar.dart';
import 'package:cdio/utils/utils.dart';
import 'package:cdio/widget/scrollview/scrollview.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
part 'ViewModel.dart';

class PostManager extends StatelessWidget {
  const PostManager({super.key, this.type = ManagerType.personal});
  final ManagerType type;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _ViewModel(context, type)..fetch(),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài đăng'),
      ),
      body: BaseScrollView(
        itemCount: viewModel.house.length,
        isLoading: viewModel.isLoading && !viewModel.isLoaded,
        isEmpty: viewModel.house.isEmpty && !viewModel.isLoading,
        hasNext: viewModel.hasNextPage,
        onLoadMore: viewModel.loadMore,
        onRefresh: viewModel.refresh,
        itemBuilder: (_, index) {
          final house = viewModel.house[index];
          return HouseManagerItem(house);
        },
        loadingBuilder: (_, __) => _skeleton(),
      ),
    );
  }

  Widget _skeleton() {
    return const SizedBox(
      height: 120,
      child: Row(
        children: [
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: 120,
              height: 120
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                    ''
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  SizedBox _item(House house) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Row(
        children: [
          CDImage(
            url: house.info?.thumbNailUrl,
            width: 100,
            height: 100,
            radius: 0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${house.displayName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      CDImage(
                        url: house.account?.avatarUrl,
                        width: 20,
                        height: 20,
                        radius: 10,
                      ),
                      const SizedBox(width: 5,),
                      Text(
                        '${house.account?.fullName}',
                        style: const TextStyle(
                          fontSize: 10
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(house.info?.houseTypeDetailHouseTypes != null)
                            for(final type in house.info!.houseTypeDetailHouseTypes!)
                              Text('Giá ${type.typeName == 'Rent' ? 'thuê' : 'bán'}: ${priceFormat(type.price)}', style: const TextStyle( fontSize: 12),)
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        timeAgo(house.createTime),
                        style: const TextStyle(
                            color: Colors.grey
                        ),
                      ),
                      const Spacer(),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(width: 10,),
          Column(
            children: [
              IconButton(onPressed: (){}, icon: const Icon(Iconsax.trash, size: 20,)),
              const Spacer(),
              IconButton(onPressed: (){}, icon: const Icon(Iconsax.edit, size: 20,)),
            ],
          )
        ],
      ),
    );
  }
}


