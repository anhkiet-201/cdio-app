import 'package:cdio/network/model/ErrorResponseModel.dart';
import 'package:cdio/network/services/AuthService.dart';
import 'package:cdio/scene/forget_password/ForgetPassword.dart';
import 'package:cdio/scene/register/RegisterView.dart';
import 'package:cdio/utils/LocalStorageService.dart';
import 'package:cdio/utils/extensions/context.dart';
import 'package:cdio/utils/present.dart';
import 'package:cdio/utils/shared/Shared.dart';
import 'package:cdio/utils/snack_bar.dart';
import 'package:cdio/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../component/CustomButton.dart';
import '../../component/EmailField.dart';
import '../../component/PasswordField.dart';
import '../../network/model/UserModel.dart';
part './ViewModel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
  State<_View> createState() => __ViewState();
}

class __ViewState extends State<_View> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  late _ViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<_ViewModel>(context);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: _viewModel.isLoading ? _loading() : _content()
      ),
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
                'Welcome,',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                'Sign in to continue,',
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
        PasswordField(
          controller: _passController,
        ),
        const SizedBox(
          height: 30,
        ),
        CustomButton(
          text: "Login",
          onClick: () {
            _viewModel.login(email: _emailController.text, password: _passController.text);
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: (){
            present(view: const ForgetPasswordView());
          }, child: const Text("Forget password?")),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Not a member?'),
            TextButton(
                onPressed: (){
                  present(
                    view: RegisterView()
                  );
                },
                child: const Text(
                  'Signup now.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                )
            )
          ],
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
          SizedBox(height: 20,),
          Text(
            'Đang đăng nhập!'
          )
        ],
      ),
    ),
  );
}
