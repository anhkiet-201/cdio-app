import 'dart:io';

import 'package:cdio/app.dart';
import 'package:cdio/component/CustomDropDown.dart';
import 'package:cdio/utils/present.dart';
import 'package:cdio/widget/scrollview/scrollview.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
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
  final FocusNode _focusNode = FocusNode();
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
                        _textField(
                          hint: 'Mô tả ngôi nhà'
                        ),
                        _title('Thông tin số phòng'),
                        _textField(
                            hint: 'Số phòng khách',
                          inputType: TextInputType.number
                        ),
                        _textField(
                            hint: 'Số phòng ngủ',
                            inputType: TextInputType.number
                        ),
                        _textField(
                            hint: 'Số phòng bếp',
                            inputType: TextInputType.number
                        ),
                        _textField(
                            hint: 'Số phòng tắm',
                            inputType: TextInputType.number
                        ),
                        _textField(
                            hint: 'Số phòng vệ sinh',
                            inputType: TextInputType.number
                        ),
                        _title('Thông tin địa chỉ'),
                        _textField(
                            hint: 'Tỉnh/Thành Phố'
                        ),
                        _textField(
                            hint: 'Quận/Huyện'
                        ),
                        _textField(
                            hint: 'Phường/Xã'
                        ),
                        _textField(
                            hint: 'Tên đường/Số nhà'
                        ),
                        _title('Thông tin dự án'),
                        const Text(
                            '* Lưu ý: thông tin dự án không thể thay đổi sau khi đăng bài',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.redAccent
                          ),
                        ),
                        _textField(
                            hint: 'Tên dự án'
                        ),
                        CustomDropDown(
                          items: const [
                            'Đang thi công',
                            'Đã bàn giao'
                          ],
                          hint: 'Chọn tình trạng dự án',
                          label: 'Tình trạng dự án',
                          onChange: (value) {

                          },
                        ),
                        _textField(
                            hint: 'Thông tin liên hệ dự án'
                        ),
                        _textField(
                            hint: 'Mô tả dự án'
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
                    _emptyText(),
                  _projectThumbnailImage(),
                  const SizedBox(height: 50,)
                ],
              )
          ),
        ),
      ),
    );
  }

  Padding _emptyText() {
    return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('* Trống', style: TextStyle(color: Colors.redAccent),),
                  );
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
    decoration: const InputDecoration(
        border: InputBorder.none, hintText: 'Tên hiển thị'),
    style: const TextStyle(
        fontSize: 22, fontWeight: FontWeight.w500),
  ),);

  Widget _textField({String? hint, TextEditingController? controller, int? maxLine, double? fontSize, bool useValidator = true, TextInputType? inputType}) => TextFormField(
    maxLines: maxLine,
    controller: controller,
    keyboardType: inputType,
    decoration: InputDecoration(
      labelText: hint,
        border: InputBorder.none, hintText: 'Nhập $hint'),
    style: TextStyle(
      fontSize: fontSize
    ),
    validator: (value) {
      if(value == null && useValidator) {
        return 'Không được để trống';
      }
      return null;
    },
  );

  Widget _bottomBar() => SizedBox(
    height: 50,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                dismiss(clear: true);
              }, icon: const Icon(Icons.close_rounded)),
          const Spacer(),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.send_outlined)),
        ],
      ),
    ),
  );
}

enum CreatePostType {
  normal("Create normal post"), attendance("Create attendance post");
  final String title;
  const CreatePostType(this.title);
}
