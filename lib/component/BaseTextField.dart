import 'package:flutter/material.dart';

Widget BaseTextField({String? hint, TextEditingController? controller, int? maxLine, double? fontSize, bool isRequire = true, TextInputType? inputType}) => TextFormField(
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
    if(value == null && isRequire) {
      return 'Không được để trống';
    }
    return null;
  },
);