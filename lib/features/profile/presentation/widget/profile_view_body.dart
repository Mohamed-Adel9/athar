import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/snack_bar_service.dart';
import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_image.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../designer/data/models/saved_design_model.dart';
import '../../data/models/profile_order_model.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_states.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        final authState = context.watch<AuthCubit>().state;
        final displayName = state.name.isNotEmpty
            ? state.name
            : (authState.name ?? 'User');
        final displayEmail = state.email.isNotEmpty
            ? state.email
            : (authState.email ?? '');

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () => cubit.fetchProfile(wishlistCount: state.wishlist),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(14),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          displayName,
                                          variant: TextVariant.headingSmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (displayEmail.isNotEmpty)
                                          CustomText(
                                            displayEmail,
                                            variant: TextVariant.bodySmall,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => cubit.fetchProfile(
                                      wishlistCount: state.wishlist,
                                    ),
                                    icon: const Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              if (state.status == ProfileStatus.loading) ...[
                                const SizedBox(height: 12),
                                const LinearProgressIndicator(minHeight: 2),
                              ],
                              if (state.errorMessage != null) ...[
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: AppColors.error,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: CustomText(
                                        state.errorMessage!,
                                        variant: TextVariant.labelSmall,
                                        tone: TextTone.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const Divider(
                                color: AppColors.darkTextSecondary,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _StatItem(
                                    label: 'طلباتي',
                                    value: '${state.orders}',
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
                                    label: 'تصاميمي',
                                    value: '${state.designs}',
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
                                    label: 'مفضلتي',
                                    value: '${state.wishlist}',
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
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _buildSection(state, context),
                        ),
                        const SizedBox(height: 16),
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
                        if (authState.isAdmin) ...[
                          const SizedBox(height: 12),
                          _ProfileListTile(
                            icon: Icons.admin_panel_settings_outlined,
                            text: 'Admin Dashboard',
                            onTap: () => context.go('/admin'),
                          ),
                        ],
                        const SizedBox(height: 24),
                        AppButton(
                          text: 'تسجيل الخروج',
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
        return _OrdersSection(
          key: const ValueKey('orders'),
          orders: state.orderItems,
        );
      case ProfileSection.designs:
        return _DesignsSection(
          key: const ValueKey('designs'),
          designs: state.savedDesigns,
        );
      case ProfileSection.wishlist:
        return const _WishlistSection(key: ValueKey('wishlist'));
      case ProfileSection.settings:
        return const _SettingsSection(key: ValueKey('settings'));
      case ProfileSection.none:
        return const SizedBox.shrink(key: ValueKey('none'));
    }
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.onTap,
    this.isActive = false,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isActive;

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
  const _ProfileListTile({
    required this.icon,
    required this.text,
    this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final bool isActive;

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

class _OrdersSection extends StatelessWidget {
  const _OrdersSection({super.key, required this.orders});

  final List<ProfileOrderModel> orders;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText('طلباتي', variant: TextVariant.headingSmall),
          const SizedBox(height: 12),
          if (orders.isEmpty)
            const _EmptySectionMessage(text: 'لا توجد طلبات حتى الآن')
          else
            ...orders.expand(
              (order) => [
                _OrderItem(
                  orderId: '#${order.id}',
                  status: order.status,
                  date: order.createdAt ?? '',
                  total: '${order.total.toStringAsFixed(0)} ج.م',
                  statusColor: _statusColor(order.status),
                ),
                if (order != orders.last) const Divider(height: 16),
              ],
            ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    final normalized = status.toLowerCase();
    if (normalized.contains('deliver') || normalized.contains('complete')) {
      return AppColors.success;
    }
    if (normalized.contains('cancel') || normalized.contains('fail')) {
      return AppColors.error;
    }
    return Colors.orange;
  }
}

class _OrderItem extends StatelessWidget {
  const _OrderItem({
    required this.orderId,
    required this.status,
    required this.date,
    required this.total,
    required this.statusColor,
  });

  final String orderId;
  final String status;
  final String date;
  final String total;
  final Color statusColor;

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
  const _DesignsSection({super.key, required this.designs});

  final List<SavedDesignModel> designs;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            'تصاميمي المحفوظة',
            variant: TextVariant.headingSmall,
          ),
          const SizedBox(height: 12),
          if (designs.isEmpty)
            const _EmptySectionMessage(text: 'لا توجد تصاميم محفوظة بعد')
          else
            SizedBox(
              height: 116,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: designs.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final design = designs[index];
                  return SizedBox(
                    width: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AppImage(
                            source: design.previewImage,
                            width: 130,
                            height: 78,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 6),
                        CustomText(
                          design.name,
                          variant: TextVariant.labelSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
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
              const CustomText('المفضلة', variant: TextVariant.headingSmall),
              TextButton(
                onPressed: () => context.go('/wishlist'),
                child: const CustomText(
                  'عرض الكل',
                  variant: TextVariant.labelMedium,
                  tone: TextTone.neonBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const CustomText(
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
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.isUpdating != current.isUpdating ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText('الإعدادات', variant: TextVariant.headingSmall),
              const SizedBox(height: 16),
              const CustomText(
                'الاسم',
                variant: TextVariant.labelMedium,
                tone: TextTone.secondary,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'أدخل اسمك',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const CustomText(
                'البريد الإلكتروني',
                variant: TextVariant.labelMedium,
                tone: TextTone.secondary,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'أدخل بريدك الإلكتروني',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                text: state.isUpdating ? 'جاري الحفظ...' : 'حفظ التغييرات',
                isFullWidth: true,
                onPressed: state.isUpdating
                    ? null
                    : () async {
                        final success = await context
                            .read<ProfileCubit>()
                            .updateProfile(
                              name: _nameCtrl.text.trim(),
                              email: _emailCtrl.text.trim(),
                            );
                        if (!context.mounted) return;
                        if (!success) {
                          final error = context
                              .read<ProfileCubit>()
                              .state
                              .errorMessage;
                          SnackBarService.failure(
                            context: context,
                            message:
                                error ?? 'لم يتم حفظ التغييرات. حاول مرة أخرى',
                          );
                          return;
                        }
                        SnackBarService.success(
                          context: context,
                          message: 'تم حفظ التغييرات بنجاح',
                        );
                      },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptySectionMessage extends StatelessWidget {
  const _EmptySectionMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomText(
        text,
        variant: TextVariant.bodyMedium,
        tone: TextTone.secondary,
      ),
    );
  }
}
