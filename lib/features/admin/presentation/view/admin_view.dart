import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_states.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (!authState.isAdmin) {
          return Scaffold(
            backgroundColor: AppColors.darkBackground,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Center(
                  child: GlassCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          color: AppColors.error,
                          size: 44,
                        ),
                        const SizedBox(height: 16),
                        CustomText(
                          'Admin access only',
                          variant: TextVariant.headingSmall,
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          'Your account does not have permission to open this page.',
                          variant: TextVariant.bodyMedium,
                          tone: TextTone.secondary,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        AppButton(
                          text: 'Back to home',
                          isFullWidth: true,
                          onPressed: () => context.go('/home'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          appBar: AppBar(
            title: const Text('Admin Dashboard'),
            backgroundColor: AppColors.darkBackground,
            foregroundColor: AppColors.darkTextPrimary,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'Welcome, ${authState.name ?? 'Admin'}',
                          variant: TextVariant.headingSmall,
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          'Use this area for admin-only features like managing products, orders, and users.',
                          variant: TextVariant.bodyMedium,
                          tone: TextTone.secondary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _AdminActionCard(
                    icon: Icons.inventory_2_outlined,
                    title: 'Products',
                    subtitle: 'Add, update, or remove store products.',
                  ),
                  const SizedBox(height: 12),
                  const _AdminActionCard(
                    icon: Icons.receipt_long_outlined,
                    title: 'Orders',
                    subtitle: 'Review customer orders and update statuses.',
                  ),
                  const SizedBox(height: 12),
                  const _AdminActionCard(
                    icon: Icons.group_outlined,
                    title: 'Users',
                    subtitle: 'View users and manage account roles.',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AdminActionCard extends StatelessWidget {
  const _AdminActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Icon(icon, color: AppColors.neonBlue),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(title, variant: TextVariant.labelMedium),
                const SizedBox(height: 4),
                CustomText(
                  subtitle,
                  variant: TextVariant.bodySmall,
                  tone: TextTone.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
