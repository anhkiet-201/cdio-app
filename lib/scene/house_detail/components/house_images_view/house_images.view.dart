import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../component/CustomImage.dart';
import '../../../../network/model/HouseReponse.dart';

class HouseImagesView extends StatefulWidget {
  const HouseImagesView(this.images, {super.key});
  final List<HouseImage>? images;
  @override
  State<HouseImagesView> createState() => _HouseImagesViewState();
}

class _HouseImagesViewState extends State<HouseImagesView> {
  int _currentImage = 1;

  @override
  Widget build(BuildContext context) {
    final houseImages = widget.images ?? [];
    return SliverVisibility(
      visible: houseImages.isNotEmpty,
      sliver: SliverLayoutBuilder(
        builder: (BuildContext contextSliver, SliverConstraints constraints) {
          final isCollapsed = constraints.scrollOffset >= (275 - kToolbarHeight);
          return SliverAppBar(
            expandedHeight: 275,
            iconTheme: IconThemeData(
                color: isCollapsed ? Colors.black : Colors.white
            ),
            stretch: true,
            actions: [
              IconButton(onPressed: (){}, icon: const Icon(Iconsax.heart),)
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: SizedBox(
                height: 275,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PageView.builder(
                      itemCount: houseImages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CDImage(
                          url: houseImages[index].imageUrl,
                          fit: BoxFit.cover,
                        );
                      },
                      onPageChanged: (index) => setState(() {
                        _currentImage = index + 1;
                      }),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Text(
                            '$_currentImage/${houseImages.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              collapseMode: CollapseMode.parallax,
            ),
          );
        },
      ),
    );
  }
}
