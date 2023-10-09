import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.items,
    this.hint,
    this.onChange,
    this.onSave,
    this.validator,
    this.label,
    this.value
  });
  final List<String> items;
  final String? value;
  final String? Function(String?)? validator;
  final String? hint;
  final Function(String?)? onChange;
  final Function(String?)? onSave;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      isExpanded: true,
      value: value,
      items: items
          .map((item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
        ),
      )).toList(),
      onSaved: (value) {
        // selectedValue = value.toString();
      },
      dropdownStyleData: DropdownStyleData(
        elevation: 1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.expand_circle_down,
          color: Colors.black45,
        ),
      ),
      decoration: InputDecoration(
          // Add Horizontal padding using menuItemStyleData.padding so it matches
          // the menu padding when button's width is not specified.
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        border: InputBorder.none,
          labelText: label
          // Add more decoration..
          ),
      hint: hint != null ? Text(
        hint!,
      ) : null,
      validator: validator,
      onChanged: onChange,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500
      ),
    );
  }
}
