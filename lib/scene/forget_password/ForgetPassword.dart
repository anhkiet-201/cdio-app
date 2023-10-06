import 'package:cdio/scene/update_password/InputResetPin.dart';
import 'package:cdio/scene/forget_password/_ViewModel.dart';
import 'package:cdio/utils/present.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../component/CustomButton.dart';
import '../../component/EmailField.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: UpdatePasswordViewModel(context),
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
  final TextEditingController _emailController = TextEditingController();
  late UpdatePasswordViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<UpdatePasswordViewModel>(context);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: _viewModel.isLoading ? _loading() : _content()),
    );
  }
}

extension on __ViewState {
  Widget _content() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Khôi phục mật khẩu',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    'Nhập email để tiếp tục.',
                    style: TextStyle(
                      fontSize: 35,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            EmailField(
              controller: _emailController,
            ),
            CustomButton(
              text: "OK",
              onClick: () {
                _viewModel.reset(_emailController.text.trim()).then((_) {
                  if (_viewModel.status) {
                    present(view: InputResetPin(_emailController.text.trim()));
                  }
                });
              },
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      );

  Widget _loading() => SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: const Center(
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
              SizedBox(
                height: 20,
              ),
              Text('Đang xác minh!')
            ],
          ),
        ),
      );
}
