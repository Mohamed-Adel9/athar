import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/snack_bar_service.dart';
import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_states.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Profile Header
                      GlassCard(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 25,
                                  child: FaIcon(
                                    FontAwesomeIcons.user,
                                    color: AppColors.darkTextPrimary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      state.name,
                                      variant: TextVariant.headingSmall,
                                    ),
                                    CustomText(
                                      state.email,
                                      variant: TextVariant.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(color: AppColors.darkTextSecondary),
                            // Stats Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _StatItem(
                                  label: "طلباتي",
                                  value: "${state.orders}",
                                  onTap: () => cubit.selectSection(
                                    state.selectedSection ==
                                            ProfileSection.orders
                                        ? ProfileSection.none
                                        : ProfileSection.orders,
                                  ),
                                  isActive:
                                      state.selectedSection ==
                                      ProfileSection.orders,
                                ),
                                _StatItem(
                                  label: "تصاميمي",
                                  value: "${state.designs}",
                                  onTap: () => cubit.selectSection(
                                    state.selectedSection ==
                                            ProfileSection.designs
                                        ? ProfileSection.none
                                        : ProfileSection.designs,
                                  ),
                                  isActive:
                                      state.selectedSection ==
                                      ProfileSection.designs,
                                ),
                                _StatItem(
                                  label: "مفضلاتي",
                                  value: "${state.wishlist}",
                                  onTap: () => cubit.selectSection(
                                    state.selectedSection ==
                                            ProfileSection.wishlist
                                        ? ProfileSection.none
                                        : ProfileSection.wishlist,
                                  ),
                                  isActive:
                                      state.selectedSection ==
                                      ProfileSection.wishlist,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Expandable Section
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _buildSection(state, context),
                      ),

                      const SizedBox(height: 16),

                      // Settings
                      _ProfileListTile(
                        icon: Icons.settings,
                        text: 'الإعدادات',
                        onTap: () => cubit.selectSection(
                          state.selectedSection == ProfileSection.settings
                              ? ProfileSection.none
                              : ProfileSection.settings,
                        ),
                        isActive:
                            state.selectedSection == ProfileSection.settings,
                      ),

                      const SizedBox(height: 24),

                      // Logout
                      AppButton(
                        text: "تسجيل الخروج",
                        isSecondary: true,
                        isFullWidth: true,
                        onPressed: () {
                          context.read<AuthCubit>().logout();
                          context.go('/login');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(ProfileState state, BuildContext context) {
    switch (state.selectedSection) {
      case ProfileSection.orders:
        return _OrdersSection(key: const ValueKey('orders'));
      case ProfileSection.designs:
        return _DesignsSection(key: const ValueKey('designs'));
      case ProfileSection.wishlist:
        return _WishlistSection(key: const ValueKey('wishlist'));
      case ProfileSection.settings:
        return _SettingsSection(key: const ValueKey('settings'));
      case ProfileSection.none:
        return const SizedBox.shrink(key: ValueKey('none'));
    }
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isActive;

  const _StatItem({
    required this.label,
    required this.value,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.neonBlue.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          children: [
            CustomText(
              value,
              variant: TextVariant.headingSmall,
              tone: TextTone.neonBlue,
            ),
            const SizedBox(height: 4),
            CustomText(
              label,
              variant: TextVariant.labelSmall,
              tone: TextTone.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final bool isActive;

  const _ProfileListTile({
    required this.icon,
    required this.text,
    this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: 15,
      type: GlassCardType.secondary,
      child: ListTile(
        leading: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.neonBlue.withValues(alpha: .85)
                : AppColors.neonBlue.withValues(alpha: .55),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, color: AppColors.darkTextPrimary),
        ),
        title: CustomText(text),
        trailing: AnimatedRotation(
          turns: isActive ? 0.5 : 0,
          duration: const Duration(milliseconds: 200),
          child: const Icon(Icons.arrow_forward_ios),
        ),
        onTap: onTap,
      ),
    );
  }
}

// ==================== SECTION WIDGETS ====================

class _OrdersSection extends StatelessWidget {
  const _OrdersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText('طلباتي', variant: TextVariant.headingSmall),
          const SizedBox(height: 12),
          // Mock orders
          _OrderItem(
            orderId: '#1234',
            status: 'تم التوصيل',
            date: '2024-03-15',
            total: '350 ج.م',
            statusColor: AppColors.success,
          ),
          const Divider(height: 16),
          _OrderItem(
            orderId: '#1235',
            status: 'قيد التجهيز',
            date: '2024-03-20',
            total: '520 ج.م',
            statusColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final String orderId;
  final String status;
  final String date;
  final String total;
  final Color statusColor;

  const _OrderItem({
    required this.orderId,
    required this.status,
    required this.date,
    required this.total,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(orderId, variant: TextVariant.labelMedium),
                const SizedBox(height: 4),
                CustomText(
                  date,
                  variant: TextVariant.labelSmall,
                  tone: TextTone.secondary,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                total,
                variant: TextVariant.labelMedium,
                tone: TextTone.neonBlue,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomText(
                  status,
                  variant: TextVariant.labelSmall,
                  tone: TextTone.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DesignsSection extends StatelessWidget {
  const _DesignsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText('تصاميمي المحفوظة', variant: TextVariant.headingSmall),
          const SizedBox(height: 12),
          Center(
            child: CustomText(
              'لا توجد تصاميم محفوظة بعد',
              variant: TextVariant.bodyMedium,
              tone: TextTone.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _WishlistSection extends StatelessWidget {
  const _WishlistSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText('المفضلة', variant: TextVariant.headingSmall),
              TextButton(
                onPressed: () => context.go('/wishlist'),
                child: CustomText(
                  'عرض الكل',
                  variant: TextVariant.labelMedium,
                  tone: TextTone.neonBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomText(
            'انقر "عرض الكل" لرؤية المفضلة كاملة',
            variant: TextVariant.bodySmall,
            tone: TextTone.secondary,
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatefulWidget {
  const _SettingsSection({super.key});

  @override
  State<_SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<_SettingsSection> {
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    _nameCtrl = TextEditingController(text: state.name);
    _emailCtrl = TextEditingController(text: state.email);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText('الإعدادات', variant: TextVariant.headingSmall),
          const SizedBox(height: 16),
          CustomText(
            'الاسم',
            variant: TextVariant.labelMedium,
            tone: TextTone.secondary,
          ),
          const SizedBox(height: 8),
          // AppInput would go here - using TextField for now
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              hintText: 'أدخل اسمك',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          CustomText(
            'البريد الإلكتروني',
            variant: TextVariant.labelMedium,
            tone: TextTone.secondary,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _emailCtrl,
            decoration: const InputDecoration(
              hintText: 'أدخل بريدك الإلكتروني',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'حفظ التغييرات',
            isFullWidth: true,
            onPressed: () {
              context.read<ProfileCubit>().updateProfile(
                name: _nameCtrl.text,
                email: _emailCtrl.text,
              );
              SnackBarService.success(
                context: context,
                message: 'تم حفظ التغييرات بنجاح',
              );
            },
          ),
        ],
      ),
    );
  }
}
