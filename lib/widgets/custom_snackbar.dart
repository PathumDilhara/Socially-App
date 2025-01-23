import 'package:flutter/material.dart';
import 'package:socially_app/utils/constants/colors.dart';

void customSnackBar({
  required String content,
  required Color color,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(
        content,
        style: TextStyle(
          color: mainWhiteColor,
        ),
      ),
    ),
  );
}
