import 'package:cdio/component/CustomImage.dart';
import 'package:cdio/component/favorite_button/FavoriteButton.dart';
import 'package:cdio/network/model/HouseReponse.dart';
import 'package:cdio/scene/house_detail/HouseDetail.dart';
import 'package:cdio/utils/utils.dart';
import 'package:cdio/widget/scrollview/scrollview.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class HouseVerticalListView extends StatelessWidget {
  const HouseVerticalListView(this.house, {super.key, required this.isLoading, required this.hasNext, required this.onLoadMore, this.onRefresh});
  final List<House> house;
  final bool isLoading;
  final bool hasNext;
  final Function() onLoadMore;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return BaseScrollView(
      itemBuilder: (BuildContext context, int index) {
        return _item(context, index);
      },
      isLoading: isLoading,
      itemCount: house.length,
      onLoadMore: onLoadMore,
      loadingBuilder: (_, __) => const HouseVerticalSkeleton(),
      hasNext: hasNext,
      onRefresh: onRefresh,
    );
  }

  Widget _item(BuildContext context, int index) {
    final item = house[index];
    return GestureDetector(
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Row(
          children: [
            CDImage(
              url: item.info?.thumbNailUrl,
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
                      '${item.displayName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text('${item.info?.area} m2'),
                        const Spacer(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if(item.info?.houseTypeDetailHouseTypes != null)
                              for(final type in item.info!.houseTypeDetailHouseTypes!)
                                Text('Giá ${type.typeName == 'Rent' ? 'thuê' : 'bán'}: ${type.price} Vnđ', style: const TextStyle( fontSize: 12),)
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          timeAgo(item.createTime),
                          style: const TextStyle(
                              color: Colors.grey
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: FavoriteButton(item.houseId ?? -1),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.maybeOf(context)?.push(
          MaterialPageRoute(builder: (_) => HouseDetail(item))
        );
      },
    );
  }
}

class HouseVerticalSkeleton extends StatelessWidget {
  const HouseVerticalSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      height: 100,
      width: double.infinity,
      child: Row(
        children: [
          const SkeletonAvatar(
            style: SkeletonAvatarStyle(width: 100, height: 100),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: SkeletonParagraph(),
          )
        ],
      ),
    );
  }
}
