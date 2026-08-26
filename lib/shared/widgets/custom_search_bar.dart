import 'package:athar/shared/theme/app_color.dart';
import 'package:athar/shared/theme/app_radius.dart';
import 'package:athar/shared/theme/app_shadows.dart';
import 'package:athar/shared/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  final String hintText;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onTap,
    this.hintText = "ابحث في المنتجات",
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool isFocused = false;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surface = AppColors.surface(context);
    final border = AppColors.border(context);
    final textPrimary = AppColors.textPrimary(context);
    final textSecondary = AppColors.textSecondary(context);

    return AnimatedContainer(
      duration: 200.ms,
      height: AppSpacing.xxl,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isFocused ? AppColors.neonBlue : border,
          width: 1.5,
        ),

        boxShadow: isFocused
            ? [
                AppShadows.soft[0].copyWith(
                  color: AppColors.neonBlue.withValues(alpha: .25),
                ),
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md - 1),
        child: TextField(
          focusNode: _focusNode,
          controller: widget.controller,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          style: TextStyle(color: textPrimary, fontSize: 14),
          textAlignVertical: TextAlignVertical.center,
          cursorColor: AppColors.neonBlue,
          decoration: InputDecoration(
            filled: true,
            fillColor: surface,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: textSecondary,
              fontSize: 14,
            ),

            prefixIcon: Icon(
              Icons.search,
              color: isFocused ? AppColors.neonBlue : Colors.grey.shade500,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
