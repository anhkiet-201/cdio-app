import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key? key,
      this.hintText,
      this.controller,
      this.obscureText = false,
      this.inputType,
      this.suffixIcon,
      this.onChange,
      this.prefixIcon,
      this.enable = true,
      this.readOnly = false,
      this.onTap})
      : super(key: key);

  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? inputType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function(String)? onChange;
  final bool enable;
  final bool readOnly;
  final Function? onTap;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  late Tween<double> tween;
  late FocusNode _focusNode;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    tween = Tween<double>(begin: 0, end: 1);
    animation = tween.animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn));
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Stack(
        children: [
          TextFormField(
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              suffixIcon: widget.suffixIcon,
              prefixIcon: widget.prefixIcon,
            ),
            onChanged: (value) => widget.onChange?.call(value),
            keyboardType: widget.inputType,
            controller: widget.controller,
            obscureText: widget.obscureText,
            enabled: widget.enable,
            readOnly: widget.readOnly,
            onTap: () => widget.onTap?.call(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return LinearProgressIndicator(
                  value: animation.value,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
