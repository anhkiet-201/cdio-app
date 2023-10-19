import 'package:cdio/component/CustomImage.dart';
import 'package:cdio/component/favorite_button/FavoriteButton.dart';
import 'package:cdio/network/model/HouseReponse.dart';
import 'package:cdio/scene/house_detail/components/house_images_view/house_images.view.dart';
import 'package:cdio/scene/house_detail/components/same_project_view/same_project_view.dart';
import 'package:cdio/scene/login/LoginView.dart';
import 'package:cdio/utils/extensions/context.dart';
import 'package:cdio/utils/present.dart';
import 'package:cdio/utils/snack_bar.dart';
import 'package:cdio/utils/utils.dart';
import 'package:cdio/widget/scrollview/scrollview.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HouseDetail extends StatefulWidget {
  const HouseDetail(this.house, {super.key});

  final House house;

  @override
  State<HouseDetail> createState() => _HouseDetailState();
}

class _HouseDetailState extends State<HouseDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseScrollView.sliver(
        slivers: [HouseImagesView(widget.house)],
        body: Column(
          children: [
            if (widget.house.info?.houseImage == null)
              const SizedBox(
                height: 10,
              ),
            _infoBar(),
            const SizedBox(
              height: 10,
            ),
            _projectView(),
            const SizedBox(
              height: 10,
            ),
            SameProjectView(widget.house.houseId),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
      bottomNavigationBar:context.appState.user != null ?  _contactBar() : null,
    );
  }
}

extension on _HouseDetailState {
  Widget spacer() => const SizedBox(
        height: 20,
      );

  Widget _contactBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 75,
      child: Row(
        children: [
          _avatar(),
          const Spacer(),
          IconButton.outlined(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => _contactSheet(),
                  showDragHandle: true
                );
              },
              icon: const Icon(Iconsax.message)),
          if(widget.house.account?.phoneNumber != null)
            IconButton.outlined(onPressed: () {}, icon: const Icon(Iconsax.call))
        ],
      ),
    );
  }

  Widget _contactSheet() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {},
            child: Text('Gửi tin qua email: ${widget.house.account?.email}'),
          ),
          if(widget.house.account?.phoneNumber != null)
            TextButton(onPressed: () {}, child: Text('Gửi tin qua số điện thoại: ${widget.house.account?.phoneNumber}')
            ),
        ],
      ),
    );
  }

  Widget _avatar() {
    final user = widget.house.account;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          child: Image.network(
            user?.avatarUrl ??
                'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww&w=1000&q=80',
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          user?.fullName ?? 'User name',
          style: const TextStyle(fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Widget _infoBar() {
    final house = widget.house;
    final info = house.info;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Spacer(),
              Text(
                timeAgo(house.createTime),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
          Text(
            house.displayName ?? '',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          spacer(),
          _prices(),
          spacer(),
          _address(),
          spacer(),
          _options(),
          spacer(),
          Text(
            house.description ?? '',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget _prices() {
    final type = widget.house.info?.houseTypeDetailHouseTypes ?? [];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final t in type)
              Text('Giá ${t.typeName! == 'Rent' ? 'thuê' : 'bán'}: ${priceFormat(t.price)}')
          ],
        ),
        const Spacer(),
        SizedBox(
          height: 40,
          width: 40,
          child: Center(child: FavoriteButton(widget.house.houseId ?? -1)),
        )
      ],
    );
  }

  Widget _address() {
    final address = widget.house.address;
    return Text(
        '${address?.street}, ${address?.wards}, ${address?.district}, ${address?.province}');
  }

  Widget _options() {
    final info = widget.house.info;
    return SizedBox(
      height: 25,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          _optionItem(label: 'Phòng khách', numOf: info?.numLivingRoom),
          _optionItem(label: 'Phòng ngủ', numOf: info?.numBedRoom),
          _optionItem(label: 'Phòng tắm', numOf: info?.numBathroom),
          _optionItem(label: 'Phòng bếp', numOf: info?.numKitchen),
          _optionItem(label: 'Toilet', numOf: info?.numToilet),
        ],
      ),
    );
  }

  Widget _projectView() {
    final project = widget.house.project;
    return Visibility(
      visible: project != null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Thuộc dự án:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            if (project?.projectThumbNailUrl != null)
              AspectRatio(
                aspectRatio: 1,
                child: CDImage(
                  url: project?.projectThumbNailUrl,
                  background: Colors.grey.withOpacity(0.5),
                ),
              ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '${project?.projectName}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            Text(
              '${project?.projectStatus}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            if (project?.projectDescription != null)
              Text(
                '${project?.projectDescription}',
              ),
            if (project?.contactInfo != null)
              Text(
                '${project?.contactInfo}',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              )
          ],
        ),
      ),
    );
  }

  Widget _optionItem({required String label, int? numOf}) {
    return Visibility(
      visible: (numOf ?? 0) > 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Center(
          child: Text('$label: $numOf'),
        ),
      ),
    );
  }
}
