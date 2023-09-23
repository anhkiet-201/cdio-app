import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.text,
      required this.onClick,
      this.suffix,
      this.prefix,
      this.mainAxisSize = MainAxisSize.max})
      : super(key: key);

  final String text;
  final Widget? prefix;
  final Widget? suffix;
  final Function() onClick;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        // style: CustomButtonStyle(),
        onPressed: onClick,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: mainAxisSize,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              prefix ?? const SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  text,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              suffix ?? const SizedBox(),
            ],
          ),
        ));
  }
}
