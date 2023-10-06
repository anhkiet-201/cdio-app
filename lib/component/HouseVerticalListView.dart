import 'package:cdio/component/CustomImage.dart';
import 'package:cdio/network/model/HouseReponse.dart';
import 'package:cdio/utils/utils.dart';
import 'package:cdio/widget/scrollview/scrollview.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class HouseVerticalListView extends StatelessWidget {
  const HouseVerticalListView(this.house, {super.key, required this.isLoading, required this.hasNext, required this.onLoadMore});
  final List<HouseResponse> house;
  final bool isLoading;
  final bool hasNext;
  final Function() onLoadMore;

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
    );
  }

  Widget _item(BuildContext context, int index) {
    final item = house[index];
    return SizedBox(
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
              padding: const EdgeInsets.all(10),
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
                  const SizedBox(
                    height: 5,
                  ),
                  const Spacer(),
                  const Row(
                    children: [Text('1224 m2'), Spacer(), Text('15 ty')],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                      timeAgo(item.createTime),
                    style: const TextStyle(
                      color: Colors.grey
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
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
