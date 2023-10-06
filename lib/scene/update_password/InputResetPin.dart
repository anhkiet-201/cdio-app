import 'package:cdio/component/CustomButton.dart';
import 'package:cdio/component/PasswordField.dart';
import 'package:cdio/network/model/ErrorResponseModel.dart';
import 'package:cdio/network/services/AuthService.dart';
import 'package:cdio/utils/LocalStorageService.dart';
import 'package:cdio/utils/extensions/context.dart';
import 'package:cdio/utils/present.dart';
import 'package:cdio/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
part 'ViewModel.dart';

class InputResetPin extends StatelessWidget {
  const InputResetPin(this.email, {super.key});
  final String email;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _ViewModel(context, email),
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
  late _ViewModel _viewModel;
  final pinController = TextEditingController();
  final _passController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  final focusedBorderColor = const Color.fromRGBO(23, 171, 144, 1);
  final fillColor = const Color.fromRGBO(243, 246, 249, 0);
  final borderColor = const Color.fromRGBO(23, 171, 144, 0.4);

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

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

extension on _ViewState {
  Widget _content() {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cập nhật mật khẩu',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  'Nhập mã pin',
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
          Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Directionality(
                  // Specify direction if desired
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    length: 7,
                    controller: pinController,
                    focusNode: focusNode,
                    androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsUserConsentApi,
                    listenForMultipleSmsOnAndroid: true,
                    defaultPinTheme: defaultPinTheme,
                    separatorBuilder: (index) => const SizedBox(width: 8),
                    // validator: (value) {
                    //   return value == '2222222' ? null : 'Pin is incorrect';
                    // },
                    // onClipboardFound: (value) {
                    //   debugPrint('onClipboardFound: $value');
                    //   pinController.setText(value);
                    // },
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {

                    },
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: focusedBorderColor,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 50,),
          PasswordField(
            controller: _passController,
          ),
          CustomButton(
            text: "OK",
            onClick: () {
              print(pinController.text);
              _viewModel.updatePassword(password: _passController.text.trim(), token: pinController.text.trim());
            },
          ),
          const SizedBox(
            height: 30,
          ),
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
              'Đang cập nhật mật khẩu!'
          )
        ],
      ),
    ),
  );
}
