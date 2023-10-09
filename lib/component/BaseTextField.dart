import 'package:flutter/material.dart';

Widget BaseTextField({String? hint, TextEditingController? controller, int? maxLine, double? fontSize, bool isRequire = true, TextInputType? inputType, bool enable = true}) => TextFormField(
  maxLines: maxLine,
  controller: controller,
  keyboardType: inputType,
  readOnly: !enable,
  decoration: InputDecoration(
      labelText: hint,
      border: InputBorder.none, hintText: 'Nhập $hint'),
  style: TextStyle(
      fontSize: fontSize
  ),

  validator: (value) {
    if((value == null || value.isEmpty) && isRequire) {
      return '$hint không được để trống';
    }
    return null;
  },
);