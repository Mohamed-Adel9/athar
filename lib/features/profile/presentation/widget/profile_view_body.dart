import 'package:athar/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:athar/features/profile/presentation/cubit/profile_states.dart';
import 'package:athar/features/profile/presentation/widget/stat_item.dart';
import 'package:athar/shared/theme/app_radius.dart';
import 'package:athar/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../../shared/widgets/glass_card.dart';

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

                            Row(
                              children: [
                                StatItem(
                                  label: "طلباتي",
                                  value: "${state.orders}",
                                ),
                                StatItem(
                                  label: "تصاميمي",
                                  value: "${state.designs}",
                                ),
                                StatItem(
                                  label: "مفضلاتي",
                                  value: "${state.wishlist}",
                                ),
                              ],
                            ),
                            SizedBox(height: 15),

                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => ProfileListTile(
                                icon: cubit.settings[index].icon,
                                text: cubit.settings[index].title,
                                onPressed: cubit.settings[index].onTap,
                              ),
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 15),
                              itemCount: 3,
                            ),
                            SizedBox(height: 15),

                            AppButton(
                              text: "تسجيل الخروج",
                              isSecondary: true,
                              isFullWidth: true,
                            ),
                          ],
                        ),
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
}

class ProfileListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onPressed;
  const ProfileListTile({
    super.key,
    required this.icon,
    required this.text,
    this.onPressed,
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
            color: AppColors.neonBlue.withValues(alpha: .55),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, color: AppColors.darkTextPrimary),
        ),
        title: CustomText(text),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
