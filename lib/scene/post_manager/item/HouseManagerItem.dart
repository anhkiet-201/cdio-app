import 'package:cdio/component/CustomButton.dart';
import 'package:cdio/component/CustomImage.dart';
import 'package:cdio/network/model/HouseReponse.dart';
import 'package:cdio/network/services/HouseService.dart';
import 'package:cdio/utils/snack_bar.dart';
import 'package:cdio/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class HouseManagerItem extends StatelessWidget {
  const HouseManagerItem(this.house, {super.key});
  final House house;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _ViewModel(context),
      child: _View(house),
    );
  }
}

class _View extends StatefulWidget {
  const _View(this.house, {super.key});
  final House house;
  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<_ViewModel>(context);
    final house = widget.house;
    return Visibility(
      visible: !viewModel.deleted,
      child: SizedBox(
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
                IconButton(onPressed:() => _showConfirm(house), icon: const Icon(Iconsax.trash, size: 20,)),
                const Spacer(),
                IconButton(onPressed: (){}, icon: const Icon(Iconsax.edit, size: 20,)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _loading() => WillPopScope(
    onWillPop: () async {
      return !context.read<_ViewModel>().isDeleting;
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 120,
              child: LoadingIndicator(
                indicatorType: Indicator.ballZigZagDeflect,
              ),
            )
          ],
        ),
      ),
    ),
  );

  _showConfirm(House house) {
    showModalBottomSheet<bool>(
        context: context,
        showDragHandle: true,
        builder: (_) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const Text(
                    'Xác nhận xóa',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 20,),
                CDImage(
                  url: house.info?.thumbNailUrl,
                  width: 175,
                  height: 175,
                  radius: 15,
                ),
                const SizedBox(height: 10,),
                Text(
                  '${house.displayName}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                const SizedBox(height: 10,),
                CDImage(
                  url: house.account?.avatarUrl,
                  width: 50,
                  height: 50,
                  radius: 25,
                ),
                const SizedBox(height: 5,),
                Text(
                  '${house.account?.fullName}',
                  style: const TextStyle(
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(child: CustomButton(text: 'Hủy', onClick: (){Navigator.maybeOf(context)?.pop(false);})),
                    const SizedBox(width: 20,),
                    Expanded(child: CustomButton(text: 'Xóa', onClick: (){
                      Navigator.maybeOf(context)?.pop(true);
                    })),
                  ],
                )
              ],
            ),
          );
        }
    ).then((value) {
      if(value ?? false) {
        context.read<_ViewModel>().delete(house.houseId);
        showModalBottomSheet<bool>(
            context: context,
            showDragHandle: true,
            isDismissible: false,
            enableDrag: false,
            builder: (_) {
              return _loading();
            }
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<_ViewModel>().addListener(() {
      if(!context.read<_ViewModel>().isDeleting) {
        Navigator.maybeOf(context)?.pop();
      }
    });
  }
}

class _ViewModel with ChangeNotifier {
  _ViewModel(this.context);
  final BuildContext context;
  final _service = HouseService.shared;

  bool _isDeleting = false;

  bool get isDeleting => _isDeleting;

  set isDeleting(bool value) {
    _isDeleting = value;
    notifyListeners();
  }

  bool deleted = false;

  delete(int? id) async {
    if(id == null) {
      context.showSnackBar(SnackBarType.error);
      return;
    }
    isDeleting = true;
    await _service.deleteHouse(id: id)
    .then((value) {
      if(!(value?.status ?? false)) return;
      deleted = true;
    })
    .onError((error, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
    })
    .whenComplete((){
      isDeleting = false;
    });
  }
}

