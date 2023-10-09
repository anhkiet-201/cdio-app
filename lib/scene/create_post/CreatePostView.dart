import 'dart:io';

import 'package:cdio/app.dart';
import 'package:cdio/component/BaseTextField.dart';
import 'package:cdio/component/CustomDropDown.dart';
import 'package:cdio/network/model/ProjectRresponseModel.dart';
import 'package:cdio/network/services/HouseService.dart';
import 'package:cdio/network/services/StorageService.dart';
import 'package:cdio/scene/create_post/project_choose/ProjectChooseView.dart';
import 'package:cdio/utils/present.dart';
import 'package:cdio/utils/snack_bar.dart';
import 'package:cdio/widget/scrollview/scrollview.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

part 'ViewModel.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _ViewModel(context),
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
  final ImagePicker imagePicker = ImagePicker();
  final _displayName = TextEditingController();
  final _description = TextEditingController();
  Project? _projectSelected;
  final _projectName = TextEditingController();
  String? _projectStatus;
  final _contactInfo = TextEditingController();
  final _projectDescription = TextEditingController();
  final _province = TextEditingController();
  final _district = TextEditingController();
  final _wards = TextEditingController();
  final _street = TextEditingController();
  final _numKitchen = TextEditingController();
  final _numBathroom = TextEditingController();
  final _numToilet = TextEditingController();
  final _numLivingRoom = TextEditingController();
  final _numBedRoom = TextEditingController();
  final _rentPrice = TextEditingController();
  final _sellPrice = TextEditingController();
  final _area = TextEditingController();
  List<XFile> _houseImages = [];
  XFile? _houseThumbnail;
  XFile? _projectThumbnail;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text(
          'Đăng tin bán hoặc cho thuê nhà',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w500,
            color: Colors.black
          ),
        ),
      ),
      bottomNavigationBar: _bottomBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: BaseScrollView.sliver(
              slivers: [
                SliverAppBar(
                  primary: false,
                  collapsedHeight: 60,
                  automaticallyImplyLeading: false,
                  pinned: true,
                  flexibleSpace: _titleField(),
                  surfaceTintColor: Colors.white,
                )
              ],
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _title('Ảnh bìa ngôi nhà'),
                        const Spacer(),
                        IconButton(
                            onPressed: () async {
                              var result = imagePicker.pickImage(source: ImageSource.gallery);
                              _houseThumbnail = await result;
                              setState(() {});
                            },
                            icon: const Row(children: [
                              Text('Chọn ảnh '),
                              Icon(Icons.image_outlined)
                            ],))
                      ],
                    ),
                  ),
                  if(_houseThumbnail == null)
                    _emptyText(),
                  _houseThumbnailImage(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _title('Hình ảnh ngôi nhà'),
                        const Spacer(),
                        IconButton(
                            onPressed: () async {
                              var result = imagePicker.pickMultiImage();
                              _houseImages = await result;
                              setState(() {});
                            },
                            icon: const Row(children: [
                              Text('Chọn ảnh '),
                              Icon(Icons.image_outlined)
                            ],))
                      ],
                    ),
                  ),
                  if(_houseImages.isEmpty)
                    _emptyText(),
                  _imagesPicked(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BaseTextField(
                          hint: 'Mô tả ngôi nhà',
                          controller: _description
                        ),
                        BaseTextField(
                            hint: 'Diện tích (*m2)',
                            controller: _area,
                          inputType: TextInputType.number
                        ),
                        _title('Thông tin giá'),
                        const Text(
                          '* Có thể để trống',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.redAccent
                          ),
                        ),
                        BaseTextField(
                            hint: 'Giá thuê',
                            isRequire: false,
                            inputType: TextInputType.number,
                          controller: _rentPrice
                        ),
                        BaseTextField(
                            hint: 'Giá mua',
                            isRequire: false,
                            inputType: TextInputType.number,
                          controller: _sellPrice
                        ),
                        _title('Thông tin số phòng'),
                        BaseTextField(
                            hint: 'Số phòng khách',
                          inputType: TextInputType.number,
                          controller: _numLivingRoom
                        ),
                        BaseTextField(
                            hint: 'Số phòng ngủ',
                            inputType: TextInputType.number,
                          controller: _numBedRoom
                        ),
                        BaseTextField(
                            hint: 'Số phòng bếp',
                            inputType: TextInputType.number,
                          controller: _numKitchen
                        ),
                        BaseTextField(
                            hint: 'Số phòng tắm',
                            inputType: TextInputType.number,
                          controller: _numBathroom
                        ),
                        BaseTextField(
                            hint: 'Số phòng vệ sinh',
                            inputType: TextInputType.number,
                          controller: _numToilet
                        ),
                        _title('Thông tin địa chỉ'),
                        BaseTextField(
                            hint: 'Tỉnh/Thành Phố',
                          controller: _province
                        ),
                        BaseTextField(
                            hint: 'Quận/Huyện',
                          controller: _district
                        ),
                        BaseTextField(
                            hint: 'Phường/Xã',
                          controller: _wards
                        ),
                        BaseTextField(
                            hint: 'Tên đường/Số nhà',
                          controller: _street
                        ),
                        Row(
                          children: [
                            _title('Thông tin dự án'),
                            const Spacer(),
                            IconButton(
                                onPressed: () async {
                                  showModalBottomSheet(
                                    showDragHandle: true,
                                      context: context,
                                      builder: (_) => const ProjectChoose()
                                  ).then((value) {
                                    _onPicked(value);
                                  });
                                },
                                icon: const Row(children: [
                                  Text('Chọn dự án sẵ có'),
                                  Icon(Icons.pages_rounded)
                                ],)
                            )
                          ],
                        ),
                        const Text(
                            '* Lưu ý: thông tin dự án không thể thay đổi sau khi đăng bài',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.redAccent
                          ),
                        ),
                        if(_projectSelected != null)
                          TextButton(onPressed: (){
                            _removeSelectedProject();
                          }, child: const Text(
                            '* Đã chọn dự án có sẵn. Nhấn hủy.',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.redAccent
                            ),
                          )),
                        BaseTextField(
                            hint: 'Tên dự án',
                          controller: _projectName,
                          enable: _projectSelected == null
                        ),
                        CustomDropDown(
                          items: const [
                            'Đang thi công',
                            'Đã bàn giao'
                          ],
                          value: _projectStatus,
                          hint: 'Chọn tình trạng dự án',
                          label: 'Tình trạng dự án',
                          onChange: (value) {
                            _projectStatus = value;
                          },
                        ),
                        BaseTextField(
                            hint: 'Thông tin liên hệ dự án',
                          controller: _contactInfo,
                            enable: _projectSelected == null
                        ),
                        BaseTextField(
                            hint: 'Mô tả dự án',
                          controller: _projectDescription,
                            enable: _projectSelected == null
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _title('Ảnh bìa dự án'),
                        const Spacer(),
                        IconButton(
                            onPressed: () async {
                              var result = imagePicker.pickImage(source: ImageSource.gallery);
                              _projectThumbnail = await result;
                              setState(() {});
                            },
                            icon: const Row(children: [
                              Text('Chọn ảnh '),
                              Icon(Icons.image_outlined)
                            ],))
                      ],
                    ),
                  ),
                  if(_projectThumbnail == null)
                    _emptyText(
                        text: _projectSelected?.projectThumbNailUrl == null ? '* Trống' : '* Ảnh từ dự án đã chọn'
                    ),
                  _projectThumbnailImage(),
                  const SizedBox(height: 50,)
                ],
              )
          ),
        ),
      ),
    );
  }

  Padding _emptyText({String text = '* Trống'}) {
    return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(text, style: const TextStyle(color: Colors.redAccent),),
                  );
  }

  @override
  void initState() {
    super.initState();
    context.read<_ViewModel>().addListener(_stateListen);
  }

}

extension on __ViewState {

  Widget _title(String text) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500
      ),
    ),
  );

  Widget _imagesPicked() => Visibility(
    visible: _houseImages.isNotEmpty,
    child: AspectRatio(
      aspectRatio: 14/9,
      child: PageView.builder(
        itemCount: _houseImages.length,
        itemBuilder: (_, index) {
          return Image.file(
            File(_houseImages[index].path),
            fit: BoxFit.cover,
            errorBuilder: (_, e, s) => const Center(
                child:
                Text('This image type is not supported')),
          );
        },
      ),
    ),
  );

  Widget _houseThumbnailImage() => Visibility(
    visible: _houseThumbnail != null,
    child: AspectRatio(
      aspectRatio: 14/9,
      child: _houseThumbnail != null ? Image.file(
        File(_houseThumbnail!.path),
        fit: BoxFit.cover,
        errorBuilder: (_, e, s) => const Center(
            child:
            Text('This image type is not supported')),
      ) : null,
    ),
  );

  Widget _projectThumbnailImage() => Visibility(
    visible: _projectThumbnail != null,
    child: AspectRatio(
      aspectRatio: 14/9,
      child: _projectThumbnail != null ? Image.file(
        File(_projectThumbnail!.path),
        fit: BoxFit.cover,
        errorBuilder: (_, e, s) => const Center(
            child:
            Text('This image type is not supported')),
      ) : null,
    ),
  );

  Widget _titleField() => Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: TextFormField(
    maxLines: 1,
    controller: _displayName,
    decoration: const InputDecoration(
        border: InputBorder.none, hintText: 'Tên hiển thị'),
    style: const TextStyle(
        fontSize: 22, fontWeight: FontWeight.w500),
  ),);

  Widget _bottomBar() => SizedBox(
    height: 50,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                dismiss(clear: true);
              }, icon: const Icon(Iconsax.close_circle)),
          const Spacer(),
          IconButton(
              onPressed: _onSubmit, icon: const Icon(Iconsax.send_1)),
        ],
      ),
    ),
  );
}

extension on __ViewState {
  _onPicked(Project? project) {
    if(project == null) return;
    setState(() {
      _projectSelected = project;
      _projectStatus = (project.projectStatus ?? '') == 'DaHoanThanh' ? 'Đã bàn giao' : 'Đang thi công';
    });
    _projectName.text = project.projectName ?? '';
    _contactInfo.text = project.contactInfo ?? '';
    _projectDescription.text = project.projectDescription ?? '';
  }

  _removeSelectedProject() {
    _projectSelected = null;
    _projectStatus = null;
    _projectName.clear();
    _contactInfo.clear();
    _projectDescription.clear();
    setState(() {

    });
  }

  _onSubmit() {
    if(_displayName.text.isEmpty) {
      context.showCustomSnackBar('Tên hiển thị không được để trống');
      return;
    }
    if(_formKey.currentState?.validate() ?? false) {
      context.read<_ViewModel>()
          .post(
          displayName: _displayName.text,
        description: _description.text,
        projectId: _projectSelected?.projectId,
        projectName: _projectName.text,
        projectStatus: _projectStatus,
        contactInfo: _contactInfo.text,
        projectThumbNailFile: _projectThumbnail,
        projectDescription: _projectDescription.text,
        province: _province.text,
        district: _district.text,
        area: double.tryParse(_area.text)?.floorToDouble(),
        wards: _wards.text,
        street: _street.text,
        thumbNailFile: _houseThumbnail,
        numKitchen: int.tryParse(_numKitchen.text),
        numBathroom: int.tryParse(_numBathroom.text),
        numToilet: int.tryParse(_numToilet.text),
        numLivingRoom: int.tryParse(_numLivingRoom.text),
        numBedRoom: int.tryParse(_numBedRoom.text),
        imagesFile: _houseImages,
        rentPrice: double.tryParse(_rentPrice.text),
        sellPrice: double.tryParse(_sellPrice.text)
      );
    }
    else {
      context.showCustomSnackBar('Thiếu thông tin. Vui lòng kiểm tra lại');
    }
  }

  _stateListen() {
    if(context.read<_ViewModel>().isLoading) {
      showModalBottomSheet(context: context, builder: (_) => const SizedBox(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballTrianglePathColoredFilled,
                ),
              ),
              SizedBox(height: 20,),
              Text(
                  'Đang xử lý!'
              )
            ],
          ),
        ),
      ), enableDrag: false, isDismissible: false);
    } else {
      Navigator.maybeOf(context)?.pop();
      dispose();
    }
  }
}
