import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../shared/theme/app_color.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_image.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_states.dart';
import '../../data/models/admin_dashboard_model.dart';
import '../cubit/admin_cubit.dart';
import '../cubit/admin_state.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (!authState.isAdmin) return const _AdminLockedView();

        return BlocProvider(
          create: (_) => sl<AdminCubit>()..fetchDashboard(),
          child: _AdminDashboard(name: authState.name ?? 'Admin'),
        );
      },
    );
  }
}

class _AdminLockedView extends StatelessWidget {
  const _AdminLockedView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
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
                  const CustomText(
                    'Admin access only',
                    variant: TextVariant.headingSmall,
                  ),
                  const SizedBox(height: 8),
                  const CustomText(
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
}

class _AdminDashboard extends StatelessWidget {
  const _AdminDashboard({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        title: const CustomText(
          'لوحة التحكم',
          variant: TextVariant.headingMedium,
        ),
        backgroundColor: AppColors.background(context),
        foregroundColor: AppColors.textPrimary(context),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => context.read<AdminCubit>().fetchDashboard(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          final dashboard = state.dashboard;
          return RefreshIndicator(
            onRefresh: () => context.read<AdminCubit>().fetchDashboard(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _WelcomePanel(name: name),
                        if (state.status == AdminStatus.loading) ...[
                          const SizedBox(height: 12),
                          const LinearProgressIndicator(minHeight: 2),
                        ],
                        if (state.errorMessage != null) ...[
                          const SizedBox(height: 12),
                          _ErrorPanel(message: state.errorMessage!),
                        ],
                        const SizedBox(height: 16),
                        _StatsGrid(dashboard: dashboard),
                        const SizedBox(height: 16),
                        _ChartSection(dashboard: dashboard),
                        const SizedBox(height: 16),
                        _SummaryLists(dashboard: dashboard),
                        const SizedBox(height: 16),
                        _LatestProducts(products: dashboard.latestProducts),
                        const SizedBox(height: 16),
                        _RecentOrders(orders: dashboard.recentOrders),
                        const SizedBox(height: 16),
                        const _AdminModules(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4E73DF), Color(0xFF6F42C1)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4E73DF).withValues(alpha: .24),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'Welcome, $name',
                  variant: TextVariant.headingSmall,
                  tone: TextTone.inverse,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                const CustomText(
                  'Here is what is happening with your store today.',
                  variant: TextVariant.bodySmall,
                  tone: TextTone.inverse,
                ),
              ],
            ),
          ),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.dashboard_customize_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: 10),
          Expanded(
            child: CustomText(
              message,
              variant: TextVariant.bodySmall,
              tone: TextTone.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.dashboard});

  final AdminDashboardModel dashboard;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _StatConfig('Total Products', dashboard.totalProducts, Icons.inventory_2_outlined, const [Color(0xFF4E73DF), Color(0xFF224ABE)]),
      _StatConfig('Featured Products', dashboard.featuredProducts, Icons.star_outline, const [Color(0xFF1CC88A), Color(0xFF13855C)]),
      _StatConfig('Categories', dashboard.totalCategories, Icons.layers_outlined, const [Color(0xFF36B9CC), Color(0xFF258391)]),
      _StatConfig('Reviews', dashboard.totalReviews, Icons.reviews_outlined, const [Color(0xFFF6C23E), Color(0xFFDDA20A)]),
      _StatConfig('Design Stickers', dashboard.totalDesignStickers, Icons.mood_outlined, const [Color(0xFFE83E8C), Color(0xFFA61E58)]),
      _StatConfig('Saved Designs', dashboard.totalSavedDesigns, Icons.save_outlined, const [Color(0xFF20C997), Color(0xFF0F766E)]),
      _StatConfig('Cart Items', dashboard.totalCartItems, Icons.shopping_bag_outlined, const [Color(0xFFFD7E14), Color(0xFFC2410C)]),
      _StatConfig('Orders', dashboard.totalOrders, Icons.receipt_long_outlined, const [Color(0xFF6F42C1), Color(0xFF4E2A84)]),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 720 ? 4 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 128,
          ),
          itemBuilder: (context, index) => _StatCard(config: cards[index]),
        );
      },
    );
  }
}

class _StatConfig {
  const _StatConfig(this.label, this.value, this.icon, this.colors);

  final String label;
  final int value;
  final IconData icon;
  final List<Color> colors;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.config});

  final _StatConfig config;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: config.colors),
                ),
                child: Icon(config.icon, color: Colors.white, size: 22),
              ),
              const Spacer(),
              Flexible(
                child: CustomText(
                  '${config.value}',
                  variant: TextVariant.headingSmall,
                  tone: TextTone.primary,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          CustomText(
            config.label,
            variant: TextVariant.labelMedium,
            tone: TextTone.secondary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  const _ChartSection({required this.dashboard});

  final AdminDashboardModel dashboard;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FeaturedAnalysis(
          featured: dashboard.featuredProducts,
          normal: dashboard.normalProducts,
        ),
        const SizedBox(height: 12),
        _MonthlyOrdersChart(
          months: dashboard.months,
          values: dashboard.monthsCount,
        ),
      ],
    );
  }
}

class _FeaturedAnalysis extends StatelessWidget {
  const _FeaturedAnalysis({required this.featured, required this.normal});

  final int featured;
  final int normal;

  @override
  Widget build(BuildContext context) {
    final total = featured + normal;
    final percent = total == 0 ? 0.0 : featured / total;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            'Featured Products Analysis',
            variant: TextVariant.titleMedium,
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 12,
              backgroundColor: Colors.white.withValues(alpha: .12),
              valueColor: const AlwaysStoppedAnimation(AppColors.success),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _LegendValue(label: 'Featured', value: featured)),
              Expanded(child: _LegendValue(label: 'Normal', value: normal)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthlyOrdersChart extends StatelessWidget {
  const _MonthlyOrdersChart({required this.months, required this.values});

  final List<String> months;
  final List<int> values;

  @override
  Widget build(BuildContext context) {
    final count = months.length < values.length ? months.length : values.length;
    final maxValue = values.isEmpty
        ? 1
        : values.reduce((a, b) => a > b ? a : b).clamp(1, 999999).toInt();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            'Monthly Sales - Orders',
            variant: TextVariant.titleMedium,
          ),
          const SizedBox(height: 14),
          if (count == 0)
            const CustomText(
              'No monthly order data yet.',
              variant: TextVariant.bodySmall,
              tone: TextTone.secondary,
            )
          else
            SizedBox(
              height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var index = 0; index < count; index++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _BarValue(
                          label: months[index],
                          value: values[index],
                          maxValue: maxValue,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _BarValue extends StatelessWidget {
  const _BarValue({
    required this.label,
    required this.value,
    required this.maxValue,
  });

  final String label;
  final int value;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    final ratio = value / maxValue;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomText(
          '$value',
          variant: TextVariant.captionSmall,
          tone: TextTone.secondary,
        ),
        const SizedBox(height: 6),
        Flexible(
          child: FractionallySizedBox(
            heightFactor: ratio.clamp(.08, 1).toDouble(),
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        CustomText(
          label,
          variant: TextVariant.captionSmall,
          tone: TextTone.secondary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _LegendValue extends StatelessWidget {
  const _LegendValue({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, variant: TextVariant.labelSmall, tone: TextTone.secondary),
        const SizedBox(height: 4),
        CustomText('$value', variant: TextVariant.headingSmall),
      ],
    );
  }
}

class _SummaryLists extends StatelessWidget {
  const _SummaryLists({required this.dashboard});

  final AdminDashboardModel dashboard;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RankedList(
          title: 'Top Categories',
          headers: const ['Category', 'Products'],
          rows: dashboard.topCategories
              .map((item) => [item.name, '${item.total}'])
              .toList(),
        ),
        const SizedBox(height: 12),
        _RankedList(
          title: 'Top Colors',
          headers: const ['Color', 'Total'],
          rows: dashboard.topColors
              .map((item) => [item.name, '${item.total}'])
              .toList(),
        ),
      ],
    );
  }
}

class _RankedList extends StatelessWidget {
  const _RankedList({
    required this.title,
    required this.headers,
    required this.rows,
  });

  final String title;
  final List<String> headers;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(title, variant: TextVariant.titleMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomText(
                  headers.first,
                  variant: TextVariant.labelSmall,
                  tone: TextTone.secondary,
                ),
              ),
              CustomText(
                headers.last,
                variant: TextVariant.labelSmall,
                tone: TextTone.secondary,
              ),
            ],
          ),
          Divider(color: AppColors.border(context)),
          if (rows.isEmpty)
            const CustomText(
              'No data yet.',
              variant: TextVariant.bodySmall,
              tone: TextTone.secondary,
            )
          else
            ...rows.map(
              (row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        row.first.isEmpty ? '-' : row.first,
                        variant: TextVariant.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    CustomText(row.last, variant: TextVariant.bodySmall),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LatestProducts extends StatelessWidget {
  const _LatestProducts({required this.products});

  final List<AdminLatestProductModel> products;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText('Latest Products', variant: TextVariant.titleMedium),
          const SizedBox(height: 12),
          if (products.isEmpty)
            const CustomText(
              'No products yet.',
              variant: TextVariant.bodySmall,
              tone: TextTone.secondary,
            )
          else
            ...products.take(6).map((product) => _ProductRow(product: product)),
        ],
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.product});

  final AdminLatestProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AppImage(
              source: product.image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  product.name.isEmpty ? '-' : product.name,
                  variant: TextVariant.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (product.createdAt != null)
                  CustomText(
                    product.createdAt!,
                    variant: TextVariant.captionSmall,
                    tone: TextTone.secondary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentOrders extends StatelessWidget {
  const _RecentOrders({required this.orders});

  final List<AdminRecentOrderModel> orders;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText('Recent Orders', variant: TextVariant.titleMedium),
          const SizedBox(height: 12),
          if (orders.isEmpty)
            const CustomText(
              'No recent orders yet.',
              variant: TextVariant.bodySmall,
              tone: TextTone.secondary,
            )
          else
            ...orders.take(6).map((order) => _OrderRow(order: order)),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order});

  final AdminRecentOrderModel order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.neonBlue.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomText(
              '#${order.id}',
              variant: TextVariant.captionSmall,
              tone: TextTone.neonBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  order.customer?.isNotEmpty == true
                      ? order.customer!
                      : 'Customer',
                  variant: TextVariant.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                CustomText(
                  order.paymentStatus.isNotEmpty
                      ? '${order.status} • ${order.paymentStatus}'
                      : order.status,
                  variant: TextVariant.captionSmall,
                  tone: TextTone.secondary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (order.isInstapay)
                  const CustomText(
                    'InstaPay proof',
                    variant: TextVariant.captionSmall,
                    tone: TextTone.neonBlue,
                  ),
              ],
            ),
          ),
          CustomText(
            '${order.total.toStringAsFixed(0)} ج.م',
            variant: TextVariant.labelSmall,
            tone: TextTone.neonBlue,
          ),
        ],
      ),
    );
  }
}

class _AdminModules extends StatelessWidget {
  const _AdminModules();

  @override
  Widget build(BuildContext context) {
    final modules = const [
      _ModuleConfig('Storefront', Icons.storefront_outlined, 'Sliders, banners, pages, designs, reviews'),
      _ModuleConfig('Catalog', Icons.category_outlined, 'Category types, categories, products, colors, sizes'),
      _ModuleConfig('Sales', Icons.point_of_sale_outlined, 'Orders, deliveries, promo codes'),
      _ModuleConfig('Customers', Icons.group_outlined, 'Users and addresses'),
      _ModuleConfig('Communication', Icons.mark_email_unread_outlined, 'Messages, newsletters, contacts'),
      _ModuleConfig('Settings', Icons.settings_outlined, 'General dashboard settings'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: CustomText('Dashboard Navigation', variant: TextVariant.titleMedium),
        ),
        const SizedBox(height: 10),
        for (final module in modules) ...[
          _ModuleTile(module: module),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _ModuleConfig {
  const _ModuleConfig(this.title, this.icon, this.subtitle);

  final String title;
  final IconData icon;
  final String subtitle;
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({required this.module});

  final _ModuleConfig module;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: 15,
      type: GlassCardType.secondary,
      child: ListTile(
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.neonBlue.withValues(alpha: .25),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(module.icon, color: AppColors.neonBlue),
        ),
        title: CustomText(module.title, variant: TextVariant.labelMedium),
        subtitle: CustomText(
          module.subtitle,
          variant: TextVariant.captionSmall,
          tone: TextTone.secondary,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(
          Icons.chevron_left,
          color: AppColors.textSecondary(context),
        ),
      ),
    );
  }
}
