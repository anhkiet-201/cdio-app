import 'package:cdio/network/model/UserModel.dart';
import 'package:cdio/utils/present.dart';
import 'package:cdio/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../component/CustomButton.dart';
import '../../component/CustomTextField.dart';
import '../../component/EmailField.dart';
import '../../component/PasswordField.dart';
import '../../network/model/ErrorResponseModel.dart';
import '../../network/services/AuthService.dart';
import '../../utils/LocalStorageService.dart';
import '../../utils/shared/Shared.dart';
part 'ViewModel.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(context),
      child: const _View(),
    );
  }
}

class _View extends StatefulWidget {
  const _View({super.key});

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _birthdayController =
  TextEditingController(text: '01/01/2001');
  late _ViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<_ViewModel>(context);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: _viewModel.isLoading ? _loading() : _content(context),
      ),
    );;
  }

  Widget _content(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Tạo tài khoản mới',
              style: TextStyle(
                  fontSize: 40, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          CustomTextField(
            hintText: 'Username',
            prefixIcon: const Icon(Icons.person_2_outlined),
            controller: _usernameController,
          ),
          CustomTextField(
            hintText: 'Birthday',
            prefixIcon: const Icon(Icons.date_range_outlined),
            readOnly: true,
            controller: _birthdayController,
            onTap: () {
              showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now())
                  .then((value) {
                if (value != null) {
                  _birthdayController.text =
                  '${value.month}/${value.day}/${value.year}';
                }
              });
            },
          ),
          EmailField(
            controller: _emailController,
          ),
          PasswordField(
            controller: _passController,
          ),
          const SizedBox(
            height: 30,
          ),
          CustomButton(
            text: "Signup",
            onClick: () {
              _viewModel.register(email: _emailController.text.trim(), password: _passController.text.trim());
            },
          ),
          const SizedBox(height: 30,)
        ],
      ),
    );
  }

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
          SizedBox(height: 20,),
          Text(
              'Đang đăng ký!'
          )
        ],
      ),
    ),
  );
}

