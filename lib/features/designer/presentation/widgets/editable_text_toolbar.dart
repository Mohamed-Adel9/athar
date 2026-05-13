import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../cubit/designer_cubit.dart';
import '../cubit/designer_state.dart';

class EditableTextToolbar extends StatelessWidget {
  const EditableTextToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignerCubit, DesignerState>(
      builder: (context, state) {
        final style = state.activeTextStyle;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            children: [
              Slider(
                value: style.fontSize,
                min: 12,
                max: 72,
                onChanged: (v) {
                  context.read<DesignerCubit>().updateFontSize(v);
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<DesignerCubit>().toggleBold();
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: style.isBold
                              ? AppColors.neonBlue
                              : Colors.white.withOpacity(.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.format_bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<DesignerCubit>().toggleItalic();
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: style.isItalic
                              ? AppColors.neonPurple
                              : Colors.white.withOpacity(.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.format_italic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
