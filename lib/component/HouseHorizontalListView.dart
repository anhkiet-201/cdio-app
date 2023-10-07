import 'package:cdio/component/CustomImage.dart';
import 'package:cdio/network/model/HouseReponse.dart';
import 'package:cdio/scene/house_detail/HouseDetail.dart';
import 'package:cdio/widget/scrollview/scrollview.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class HouseHorizontalListView extends StatelessWidget {
  const HouseHorizontalListView({
    super.key,
    required this.house,
    required this.title,
    required this.isLoading,
    this.onMoreClick
  });
  final List<House> house;
  final String title;
  final bool isLoading;
  final Function? onMoreClick;

  @override
  Widget build(BuildContext context) {
    return _list(context);
  }
}

extension on HouseHorizontalListView {
  Widget _list(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(title),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              height: 200,
              child: BaseScrollView.horizontal(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                isLoading: isLoading,
                itemCount: house.length,
                spacing: 50,
                itemBuilder: (_, index) {
                  return _listItem(index, context);
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

  Widget _listItem(int index, BuildContext context) {
    final House house = this.house[index];
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
                url: house.info?.thumbNailUrl,
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

  Widget _title(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ),
  );
}
