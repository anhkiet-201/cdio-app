import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'CustomTextField.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({Key? key, this.controller}) : super(key: key);
  final TextEditingController? controller;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isVisiable = false;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
        controller: widget.controller,
        hintText: 'Password',
        obscureText: !_isVisiable,
        prefixIcon: const Icon(Icons.password_outlined),
        suffixIcon: TextButton(
            onPressed: () => setState(() {
                  _isVisiable = !_isVisiable;
                }),
            child: _isVisiable
                ? const Icon(Iconsax.eye_slash)
                : const Icon(Iconsax.eye)));
  }
}
