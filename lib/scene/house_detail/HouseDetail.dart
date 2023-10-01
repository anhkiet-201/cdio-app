import 'package:cdio/network/model/HouseReponse.dart';
import 'package:cdio/widget/scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';

class HouseDetail extends StatefulWidget {
  const HouseDetail(this.house, {super.key});

  final HouseResponse house;

  @override
  State<HouseDetail> createState() => _HouseDetailState();
}

class _HouseDetailState extends State<HouseDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseScrollView.sliver(
        slivers: [
          SliverLayoutBuilder(
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
                  background: _houseImage(),
                  collapseMode: CollapseMode.parallax,
                ),
              );
            },
          ),
        ], body: Column(
        children: [
          _infoBar()
        ],
      ),
      ),
      bottomNavigationBar: _contactBar(),
    );
  }
}

extension on _HouseDetailState {

  Widget spacer() => const SizedBox(height: 20,);

  Widget _contactBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 75,
      child: Row(
        children: [
          _avatar(),
          const Spacer(),
          IconButton.outlined(onPressed: () {
            showModalBottomSheet(

                context: context,
                builder: (_) => Container(height: 200,),
            );
          }, icon: const Icon(Iconsax.message)),
          IconButton.outlined(onPressed: () {}, icon: const Icon(Iconsax.call))
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
            user?.avatarUrl ?? 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww&w=1000&q=80',
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10,),
        Text(
          user?.fullName ?? 'User name',
          style: const TextStyle(
            fontWeight: FontWeight.w600
          ),
        )
      ],
    );
  }

  Widget _houseImage() {
    final houseImages = widget.house.info?.houseImage ?? [];
    return Visibility(
      visible: houseImages.isNotEmpty,
      child: SizedBox(
        height: 275,
        child: PageView.builder(
          itemCount: houseImages.length,
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
              houseImages[index].imageUrl ?? '',
              fit: BoxFit.cover,
            );
          },
        ),
      ),
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
                '${DateTime.fromMillisecondsSinceEpoch(house.createTime ?? 0).toLocal()}',
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
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16
            ),

          )
        ],
      ),
    );
  }

  Widget _prices() {
    final type = widget.house.info?.houseTypeDetailHouseTypes ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for(final t in type)
          Text(
            'Giá ${t.typeName! == 'Rent' ? 'thuê' : 'bán'}: ${t.price} vnđ'
          )
      ],
    );
  }

  Widget _address() {
    final address = widget.house.address;
    return Text(
      '${address?.street}, ${address?.wards}, ${address?.district}, ${address?.province}'
    );
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

  Widget _optionItem({required String label, int? numOf}) {
    return Visibility(
      visible: (numOf ?? 0) > 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: const BorderRadius.all(Radius.circular(20))
        ),
        child: Center(
          child: Text(
            '$label: $numOf'
          ),
        ),
      ),
    );
  }
}
