import 'package:athar/shared/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class SnackBarService {
  static void success({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      _snackBar(context: context, bgColor: Colors.green, text: message),
    );
  }

  static void failure({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      _snackBar(context: context, bgColor: Colors.red, text: message),
    );
  }
}

SnackBar _snackBar({
  required BuildContext context,
  required Color bgColor,
  required String text,
}) {
  return SnackBar(
    elevation: 6.0,
    backgroundColor: bgColor,
    behavior: SnackBarBehavior.floating,
    padding: EdgeInsets.symmetric(vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    duration: const Duration(seconds: 2),
    animation: CurvedAnimation(
      parent: const AlwaysStoppedAnimation(1),
      curve: Curves.elasticOut,
    ),
    content: CustomText(
      text,
      variant: TextVariant.titleMedium,
      maxLines: 5,
      textAlign: TextAlign.center,
    ),
  );
}
