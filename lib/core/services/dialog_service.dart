// ignore_for_file: unused_element_parameter

import 'package:athar/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/custom_text.dart';

class DialogServices {
  static Future<void> showCustomDialog({
    required BuildContext context,
    required Widget dialog,
  }) async {
    await showDialog(context: context, builder: (context) => dialog);
    // Implement your dialog logic here
  }

  static Future<void> showAddDialog({
    required BuildContext context,
    required String title,
    required Widget body,
    required String confirmText,
    required Function() onConfirm,
    double? buttonTopSpacing,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => _AddDialogBody(
        title: title,
        body: body,
        confirmText: confirmText,
        onConfirm: onConfirm,
        buttonTopSpacing: buttonTopSpacing ?? 10,
      ),
    );
  }

  static Future<void> showEditDialog({
    required BuildContext context,
    required String title,
    required Widget body,
    required Function() onConfirm,
    double? buttonTopSpacing,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => _AddDialogBody(
        title: title,
        body: body,
        confirmText: "تعديل",
        onConfirm: onConfirm,
        buttonTopSpacing: buttonTopSpacing ?? 0,
      ),
    );
  }

  static Future<void> showLogoutDialog({
    required BuildContext context,
    required bool isLoading,
    required Function() onConfirm,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => _DialogBody(
        icon: Icons.warning,
        title: "تسجيل الخروج",
        description: "هل أنت متأكد أنك تريد تسجيل الخروج؟",
        confirmText: "تسجيل الخروج",
        onConfirm: onConfirm,
      ),
    );
  }

  static Future<void> showDeleteDialog({
    required BuildContext context,
    required String title,
    required String description,
    required Function() onConfirm,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => _DialogBody(
        icon: Icons.warning,
        title: title,
        description: description,
        confirmText: "حذف",
        onConfirm: onConfirm,
      ),
    );
  }
}

class _DialogBody extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String confirmText;
  final Function() onConfirm;
  const _DialogBody({
    required this.icon,
    required this.title,
    required this.description,
    required this.confirmText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    var color = Colors.redAccent;
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: 28,
              child: Icon(
                Icons.warning,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            SizedBox(height: 20),
            CustomText(title, maxLines: 2, variant: TextVariant.titleMedium),
            SizedBox(height: 8),
            CustomText(
              description,
              variant: TextVariant.bodyMedium,
              maxLines: 5,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Row(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      onConfirm();
                    },
                    text: confirmText,
                  ),
                ),
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: "إلغاء",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddDialogBody extends StatelessWidget {
  final String title;
  final Widget body;
  final String confirmText;
  final Function() onConfirm;
  final double buttonTopSpacing;
  const _AddDialogBody({
    required this.title,
    required this.body,
    required this.confirmText,
    required this.onConfirm,
    required this.buttonTopSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: mediaQuery.size.height * 0.75,
              minWidth: constraints.minWidth,
              maxWidth: constraints.maxWidth,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(title, variant: TextVariant.labelMedium),
                  SizedBox(height: 10),
                  body,
                  SizedBox(height: buttonTopSpacing),
                  Row(
                    spacing: 15,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: AppButton(
                          onPressed: () => onConfirm(),
                          text: confirmText,
                        ),
                      ),
                      Expanded(
                        child: AppButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: "إلغاء",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
