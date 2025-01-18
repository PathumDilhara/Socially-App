import 'package:flutter/material.dart';
import 'package:socially_app/utils/constants/colors.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isObscureText;
  final String? Function(String?)? validator;
  const CustomInput({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.isObscureText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(10),
    );

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: borderStyle,
        focusedBorder: borderStyle,
        enabledBorder: borderStyle,
        labelText: labelText,
        labelStyle: TextStyle(color: mainWhiteColor),
        filled: true,
        prefixIcon: Icon(
          icon,
          color: mainWhiteColor,
          size: 20,
        ),
      ),obscureText: isObscureText,
      validator: validator,
    );
  }
}
