import 'package:cdio/utils/snack_bar.dart';
import 'package:flutter/material.dart';

import '../../component/CustomButton.dart';
import '../../component/CustomTextField.dart';
import '../../component/EmailField.dart';
import '../../component/PasswordField.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _birthdayController =
  TextEditingController(text: '01/01/2001');

  @override
  Widget build(BuildContext context) {
    return _content(context);
  }

  Widget _content(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Create Account',
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
                    context.showCustomSnackBar('sdads');
                  },
                ),
                const SizedBox(height: 30,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
